library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("NFL Favorite vs Spread!
             "),
  
  selectInput("nflTeam", "NFL Team", c("Arizona Cardinals", "Atlanta Falcons", "Baltimore Ravens", "Buffalo Bills", "Carolina Panthers", "Chicago Bears", "Cincinnati Bengals", "Cleveland Browns", "Dallas Cowboys", "Denver Broncos", "Detroit Lions", "Green Bay Packers", "Houston Texans", "Indianapolis Colts", "Jacksonville Jaguars", "Kansas City Chiefs", "Las Vegas Raiders", "Los Angeles Chargers", "Los Angeles Rams", "Miami Dolphins", "Minnesota Vikings
", "New England Patriots", "New Orleans Saints", "New York Giants", "New York Jets", "Philadelphia Eagles", "Pittsburgh Steelers", "San Francisco 49ers", "Seattle Seahawks", "Tampa Bay Buccaneers", "Tennessee Titans", "Washington Commanders"))
  
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