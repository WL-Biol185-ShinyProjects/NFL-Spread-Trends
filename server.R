library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(stats)
library(DT)
library(leaflegend)
library(d3heatmap)
library(paletteer)

df = read.csv("tidy_df.csv")
map_df = read.csv("map_df_tidy.csv")
model_df = read.csv("model_df_tidy.csv")
nfl_locations = read.csv("NFLlocations.csv")
matrix_df = read.csv("matrix_df.csv")

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
      leaflet::addLegend("bottomright", pal = pal, values = ~win_pct, na.label = "No Games Played", title = "Win Percentage", 
                labFormat = labelFormat(between = "-", suffix = "%"), opacity = .7) %>%
      addCircles(data = nfl_locations, lng = ~longitude, lat = ~latitude, weight = 4) %>%
      addLegend("bottomleft", labels = "Locations of NFL Stadiums", color = "blue")
  
  })
  output$linear_model_temp = renderPlot({
    
    linear_model_df = filter(model_df, team == input$sel_team3)
    
    linear_model = lm(data = linear_model_df, difference ~ wind + temperature)
    
    ggplot(data = linear_model_df, mapping = aes(x = temperature, y = difference)) + 
      geom_point(alpha = .5, size = 3, color = 'dodgerblue2') + 
      geom_abline(intercept = coef(linear_model)["(Intercept)"], slope = coef(linear_model)["temperature"], linewidth = 2, alpha = .7) +
      xlab("Tempature (Degrees F)") +
      ylab("Win/Loss Margin") + 
      ggtitle("Win/Loss Margin vs Temperature")
    
  })
  
  output$linear_model_wind = renderPlot({
    
    linear_model_df = filter(model_df, team == input$sel_team3)
    
    linear_model = lm(data = linear_model_df, difference ~ wind + temperature)
    
    ggplot(data = linear_model_df, mapping = aes(x = wind, y = difference)) + 
      geom_point(alpha = .5, size = 3, color = 'dodgerblue2') + 
      geom_abline(intercept = coef(linear_model)["(Intercept)"], slope = coef(linear_model)["wind"], linewidth = 2, alpha = .7) + 
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
  
  output$matrix = renderD3heatmap({d3heatmap(matrix_df, labRow = matrix_df$team_home, dendrogram = "none", colors = "Blues")
  })
    

}