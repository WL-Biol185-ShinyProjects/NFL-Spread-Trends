  library(shiny)
  library(dplyr)
  library(ggplot2)
  
  server = function(input, output, session) {}
  
    ui <- fluidPage(
      titlePanel("NFL team spead odds"),
      selectInput("sel_team",
                  label = "Choose an NFL Team",
                  choices = c("c", "a", "d")),
      selectInput("sel_spread",
                  label = "Choose a spread",
                  choices = c("<-12", "-12 =< x < -9", "-9 =< x < -6","-6 =< x < -3", "-3 =< x < 0", "0", "0 < x < 3", "3 =< x < 6", "6 =< x < 9", "9 =< x =< 12", ">12")),
      textOutput("win_loss")
      
    )
  
  
  shinyApp(ui = ui, server = server)