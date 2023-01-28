library(readr)
library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(DT)
library(shinythemes)
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
tot_fun <- sum(df_main$funding_total_usd)


ui <- fluidPage(
    theme = shinytheme("sandstone"),
    
    titlePanel("Start-up Market Insights"),
    sidebarLayout(
      sidebarPanel(
    selectInput("op_status", "Company's Operation Status", choices = unique(df_main$status)),
    sliderInput("rounds", "Rounds of funding", min=1, max=15, value=1),
    p("Average Rounds of Funding Per Company: 1.3"),
    p("Average Funding Per Company: $11,205,961"),
    p("Median Funding Per Company: $1,000,000")),
    mainPanel(
      tabsetPanel(
        tabPanel("Funding by Industry", plotOutput("fund_plot"),p("Investing in Start-Up companies can be a very lucrative investment.However as Craig
                                                                  Peter of Growth Capital Ventures states 'it's essential to build a portfolio of companies. 
                                                                  It's sensible to invest in 5 to 10 startups to ensure there's a solid approach to portfolio 
                                                                  diversification. Across a portfolio of 10 investments, it's most likely two or three will 
                                                                  perform very well, another two or three will break even and the others will fail. Overall, 
                                                                  the gains made from the high-performing portfolio 
                                                                  companies outweigh the downside of the non-performing assets.'")),
        tabPanel("Company overview", DT::dataTableOutput("d_table")),
        tabPanel("Total Funding", plotOutput("sc_plot"),paste("Total Funding in USD", "$", tot_fun)), 
        tabPanel("Analysis", plotOutput("line_g"),
                 p("Of the 6,613 U.S.-based companies initially funded by venture capital between
                 2006 and 2011, 84% now are closely held and operating independently, 11% were acquired
                 or made initial public offerings 
                   of stock and 4% went out of business, according to Dow Jones VentureSource"))
      )
      
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
  f_table <- df_main[, c("name","category_code","status","homepage_url","description","overview", "funding_total_usd")]
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
