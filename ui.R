#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#Read Database 
Acquisitions <- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/acquisitions.csv")
objects <- read.csv("C://Users/kanem/Rshiny_project/Rshiny_project/objects.csv")
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Start-UP Statistics"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("name", "Select a name", choices = objects$name)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("objects")
        )
    )
))
