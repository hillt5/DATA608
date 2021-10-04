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



ui <- fluidPage(
  titelPanel = "Raw Mortality by Cause of Death, United States",
  fluidRow(
    column(3,
           wellPanel(
             #select cause of death
             selectInput("show_vars", "Causes of Death:",
                         unique(us_mort$ICD.Chapter)),
             
             # select state
             selectizeInput("stateInput", "State",
                            choices = unique(us_mort$state),  
                            selected="Alabama", multiple =FALSE),
    
            #select range of dates
            sliderInput("yearInput", label = "Time period, Years", min = 1999, max = 2010, value = c(1999,2010))
            )
    ),
           
    mainPanel(
      plotOutput("improvement_plt")
    )
  )
)

server <- function(input, output) {
  
  #output range
  output$range <- renderPrint({input$slider1})
  
  ## year filter
  output_df <- reactive({
    us_mort%>%
      filter(state == input$stateInput,
             condition %in% input$ICD.Chapter, 
             year >= input$yearInput[1],
             year <= input$yearInput[2])
  })
  
  output$improvement_plt <- renderPlot({
    ggplot(output_df) +
      geom_line(aes(x = Year, y = Raw.count 
                    #col = average_01
      )) +
      xlab('Year') +
      ylab('Mortality Rate') +
      ggtitle('Change in Mortality Rate over Time')
  })
}



# Run the application 
shinyApp(ui = ui, server = server)

