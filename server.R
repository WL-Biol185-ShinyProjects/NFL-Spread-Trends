library(shiny)
library(ggplot2)
library(usmap)

df = read.csv("tidy_df.csv")
map_df = read.csv("map_df_tidy.csv")


#Define server logic fro drop down menu
function(input, output, server) { 
  
  output$win_loss = renderText({ 
    
    selected_df_spread = filter(df, spread >= input$sel_spread[1], spread <= input$sel_spread[2])
    
    selected_df_team = filter(selected_df_spread, team == input$sel_team)
    
    
    win = sum(selected_df_team['difference'] > 0)
    loss = sum(selected_df_team['difference'] < 0)
    tie = sum(selected_df_team['difference'] == 0)
    
    paste('The ' , input$sel_team, " are ", win, "-", loss, "-", tie, "against spreads between ", input$sel_spread[1], " and ", input$sel_spread[2], " points.")
    
  })
  
  output$heat_map = renderPlot({ 
    
    #map_df_selected = filter(map_df_selected, team == input$sel_team)
    
    
    plot_usmap()
    
    
  })}

