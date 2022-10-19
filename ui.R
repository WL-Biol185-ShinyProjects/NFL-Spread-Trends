library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("NFL Favorite vs Spread
             "),
  
  
  #Update SelectInput Dynamically
  observe({
    updateSelectInput(session, "sel_NFL_Team", choices = sales$SalesRep)
  })
  
  
  ui <- basicPage(
    h1("NFL team"),
    selectInput(inputId = "sel_SalesRep",
                label = "Choose NFL Team",
                "Names")
  )
  
  shinyApp(ui = ui, server = server)