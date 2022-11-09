  library(shiny)
  library(dplyr)
  library(ggplot2)
<<<<<<< HEAD

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
=======
  library(usmap)
  
  df = read.csv("tidy_df.csv")
  map_df = read.csv("map_df_tidy.csv")
  
    fluidPage(
      titlePanel("How good is each NFL team against the spread since 2000?"),
>>>>>>> 811e38a7878957e379fd6dbb45d763785ba60b57
      
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
