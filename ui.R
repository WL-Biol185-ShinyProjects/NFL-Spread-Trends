  library(shiny)
  library(dplyr)
  library(ggplot2)
  
  server <- function(input, output, session) {
    
    sales = read.csv("NFL_Spread_Data.csv", header = TRUE,  sep = ",")
    }
    
    #Update SelectInput Dynamically
    observe({
      updateSelectInput(session,"sel_NFL_Team", choices = spread_df$team1)
    })
    
  
  ui <- basicPage(
      h1("NFL team"),
      selectInput(inputId = "sel_NFL_Team",
                  label = "Choose NFL Team",
                  "Names")
    )
  
  shinyApp(ui = ui, server = server)