  library(shiny)
  library(tidyverse)
  library(leaflet)
  library(geojsonio)
  library(stats)
  library(DT)
  library(leaflegend)
  library(d3heatmap)


  df = read.csv("tidy_df.csv")
  map_df = read.csv("map_df_tidy.csv")
  model_df = read.csv("model_df_tidy.csv")
 
  

  fluidPage(
      
     titlePanel("NFL Records Analysis"),
     
      mainPanel(
        tabsetPanel(
          tabPanel("Winningness by Location",
                   sidebarPanel(
                     selectInput("sel_team2",
                                 label = "Choose an NFL Team",
                                 choices = unique(df['team']))),
                   mainPanel(
                     h3(textOutput("main_panel_text")),
                     leafletOutput('chloropleth'))),
          
          tabPanel("Outcome Predictor",
                    sidebarPanel(
                     selectInput("sel_team3",
                                 label = "Choose an NFL Team",
                                 choices = unique(df['team'])),
                     sliderInput("input_temp",
                                 label = "Select the Game Temperature (Degrees F)",
                                 min = min(model_df['temperature'], na.rm = TRUE),
                                 max = max(model_df['temperature'], na.rm = TRUE),
                                 value = 49),
                     sliderInput("input_wind",
                                 label = "Select Wind MPH",
                                 min = min(model_df['wind'], na.rm = TRUE),
                                 max = max(model_df['wind'], na.rm = TRUE),
                                 value = 21)),
                      mainPanel(
                            h2(textOutput("lm_text")),
                     
                         fluidRow(
                            splitLayout(cellWidths = c("50%", "50%"), plotOutput("linear_model_temp"), 
                            plotOutput("linear_model_wind"))),
                     
                          h3(textOutput("linear_model_significance")))
              ),
            tabPanel("Records Against the Spread",
                      sidebarPanel(
                        h3(textOutput("sidebar_text")),
                              
                        selectInput("sel_team",
                                    label = "Choose an NFL Team",
                                    choices = unique(df['team'])),
                              
                        sliderInput("sel_spread",
                                    label = "Choose a spread",
                                    min = min(df['spread']),
                                    max = max(df['spread']),
                                    value = c(-5,5))),
                        mainPanel(
                                    h2(DTOutput("win_loss_df")))),
          
          tabPanel("Score Different HeatMap",
                   mainPanel(
                     d3heatmapOutput("matrix")
                   ))
        
      )
  )
  )


        
 

      
    
