library(shiny)
library(ggplot2)
library(bslib)
library(dplyr)

data("wpl_bowling", package = "wplbowling")

ui <- page_sidebar(
  title = "WPL Bowling Performance Explorer",
  theme = bs_theme(
    version = 5,
    bootswatch = "minty"
  ),
  
  sidebar = sidebar(
    title = "Filters",
    
    selectInput(
      "season",
      "Season",
      choices = unique(wpl_bowling$season),
      selected = unique(wpl_bowling$season)[1]
    ),
    
    selectInput(
      "phase",
      "Innings phase",
      choices = unique(wpl_bowling$phase),
      selected = unique(wpl_bowling$phase)[1]
    ),
    
    sliderInput(
      "min_overs",
      "Minimum overs bowled",
      min = 0,
      max = 30,
      value = 2,
      step = 1
    ),
    
    helpText(
      "Change the filters to compare bowling performances."
    )
  ),
  
  h4("Bowling Performance Comparison"),
  
  p(
    "Compare bowlers by economy rate, wickets and overs bowled."
  ),
  
  uiOutput("state_message"),
  
  layout_columns(
    card(
      card_header("Top 10 Bowlers by Economy"),
      plotOutput("economy_plot")
    ),
    
    card(
      card_header("Bowling Statistics"),
      tableOutput("bowler_table")
    )
  ),
  
  card(
    card_header("How to interpret the results"),
    p(
      "Lower economy rates indicate fewer runs conceded per over. 
      Wickets and overs bowled provide additional context."
    ),
    p(
      "Performances based on fewer overs may be less reliable 
      than performances based on larger bowling workloads."
    )
  ),
  
  card(
    card_header("Column definitions"),
    tags$ul(
      tags$li(
        tags$strong("Balls: "),
        "Legal deliveries bowled."
      ),
      tags$li(
        tags$strong("Runs conceded: "),
        "Runs charged to the bowler, including wides and no-balls."
      ),
      tags$li(
        tags$strong("Wickets: "),
        "Dismissals credited to the bowler."
      ),
      tags$li(
        tags$strong("Economy: "),
        "Runs conceded per six legal deliveries."
      )
    )
  )
)

server <- function(input, output, session) {
  
  bowling_results <- reactive({
    
    wplbowling::summarise_bowling(
      data = wpl_bowling,
      season_value = input$season,
      phases = input$phase,
      min_overs = input$min_overs
    )
    
  })
  
  output$state_message <- renderUI({
    
    results <- bowling_results()
    
    if (nrow(results) == 0) {
      
      div(
        class = "alert alert-warning",
        "No bowlers match these filters. Try reducing the minimum overs."
      )
      
    } else {
      
      div(
        class = "alert alert-success",
        paste(nrow(results), "bowlers match your filters.")
      )
      
    }
    
  })
  
  output$economy_plot <- renderPlot({
    
    results <- bowling_results()
    
    if (nrow(results) == 0) {
      return(NULL)
    }
    
    top_bowlers <- head(results, 10)
    
    ggplot(
      top_bowlers,
      aes(
        x = reorder(bowler, economy),
        y = economy
      )
    ) +
      geom_col(fill = "#278C80") +
      coord_flip() +
      labs(
        x = "Bowler",
        y = "Economy rate",
        title = "Lower economy indicates fewer runs conceded"
      ) +
      theme_minimal()
    
  })
  
  output$bowler_table <- renderTable({
    
    results <- bowling_results()
    
    if (nrow(results) == 0) {
      return(NULL)
    }
    
    
    head(
      results |>
        select(
          bowler,
          balls,
          runs_conceded,
          wickets,
          economy
        ),
      10
    )
    
    
  }, striped = TRUE, hover = TRUE)
  
}

shinyApp(ui, server)
