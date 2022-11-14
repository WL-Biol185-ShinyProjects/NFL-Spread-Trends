library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(stats)

df = read.csv("tidy_df.csv")
map_df = read.csv("map_df_tidy.csv")
model_df = read.csv("model_df_tidy.csv")
nfl_locations = read.csv("NFLlocations.csv")


#Define server logic fro drop down menu
function(input, output, server) { 
  
  output$sidebar_text = renderText({ "How good is your team against the spread since 2000?" })
  output$main_panel_text = renderText({"Net Wins by Location of NFL Game"})
  
  output$win_loss = renderText({ 
    
    selected_df_spread = filter(df, spread >= input$sel_spread[1], spread <= input$sel_spread[2])
    
    selected_df_team = filter(selected_df_spread, team == input$sel_team)
    
    
    win = sum(selected_df_team['difference'] > 0)
    loss = sum(selected_df_team['difference'] < 0)
    tie = sum(selected_df_team['difference'] == 0)
    
    paste('The ' , input$sel_team, " are ", win, "-", loss, "-", tie, "against spreads between ", input$sel_spread[1], " and ", input$sel_spread[2], " points.")
    
  })
  
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
      
      setView(lat = 38.5, lng = -92, zoom = 3.4) %>%
      addLegend("bottomright", pal = pal, values = ~win_pct, na.label = "No Games Played", title = "Win Percentage by Location of Game", 
                labFormat = labelFormat(between = "-", suffix = "%"), opacity = .7) %>%
      addCircles(data = nfl_locations, lng = ~longitude, lat = ~latitude, weight = 4)
  
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
      ylab("Win/Loss Margin")+ 
      ggtitle("Win/Loss Margin vs Wind Speed")

  })
}