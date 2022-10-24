library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("NFL Favorite vs Spread
             "),
  
  
  #Update SelectInput Dynamically
  observe({
    updateSelectInput(session, "sel_NFL_Team", choices = spread_df$team1)
  })
  
  
  ui <- basicPage(
    h1("NFL team"),
    selectInput(inputId = "sel_NFL_Team",
                label = "Choose NFL Team",
                "Names")
  )
  
  shinyApp(ui = ui, server = server)