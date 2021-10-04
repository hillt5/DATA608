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

us_mort <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')



usmort_2010 <- us_mort %>%
  filter(Year == 2010) %>%
  group_by(ICD.Chapter) %>%
  mutate(avg_rate = mean(Crude.Rate)) %>%
  ungroup() %>%
  mutate(above_average = if_else(Crude.Rate > avg_rate,'Yes','No'))

ui <- fluidPage(
  headerPanel("Raw Mortality by Cause of Death, United States 2010"),
  wellPanel(
    selectInput("show_vars", "Cause of Death:",
                unique(usmort_2010$ICD.Chapter))
  ),
  mainPanel(
    id = 'dataset',
    tabPanel("US Mortality Rates", DT::dataTableOutput("mytable1"))
  )
)

server <- function(input, output) {
  
  
  # choose columns to display
  output$mytable1 <- DT::renderDataTable({
    
    us_table <- usmort_2010 %>%
      filter(ICD.Chapter == input$show_vars) %>%
      select(State, Deaths, Population, Crude.Rate, above_average)
    DT::datatable(us_table)
    
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)