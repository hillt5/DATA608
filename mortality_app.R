#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(DT)

us_mort <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')

usmort_2010 <- us_mort %>%
  filter(Year == 2010)

ui <- basicPage(
  title = "Raw Mortality by Cause of Death, United States",
  sidebarLayout(
    sidebarPanel(
        'input.dataset === "usmort_2010"',
        selectInput("show_vars", "Causes of Death:",
                           unique(usmort_2010$ICD.Chapter))
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("US Mortality Rates", DT::dataTableOutput("mytable1"))
      )
    )
  )
)

server <- function(input, output) {
  
  # choose columns to display
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(usmort_2010[usmort_2010$ICD.Chapter == input$show_vars,])
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

