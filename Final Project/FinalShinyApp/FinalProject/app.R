library(shiny)
library(ggplot2)
library(dplyr)

pregnancy_df <- read.csv('https://raw.githubusercontent.com/hillt5/DATA608/main/Hospital_Maternity_Information__Beginning_2008.csv')

pregnancy_df$Hospital.County <- str_to_title(pregnancy_df$Hospital.County)

pregnancy_fix_1 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Albany', 'Columbia', 'Greene', 'Rensselaer', 'Saratoga', 'Schenectady', 'Warren', 'Washington')) %>%
  mutate(Region = 'Capital Region')
pregnancy_fix_2 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Cayuga', 'Cortland', 'Madison', 'Onondaga', 'Oswego')) %>%
  mutate(Region = 'Central New York')
pregnancy_fix_3 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Genessee', 'Livingston', 'Monroe', 'Ontario', 'Orleans', 'Seneca', 'Wayne', 'Wyoming', 'Yates')) %>%
  mutate(Region = 'Finger Lakes')
pregnancy_fix_4 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Nassau', 'Suffolk')) %>%
  mutate(Region = 'Long Island')
pregnancy_fix_5 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Duchess', 'Orange', 'Putnam', 'Rockland', 'Sullivan', 'Ulster', 'Westchester')) %>%
  mutate(Region = 'Mid-Hudson')
pregnancy_fix_6 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Fulton', 'Herkimer', 'Montgomery', 'Oneida', 'Otsego', 'Schoharie')) %>%
  mutate(Region = 'Mohawk Valley')
pregnancy_fix_7 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Bronx', 'Kings', 'New York', 'Queens', 'Richmond')) %>%
  mutate(Region = 'New York City')
pregnancy_fix_8 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Clinton', 'Essex', 'Franklin', 'Hamilton', 'Jefferson', 'Lewis', 'Saint Lawrence')) %>%
  mutate(Region = 'North Country')
pregnancy_fix_9 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Broome', 'Chemung', 'Chenango', 'Delaware', 'Schuyler', 'Steuben', 'Tioga', 'Tompkins')) %>%
  mutate(Region = 'Southern Tier')
pregnancy_fix_10 <- pregnancy_df %>%
  filter(Hospital.County %in% c('Allegany', 'Cattaraugus', 'Erie', 'Chautauqua', 'Niagra')) %>%
  mutate(Region = 'Western New York')
pregnancy_fix <- rbind(pregnancy_fix_1, pregnancy_fix_2, pregnancy_fix_3, pregnancy_fix_4, pregnancy_fix_5, pregnancy_fix_6, pregnancy_fix_7, pregnancy_fix_8, pregnancy_fix_9, pregnancy_fix_10)

ui <- navbarPage(title = 'Maternity Information and Child Birth Services, New York State Counties 2008 - 2017',
                 #landing page
                 navbarMenu('Before you choose your hospital, compare your hospital those nearby'),
                 #page 1: Find health indicators for nearby hospitals for most recent year (2017)
                 tabPanel(title = 'Hospital childbirth practices in your area',
                          wellPanel(
              
                   #select hospital
                            selectInput("hospitalInput1", "Select a Hospital:",
                                        unique(pregnancy_fix$Hospital.Name)),
                   
                   # select indicator
                            selectInput("indicatorInput1", "Select an Indicator to Compare:",
                                        unique(pregnancy_fix$Measure.Name[pregnancy_fix$Measure.Name != 'Total Births']))
                 ),
                 mainPanel(
                   plotOutput('indicator_plot')
                 )
                 ),
                   
                 #page 2: Compare health indicators in your region
                 tabPanel(title = 'Compare hospitals to regional average',
                          wellPanel(
                   #select range of dates
                            sliderInput("yearInput2", label = "Time period, Years",
                                        min = 2008, max = 2017, value = c(2008,2017), sep = ""),
                   #select hospital
                            selectInput("hospitalInput2", "Select a Hospital:",
                                        unique(pregnancy_fix$Hospital.Name)),
                   
                   # select indicator
                            selectInput("indicatorInput2", "Select an Indicator to Compare:",
                                        unique(pregnancy_fix$Measure.Name[pregnancy_fix$Measure.Name != 'Total Births']))
                 ),
                 mainPanel(
                   plotOutput('compare_plot')
                 )
                 )
)

server <- function(input, output) {
  
  output$indicator_plot <- renderPlot({
    
    #filters
    output_df <- pregnancy_fix %>%
      filter(Measure.Name != 'Total Births') %>%
      filter(Region == pregnancy_fix$Region[pregnancy_fix$Hospital.Name == input$hospitalInput1][1], #this selects the region of the input hospital
             Measure.Name == input$indicatorInput1,
             Year == 2017) %>%
      filter(!is.na(Percent)) %>%
      mutate(hospital_choice = (Hospital.Name == input$hospitalInput1))
    
    #column graph
    output_df %>%
      arrange(desc(Percent)) %>%
      ggplot() +
      geom_col(aes(x = Hospital.Name, y = Percent, fill =hospital_choice), show.legend = FALSE) +
      scale_fill_manual(values = c('grey50', 'red'))+
      ylab('Percent of Births Having Indicator') +
      ggtitle('Health Indicator Compared to Nearby Hospitals') +
      coord_flip()
    
    
  })
  
  output$compare_plot <- renderPlot({
    
    #filters
    output_df <- pregnancy_fix%>%
      filter(Hospital.Name == input$hospitalInput2,
             Measure.Name == input$indicatorInput2,
             Year >= input$yearInput2[1] & Year <= input$yearInput2[2]) %>%
      group_by(Region, Year) %>%
      mutate(average_rate = mean(Count, na.rm = TRUE)) %>%
      ungroup()
    
    ggplot(output_df) +
      geom_smooth(aes(x = Year, y = Count), se = FALSE) +
      geom_smooth(aes(x = Year, y = average_rate), se = FALSE, method = 'lm', linetype = 'dashed', color = 'red') + 
      xlab('Year') +
      ylab('Count') +
      ggtitle('Change in Health Indicator Over Time') 
    
    
  })
}




# Run the application 
shinyApp(ui = ui, server = server)

