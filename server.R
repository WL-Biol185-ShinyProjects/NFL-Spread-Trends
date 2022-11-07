library(shiny)
library(ggplot2)
library(usmap)

df = read.csv("tidy_df.csv")

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
  
  output$heat_map = renderPlot({ plot_usmap()
    
    
  })
}