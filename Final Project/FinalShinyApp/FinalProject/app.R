library(shiny)
library(tidyverse)
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
unique(pregnancy_df$Measure.Name)
ui <- navbarPage(title = 'Maternity Information and Child Birth Services, New York State Counties 2008 - 2017',
                 #landing page
                 tabPanel('Read first: How to use this webpage',
                          p('This website uses information gathered by the state of New York to help you compare hospitals in your area. In the first tab, you can select your region and compare performance of your hospital compared to others in your area. In the second tab, you can see if your hospital\'s performance has chnaged over time.',
                            h3('What Each Measure Means:'),
                            h4("Cesarean Births"),
                            p('Percent of cases when surgical operation in which the baby is delivered through incisions (cuts) made in
the mother\'s abdomen and uterus.'),
                            h4("Forceps Delivery"),        
                            p('Perent of cases when spoon-shaped instruments, called forceps, are used to help deliver the baby\'s head.'),
                            h4("Low/Outlet Forceps Delivery"), 
                            p('Percent of cases when forceps the instruments are not used until the baby\'s head has moved through the
                              pelvis.'),
                            h4("Mid Forceps Delivery"),
                            p('Percent of cases when the instruments are used before the baby\'s head has moved through
                              the pelvis.'),
                            h4("Internal Fetal Monitoring"),
                            p('Percent of cases when an eletronic recording of contractions and baby\'s heartbeat happens internally: a small tube with a fine wire into the uterus and attaching the wire to the baby\'s scalp'),
                            h4("External Fetal Monitoring"),
                            p('Percent of cases when an eletronic recording of contractions and baby\'s heartbeat happens externally: Monitoring involves the use of small instruments held in place on the mother\'s abdomen by belts.'),
                            h4("Induction - Artificial Rupture of Membranes"),
                            p('Percent of cases when contractions are stimulated before labor begins on its own: by puncturing the amniotic sac'),
                            h4("Induction - Medicinal"),
                            p('Percent of cases when contractions are stimulated before labor begins on its own: by using medications systemically or locally'),
                            h4("Augmented Labor"),                           
                            h4("Analgesia"),
                            p('Percent of cases when a medication is used to decrease the sensation of pain.'),
                            h4("Attended by Licensed Midwife"),
                            p('Percent of cases when a registered nurse who has had specialized midwifery training to care for women and
babies during pregnancy, childbirth, and after birth.'),
                            h4("Vaginal Births"),
                            p('Percent of cases when birth takes place through the birth canal'),
                            h4("Vaginal Birth After Prior Cesarean"),        
                            p('Percent of cases when the mother has had a cesarean section previously, but
delivers this baby vaginally. This percent is for all births, not just Cesarean births'),
                            h4("Breech Births Delivered Vaginally"),         
                            h4("Episiotomy"),
                            p('Percent of cases when an incision (cut) is made to enlarge the vaginal opening.'),
                            h4("General Anesthesia"),
                            p('Percent of of cases when a gas or intravenous medication is used to make the mother unconscious during delivery'),
                            h4("Spinal Anesthesia"),
                            p('Percent of cases when a drug is injected into the lower spinal area to numb the vaginal region'),
                            h4("Epidural Anesthesia"),      
                            p('Perent of cases when a drug is given through a fine tube inserted in the mother\'s lower back to
                              numb the vaginal area and lower abdomen.'),
                            h4("Local/Other Anesthesia"),
                            p('Percent of cases when a drug is applied or injected into the skin or cavity to numb the area. This percent is for all deliveries.'),
                            h4("Paracervical Anesthesia"),
                            p('Percent of cases when a drug is injected into the cervix (opening of the womb) to relieve the
pain of labor.'),
                            h4("Pudendal Anesthesia"),
                            p('Percent of cases when a drug is injected into the cervix (opening of the womb) to relieve the
pain of labor.'),
                            h4("Primary Cesarean"),         
                            p('Percent of cases when a surgical operation in which the baby is delivered through incisions (cuts) made in
the mother\'s abdomen and uterus, even if she has given birth vaginally before'),
                            h4("Repeat Cesarean"),
                            p('Percent of cases when a surgical operation in which the baby is delivered through incisions (cuts) made in
                              the mother\'s abdomen and uterus when the mother has had one or more cesarean sections previously. This percent is for all births, not just prior Cesareans.'),
                            h4("Epidural/Local Anesthesia"),
                            p('Percent of cases when a drug is applied or injected into the skin, or given through a fine tube into the mother\'s back to numb the vaginal area and lower abdomen. This percent is for Cesarean births.'),
                            h4("Fed Any Breast Milk"),
                            p('Percent of cases when infants who were fed only breast milk (by any method--from
the breast, bottle, cup or feeding tube) and infants who were given both breast milk and
formula, sugar water, or other liquids.'),
                            h4("Fed Exclusively Breast Milk"),         
                            p('Percentn of cases when infants who were fed only breast milk (i.e., no formula or water)
since birth.'),
                            h4("Breast Fed Infants Supplemented w/Formula"), 
                            p('Percent of cases when among infants fed any breast milk, the
percentage who were also fed (supplemented with) formula. The percent is for only infants receiving any breastmilk.'),
                            h5('Data Source'),
                            p('https://health.data.ny.gov/Health/Hospital-Maternity-Information-Beginning-2008/net3-iygw'))
                          ),
                 #page 1: Find health indicators for nearby hospitals for most recent year (2017)
                 tabPanel(title = 'Hospital childbirth practices in your area',
                          wellPanel(
              
                   #select hospital
                            selectInput("hospitalInput1", "Select a Hospital:",
                                        unique(pregnancy_fix$Hospital.Name)),
                   
                   # select indicator
                            selectInput("indicatorInput1", "Select an Indicator to Compare:",
                                        unique(pregnancy_fix$Measure.Name[pregnancy_fix$Measure.Name != 'Total Births' & pregnancy_fix$Measure.Name != 'Total Births After Prior Cesarean']))
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
                                        unique(pregnancy_fix$Measure.Name[pregnancy_fix$Measure.Name != 'Total Births'  & pregnancy_fix$Measure.Name != 'Total Births After Prior Cesarean']))
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
      ylab('Number per Year') +
      ggtitle('Change in Health Measure Time') +
      scale_x_continuous(breaks = c(2008,2010,2012,2014,2016,2018))
    
    
  })
}




# Run the application 
shinyApp(ui = ui, server = server)

