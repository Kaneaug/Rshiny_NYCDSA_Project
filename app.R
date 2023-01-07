library(readr)
library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)

df<- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/csv_combine/combined_csv.csv")

#%>%
#
#df <- df %>% 
  #filter(grepl("^\\d+\\/\\d+\\/\\d+$", acquired_at))
#df_view <- df %>% 
#  filter(grepl("to", acquired_at))
df$year_df <- df$acquired_at %>% 
  str_sub(-4) %>% 
  strtoi()



ui <- fluidPage(
  
    titlePanel("Start-up funding by Country"),
    shinythemes::shinytheme("superhero"),
    sidebarLayout(
      sidebarPanel(
    selectInput("country", "Choose Country", choices = unique(df$country_code)),
    sliderInput("year_input", "Choose year", min=1966, max=2013, value=2000)),
    mainPanel(plotOutput("plot_year"))
))
  
   
        
server <- function(input, output, session) {
output$plot_year <- renderPlot({
    df_country <- df %>% 
      filter(country_code == input$country) %>% 
      filter(year_df >= input$year_input)
    ggplot(df_country,aes(x=as.Date(acquired_at, format = "%d/%m/%Y"), y=price_amount, color = price_amount, size = price_amount))+
      geom_point() +
      scale_y_log10()+
    labs(x="Year",y = "Funding" )
    
  }) 
   
}

shinyApp(ui, server)
