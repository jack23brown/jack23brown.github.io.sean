library(shiny)
library(tidyverse)
library(here)

function(input, output) {
  
  games <- read_csv(here("games_with_vars.csv"))
  
  output$plot <- renderPlot({
    
    
    games_filtered <- games %>% 
      filter(num_players %in% input$chosen_num_players)
    
    valid_players <- games_filtered %>% 
      distinct(game, player) %>% 
      count(player) %>% 
      filter(n >= input$min_num_games) %>% 
      pull(player)
    
    games_filtered <- games_filtered %>% 
      filter(player %in% valid_players)
    
    median_num_games <- games_filtered %>% 
      distinct(player, game) %>% 
      count(player) %>% 
      summarise(median_num_games = median(n)) %>% 
      pull(median_num_games)
    
    game_averages <- games_filtered %>% 
      group_by(game, player) %>% 
      summarise(score = sum(round_score)) %>% 
      ungroup() %>% 
      group_by(player) %>% 
      summarise(average_score = mean(score),
                number_of_games = n())
    
    max_average <- game_averages %>% pull(average_score) %>% max()
    
    
    p <- game_averages %>% 
      mutate(player = fct_rev(fct_reorder(player, average_score))) %>% 
      ggplot(aes(x = player, y = average_score, fill = number_of_games)) +
      geom_col() +
      theme_bw() +
      labs(x = "Player",
           y = "Average (Mean)\nScore",
           fill = "Number of Games",
           title = "Bar plot showing each player's average score",
           subtitle = "Colored by number of games played") +
      scale_y_continuous(limits = c(0, max_average + 10), expand = c(0, 0)) +
      theme(axis.title.y = element_text(angle = 0, vjust = 0.5)) +
      scale_fill_gradient2(mid = "grey", low = "pink", high = "lightblue", 
                           midpoint = median_num_games) +
      geom_text(aes(label = round(average_score, 1)), vjust = -0.5)
    
    print(p)
    
    # p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
    # 
    # if (input$color != 'None')
    #   p <- p + aes_string(color=input$color)
    # 
    # facets <- paste(input$facet_row, '~', input$facet_col)
    # if (facets != '. ~ .')
    #   p <- p + facet_grid(facets)
    # 
    # if (input$jitter)
    #   p <- p + geom_jitter()
    # if (input$smooth)
    #   p <- p + geom_smooth()
    # 
    # print(p)
    
  }, height=700)
  
}