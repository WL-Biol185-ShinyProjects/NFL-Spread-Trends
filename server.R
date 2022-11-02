library(shiny)
library(ggplot2)

tidy_df = read.csv("tidy_df.csv")
    
#Define server logic fro drop down menu
server = function(input, output) {  
  win = tidy_df["team" == input$sel_team & tidy_df$diff >0]
  output$win_loss = renderText({"The", input$sel_spread, "is"
    })
  })

output$selected_team = renderText({
  paste("Select the team you would like to find out about")
})