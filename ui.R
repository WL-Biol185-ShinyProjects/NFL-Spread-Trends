  library(shiny)
  library(dplyr)
  library(ggplot2)


  df = read.csv("tidy_df.csv")
  
    ui <- fluidPage(
      titlePanel("NFL team spead odds"),
      selectInput("sel_team",
                  label = "Choose an NFL Team",
                  choices = c("Arizona Cardinals", "Atlanta Falcons", "Baltimore Ravens", "Buffalo Bills", "Carolina Panthers", "Chicago Bears", "Cincinnati Bengals", "Cleveland Browns", "Dallas Cowboys", "Denver Broncos", "Detroit Lions", "Green Bay Packers", "Houston Texans", "Indianapolis Colts", "Jacksonville Jaguars", "Kansas City Chiefs", "Las Vegas Raiders", "Los Angeles Chargers", "Los Angeles Rams", "Miami Dolphins", "Minnesota Vikings", "New England Patriots", "New Orleans Saints", "New York Giants", "New York Jets", "Philadelphia Eagles", "Pittsburgh Steelers", "San Francisco 49ers", "Seattle Seahawks", "Tampa Bay Buccaneers", "Tennessee Titans", "Washington Commanders")),
      selectInput("sel_spread",
                  label = "Choose a spread",
                  choices = c("<-12", "-12 =< x < -9", "-9 =< x < -6","-6 =< x < -3", "-3 =< x < 0", "0", "x = 0 < x < 3", "3 =< x < 6", "6 =< x < 9", "9 =< x =< 12", ">12")),
      textOutput("win_loss")
      
    )

  
    
  shinyApp(ui = ui, server = server)