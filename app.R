library(readr)
library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(DT)
df_main <- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/csv_combine/objects.csv")
df<- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/csv_combine/combined_csv.csv")
fund<- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/csv_combine/funds.csv")


#df <- df %>% 
  #filter(grepl("^\\d+\\/\\d+\\/\\d+$", acquired_at))
#df_view <- df %>% 
#  filter(grepl("to", acquired_at))
df$year_df <- df$acquired_at %>% 
  str_sub(-4) %>% 
  strtoi()
df$color <- df$term_code


ui <- fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")),
    
    titlePanel("Start-up successes"),
    sidebarLayout(
      sidebarPanel(
    selectInput("op_status", "Company's Operation Status", choices = unique(df_main$status)),
    sliderInput("rounds", "Rounds of funding", min=1, max=15, value=1)),
    mainPanel(
      tabsetPanel(
        tabPanel("Funding by Industry", plotOutput("fund_plot")),
        tabPanel("Company overview", DT::dataTableOutput("d_table")),
        tabPanel("Total Funding", plotOutput("sc_plot"))
      ),
      plotOutput("line_g")
    )
))
  
   
        
server <- function(input, output, session) {
#output$plot_year <- renderPlot({
   #df_country <- df %>% 
   #filter(country_code == input$country) %>% 
   #   filter(year_df >= input$year_input)
     #ggplot(df_country,aes(x=as.Date(acquired_at, format = "%d/%m/%Y"), y = price_amount, size = price_amount, color = term_code))+
      #geom_point(alpha = .2) +
      #scale_size(range = c(1,24), name = "Total amount raised")+
      #scale_y_log10()+
      #labs(x="Year",y = "Funding", color = "Company Purchased with:" )
    #})
  
  output$fund_plot <- renderPlot({
    df_plot <- df_main %>% 
      filter(funding_rounds == input$rounds) %>% 
      filter(status == input$op_status)
    df_color <- df$term_code 
    ggplot(df_plot, aes(x=funding_total_usd, y=category_code, color = category_code,size = funding_total_usd))+
      geom_point(alpha = 0.5)+
      scale_size(range = c(1,24), name = "Total amount raised")+
      scale_x_log10()+
      labs(x="Total Capital Raised")
  })
output$d_table <- DT::renderDataTable({
  f_table <- df_main[, c("name","category_code","status","homepage_url","description","overview")]
  f_table
})
output$line_g <- renderPlot({
  ggplot(df_main, aes(x = status, fill = status))+
    geom_bar()+
    theme_minimal()
})
output$sc_plot <- renderPlot({
  ggplot(df, aes(x=as.Date(acquired_at, format = "%d/%m/%Y"), y = price_amount))+
    geom_bin2d(bins = 70, show.legend = FALSE)+
    theme_bw() +
    theme_minimal() +
    scale_y_log10()+
    labs(x="Year",y = "Funding", color = "Company Purchased with:" )
})
}

shinyApp(ui, server)
