

library(shiny)
library(gt)
library(tidyverse)
library(shinyjs)

# Define UI for application
ui <- fluidPage(
  
    useShinyjs(),

    # Application title
    titlePanel("Brownlow Medal Predictor"),

    # Sidebar with a slider input for round number selection 
    sidebarLayout(
        sidebarPanel(
            numericInput("round",
                        "Round:",
                        min = 0,
                        max = 24,
                        value = 0),
            br(),
            actionButton("toggle_btn", "Show/Hide Leaderboard"),
            br(),
            hidden(
              tableOutput("leaderboard")
            )
        ),

        # Show a table of votes for the selected round
        mainPanel(
           gt_output("votes")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
    observeEvent(input$toggle_btn, {
        shinyjs::toggle("leaderboard")
    })
  
  observeEvent(input$round, {
    hide("leaderboard")
  })

    output$votes <- render_gt({
        # Load the data
        data <- read.csv("brownlow.csv")
        
        # Filter the data based on the selected round
        data <- data %>%
          filter(round == input$round) %>%
          select(game, player, club, votes) %>%
          group_by(game) %>%
          arrange(desc(votes)) %>%
          gt() %>%
          cols_move_to_start(club) %>%
          cols_label(
            player = "Player",
            club = "Club",
            votes = "Votes"
          )
        
        
        # Return the data
        data
        
    })
    output$leaderboard <- render_gt({
        # Load the data
        data <- read.csv("brownlow.csv") %>%
          filter(round <= input$round) 
        
        # Calculate the total votes for each player
        leaderboard <- data %>%
          group_by(player, club) %>%
          summarise(votes = sum(votes)) %>%
          ungroup() %>%
          arrange(desc(votes)) %>%
          head(10) %>%
          gt() %>%
          cols_label(
            player = "Player",
            club = "Club",
            votes = "Votes"
          )
          
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
