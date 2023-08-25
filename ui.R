library(shiny)
library(tidyverse)
library(here)

games <- read_csv(here("games_with_vars.csv"))

fluidPage(
  
  titlePanel("Oh Hell"),
  
  sidebarPanel(
    
    sliderInput('min_num_games', 'Minimum Number of Games', min=1, max=20,
                value = 10, step=1, round=0),
    
    # selectInput('chosen_num_players', "Size of game", 
    #             c(4, 5, 6), multiple = TRUE,
    #             selected = c(4, 5, 6)),
    
    checkboxGroupInput('chosen_num_players', "Size of game",
                       c(4, 5, 6))
    
    
    #checkboxInput('jitter', 'Jitter'),
    #checkboxInput('smooth', 'Smooth'),
    
    #selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    #selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)