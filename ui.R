library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("NFL Favorite vs Spread
             "),
  
  sales = read.csv("Sales_Sample.csv", header = TRUE,  sep = ",")
  
  #Summarize Data and then Plot
  data <- reactive({
    req(input$sel_SalesRep)
    df <- sales %>% filter(SalesRep %in% input$sel_SalesRep) %>%  group_by(QTR) %>% summarise(Sales = sum(Sales))
  })
  
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