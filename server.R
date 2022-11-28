library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(stats)
library(DT)
library(leaflegend)

df = read.csv("tidy_df.csv")
map_df = read.csv("map_df_tidy.csv")
model_df = read.csv("model_df_tidy.csv")
nfl_locations = read.csv("NFLlocations.csv")

iconSet <- iconList(
  TEN_stadium = makeIcon("NFLLogos/titanslogo3.png", 40, 40),
  NYG_stadium = makeIcon("NFLLogos/giantslogo.jpg", 20, 20),
  PIT_stadium = makeIcon("NFLLogos/steelerslogo3.png", 20, 20),
  CAR_stadium = makeIcon("NFLLogos/pantherslogo2.png", 40, 40),
  BAL_stadium = makeIcon("NFLLogos/ravenslogo2.jpg", 30, 30),
  TMB_stadium = makeIcon("NFLLogos/buccaneerslogo2.png", 40, 40),
  IND_stadium = makeIcon("NFLLogos/coltslogo2.png", 40, 40),
  MIN_stadium = makeIcon("NFLLogos/vikingslogo.png", 60, 60),
  ARI_stadium = makeIcon("NFLLogos/cardinalslogo.png", 40, 40),
  DAL_stadium = makeIcon("NFLLogos/cowboyslogo.png", 30, 30),
  ATL_stadium = makeIcon("NFLLogos/falconslogo.png", 40, 40),
  NYJ_stadium = makeIcon("NFLLogos/jetslogo.png", 40, 40),
  DEN_stadium = makeIcon("NFLLogos/broncoslogo.png", 40, 40),
  MIA_stadium = makeIcon("NFLLogos/dolphinslogo.png", 40, 40),
  PHI_stadium = makeIcon("NFLLogos/eagleslogo.png", 40, 40),
  CHI_stadium = makeIcon("NFLLogos/bearslogo.png", 30, 30),
  PAT_stadium = makeIcon("NFLLogos/patriotslogo.png", 40, 40),
  WAS_stadium = makeIcon("NFLLogos/commanderslogo.png", 30, 30),
  GRB_stadium = makeIcon("NFLLogos/packerslogo.png", 40, 40),
  LAC_stadium = makeIcon("NFLLogos/chargerslogo.png", 40, 40),
  NOS_stadium = makeIcon("NFLLogos/saintslogo.png", 25, 25),
  HOU_stadium = makeIcon("NFLLogos/texanslogo.png", 40, 40),
  BUF_stadium = makeIcon("NFLLogos/billslogo.png", 60, 60),
  SAF_stadium = makeIcon("NFLLogos/fortyninerslogo.png", 40, 40),
  JAX_stadium = makeIcon("NFLLogos/jaguarslogo.png", 40, 40),
  CLE_stadium = makeIcon("NFLLogos/brownslogo.png", 40, 40),
  LAV_stadium = makeIcon("NFLLogos/raiderslogo.png", 40, 40),
  KAC_stadium = makeIcon("NFLLogos/chiefslogo.png", 35, 35),
  STL_stadium = makeIcon("NFLLogos/ramslogo2.png", 40, 40),
  SEA_stadium = makeIcon("NFLLogos/seahawkslogo.png", 40, 40),
  CIN_stadium = makeIcon("NFLLogos/bengalslogo.png", 30, 30),
  DET_stadium = makeIcon("NFLLogos/lionslogo.png", 40, 40)
  
)

#Define server logic fro drop down menu
function(input, output, server) { 
  
  output$sidebar_text = renderText({ "How good is your team against the spread since 2000?" })
  output$main_panel_text = renderText({"Win Percentage by Location of NFL Game"})
  
  
  output$win_loss_df = renderDT({
    
    selected_df_spread = filter(df, spread >= input$sel_spread[1], spread <= input$sel_spread[2])
    
    selected_df_team = filter(selected_df_spread, team == input$sel_team)
    
    
    win = sum(selected_df_team['difference'] > 0)
    loss = sum(selected_df_team['difference'] < 0)
    tie = sum(selected_df_team['difference'] == 0)
    
    spread_win_loss_df = data.frame(matrix(ncol = 0, nrow = 1))
    
    spread_win_loss_df$Wins = win
    spread_win_loss_df$Losses = loss
    spread_win_loss_df$Ties = tie
    
     
    spread_win_loss_df
      }, rownames = FALSE, options = list(dom = 't'))
  
  output$chloropleth = renderLeaflet({ 
    
    map_df = filter(map_df, team == input$sel_team2)
    
    map_df = map_df %>% 
      group_by(state) %>%
      summarize(win_pct = mean(win, na.rm = TRUE) * 100)
    
    geo = geojson_read("states.geo.json", what = "sp")
    
    geo@data = left_join(geo@data, map_df, by = c("NAME" = "state"))
    
    pal = colorBin("RdYlGn", domain = geo@data$win_pct)
    
    leaflet(geo) %>%
      addPolygons(fillColor = ~pal(win_pct), 
                  weight = 1, 
                  color = "white", 
                  highlightOptions = highlightOptions(weight = 5),
                  label = ~win_pct,
                  fillOpacity = .7) %>%
      
      setView(lat = 38.5, lng = -80, zoom = 3.4) %>%
      leaflet::addLegend("bottomright", pal = pal, values = ~win_pct, na.label = "No Games Played", title = "Win Percentage by Location of Game", 
                labFormat = labelFormat(between = "-", suffix = "%"), opacity = .7) %>%
      addMarkers(data = nfl_locations, lng = ~longitude, lat = ~latitude, icon=iconSet)
  
  })
  output$linear_model_temp = renderPlot({
    
    linear_model_df = filter(model_df, team == input$sel_team3)
    
    linear_model = lm(data = linear_model_df, difference ~ wind + temperature)
    
    ggplot(data = linear_model_df, mapping = aes(x = temperature, y = difference)) + 
      geom_point(alpha = .5, size = 3, color = 'dodgerblue2') + 
      geom_abline(intercept = coef(linear_model)["(Intercept)"], slope = coef(linear_model)["temperature"], size = 2, alpha = .7) +
      xlab("Tempature (Degrees F)") +
      ylab("Win/Loss Margin") + 
      ggtitle("Win/Loss Margin vs Temperature")
    
  })
  
  output$linear_model_wind = renderPlot({
    
    linear_model_df = filter(model_df, team == input$sel_team3)
    
    linear_model = lm(data = linear_model_df, difference ~ wind + temperature)
    
    ggplot(data = linear_model_df, mapping = aes(x = wind, y = difference)) + 
      geom_point(alpha = .5, size = 3, color = 'dodgerblue2') + 
      geom_abline(intercept = coef(linear_model)["(Intercept)"], slope = coef(linear_model)["wind"], size = 2, alpha = .7) + 
      xlab("Wind (MPH)") +
      ylab("Win/Loss Margin") + 
      ggtitle("Win/Loss Margin vs Wind Speed")

  })
  
  output$linear_model_significance = renderText({
    
    linear_model_df = filter(model_df, team == input$sel_team3)
    
    linear_model = lm(data = linear_model_df, difference ~ wind + temperature)
    
    linear_model_significances = summary(linear_model)$coefficients[, 4]
    
    if (linear_model_significances["temperature"] > 0.05 && linear_model_significances["wind"] > 0.05){
      paste("Neither temperature nor wind significantly affect the chances of the ", input$sel_team3, " winning.")
      
    } else if (linear_model_significances["temperature"] < 0.05 && linear_model_significances["wind"] > 0.05){
      paste("Only temperature significantly affects the chances of the ", input$sel_team3, " winning.")
      
    } else if (linear_model_significances["temperature"] > 0.05 && linear_model_significances["wind"] < 0.05){
      paste("Only wind speed significantly affects the chances of the ", input$sel_team3, " winning.")
      
    } else {
      paste("Both temperature and wind speed significantly affect the chances of the ", input$sel_team3, " winning.")
    }
  
  })
  
  output$lm_text = renderText({"Do Wind or Temperature Significantly affect Your Team's Chances of Winning a Game?"})
}