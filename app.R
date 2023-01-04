library(shiny)
library(ggplot2)
library(shinythemes)
library(dplyr)
objects <- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/objects.csv")
aq <- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/acquisitions.csv")

ui <- fluidPage(
  shinythemes::shinytheme("superhero"),
    titlePanel("Start-up Success Predictors"),
  
      sidebarLayout(
        sidebarPanel(
          selectInput("comp_ind", "Select Industry", choices = objects$category_code, selectize = TRUE)),
          sliderInput("slider_aq", "Select Year", min = 1966, max = 2013, value = 2000)
      ),   
      mainPanel(
        tabsetPanel(
          tabPanel("Total Industry Funding",textOutput("industry")),
          tabPanel("Funding by Year",plotOutput("sc_plot"))
          

)
)
)

server <- function(input, output, session) {
  
  output$industry <- renderText({
    total_fun <- objects %>%
      filter(input$comp_ind == funding_total_usd)
    
    paste("Overall funding for the", input$comp_ind, "industry is", sum(objects$funding_total_usd))
    
  })
  output$sc_plot <- renderPlot({
    aq_year <- aq %>%
      filter(
       acquired_at == input$slider_aq
      )
    aq$acquired_at <- as.Date(aq$acquired_at)
    ggplot(aq, aes(x = acquired_at, y = id)) +
      geom_point() +
      scale_y_log10()
    
  })
}

shinyApp(ui, server)
