  library(shiny)
  library(dplyr)
  library(ggplot2)
  library(usmap)
  
  df = read.csv("tidy_df.csv")
  map_df = read.csv("map_df_tidy.csv")
  
    fluidPage(
      titlePanel("How good is each NFL team against the spread since 2000?"),
      
      sidebarLayout(
        sidebarPanel(
          selectInput("sel_team",
                      label = "Choose an NFL Team",
                      choices = unique(df['team'])),
          
          sliderInput("sel_spread",
                      label = "Choose a spread",
                      min = min(df['spread']),
                      max = max(df['spread']),
                      value = c(-5,5)),
          
          textOutput("win_loss")),

        mainPanel(plotOutput('heat_map'))
        
      )

      
    )
