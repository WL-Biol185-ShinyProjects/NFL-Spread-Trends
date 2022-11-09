  library(shiny)
  library(tidyverse)
  library(leaflet)
  library(geojsonio)


  df = read.csv("tidy_df.csv")
  map_df = read.csv("map_df_tidy.csv")
 

  fluidPage(
      titlePanel("How good is your NFL team since 2000?"),
      
      sidebarLayout(
        sidebarPanel(
          
          textOutput("sidebar_text"),
          
          selectInput("sel_team",
                      label = "Choose an NFL Team",
                      choices = unique(df['team'])),
          
          sliderInput("sel_spread",
                      label = "Choose a spread",
                      min = min(df['spread']),
                      max = max(df['spread']),
                      value = c(-5,5)),
          
          textOutput("win_loss")),

        mainPanel(
          h3(textOutput("main_panel_text")),
          leafletOutput('chloropleth'))
        
      )

      
    )
