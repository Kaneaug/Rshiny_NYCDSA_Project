library(readr)
library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(DT)

df<- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/csv_combine/combined_csv.csv")
fund<- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/csv_combine/funds.csv")


#df <- df %>% 
  #filter(grepl("^\\d+\\/\\d+\\/\\d+$", acquired_at))
#df_view <- df %>% 
#  filter(grepl("to", acquired_at))
df$year_df <- df$acquired_at %>% 
  str_sub(-4) %>% 
  strtoi()



ui <- fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")),
    
    titlePanel("Start-up funding by Country"),
    sidebarLayout(
      sidebarPanel(
    selectInput("country", "Choose Country", choices = unique(df$country_code)),
    sliderInput("year_input", "Choose year", min=1966, max=2013, value=2000)),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot_year")),
        tabPanel("Table", DT::dataTableOutput("d_table"))
      )
    )
))
  
   
        
server <- function(input, output, session) {
output$plot_year <- renderPlot({
    df_country <- df %>% 
      filter(country_code == input$country) %>% 
      filter(year_df >= input$year_input)
    
    ggplot(df_country,aes(x=as.Date(acquired_at, format = "%d/%m/%Y"), y = price_amount, size = price_amount, color = term_code))+
      geom_point(alpha = .2) +
      scale_size(range = c(1,24), name = "Total amount raised")+
      scale_y_log10()+
      labs(x="Year",y = "Funding", color = "Company Purchased with:" )
    
  }) 
output$d_table <- DT::renderDataTable({
  f_table <- fund[, c("name","funded_at","raised_amount","raised_currency_code","source_url","source_description","created_at","updated_at")]
  f_table
})
}

shinyApp(ui, server)
