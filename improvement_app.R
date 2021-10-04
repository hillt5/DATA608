#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)


us_mort <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')


us_mort <- us_mort %>%
  group_by(Year, ICD.Chapter) %>%
  mutate(us_pop = sum(Population)) %>% #get US population for each Year
  mutate(us_deaths = sum(Deaths)) %>% #get Deaths for each year per cause of death
  ungroup() %>%
  mutate(average_rate = round(100000*us_deaths/us_pop,1)) #calculate average rate per 100,0000
#    mutate(above_average = if_else(Crude.Rate > average_rate,'Yes','No'))
#ended up not using this code as it removed datapoints when year went from above to below average

# Define UI for application that draws a histogram
ui <- fluidPage(
  headerPanel = "Raw Mortality by Cause of Death, United States",
  wellPanel(
    
    #select cause of death
    selectInput("show_vars", "Select Cause of Death:",
                unique(us_mort$ICD.Chapter)),
    
    # select state
    selectizeInput("stateInput", "Select State to Compare:",
                   choices = unique(us_mort$State),  
                   selected="NY", multiple =FALSE),
    
    #select range of dates
    sliderInput("yearInput", label = "Time period, Years", min = 1999, max = 2010, value = c(1999,2010), sep = "")
  ),
  mainPanel(
    plotOutput("improvement_plt")
  )
)



# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$improvement_plt <- renderPlot({
    
    #filters
    output_df <- us_mort%>%
      filter(State == input$stateInput,
             ICD.Chapter %in% input$show_vars,
             Year >= input$yearInput[1] & Year <= input$yearInput[2])
    
    ggplot(output_df) +
      geom_line(aes(x = Year, y = Crude.Rate)) +
      geom_line(aes(x = Year, y = average_rate), linetype = 'dashed', color = 'red') +
      xlab('Year') +
      ylab('Mortality Rate for Selected Cause of Death') +
      ggtitle('Change in Mortality Rate over Time compared to US Average (dashed)')
    
    
  })
}




# Run the application 
shinyApp(ui = ui, server = server)

