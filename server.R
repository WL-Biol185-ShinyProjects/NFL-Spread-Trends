library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)

df = read.csv("tidy_df.csv")
map_df = read.csv("map_df_tidy.csv")


#Define server logic fro drop down menu
function(input, output, server) {  
  
  output$sidebar_text = renderText({ "How good is your team against the spread?" })
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
    
    map_df = filter(map_df, team == input$sel_team)
    
    map_df = map_df %>% 
      group_by(state) %>%
      summarize(net_wins = sum(win, na.rm = TRUE))
    
    geo = geojson_read("states.geo.json", what = "sp")
    
    geo@data = left_join(geo@data, map_df, by = c("NAME" = "state"))
    
    pal = colorBin("RdYlGn", domain = geo@data$net_wins)
    
    leaflet(geo) %>%
      addPolygons(fillColor = ~pal(net_wins), 
                  weight = 1, 
                  color = "white", 
                  highlightOptions = highlightOptions(weight = 5),
                  label = ~net_wins,
                  fillOpacity = .7) %>%
      
      setView(lat = 38.5, lng = -98.3, zoom = 4) %>%
      addLegend("bottomright", pal = pal, values = ~net_wins, na.label = "No Games Played", title = "Net Wins by Location of Game", 
                labFormat = labelFormat(between = " to "), opacity = .7)
    
  })

}