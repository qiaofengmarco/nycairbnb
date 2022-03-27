# ui.R
library(shinythemes)
library(shiny)
library(ggplot2)
# library(rgdal)
# library(rgeos)
library(plyr)
library(maptools)
library(sp)
library(plotly)
library(networkD3)
# library(chorddiag)
library(circlize)
library(leaflet)
library(shinycssloaders)

#shiny ui
ui = fluidPage(
  #set up shiny tab pages and navbar pages
  navbarPage(
    position="static-top",
    footer = includeHTML("footer.html"),
    theme = "bootstrap.min.css",  # <--- To use a theme, uncomment this
    "Visualization of Airbnb's Rent in New York",
    tabPanel('Home',
             icon=icon("home"),
             includeHTML("home.html")
    ),
    tabPanel('Bar Chart',
             icon=icon('chart-bar'),
             titlePanel(h1("Relationship between number of host and region", align = "center")),
             
             # radio button in selecting different areas and select ggplot view option
             fluidRow(
               column(3, 
                      wellPanel(
                        
                        radioButtons("Regionname", label="Select the level of the number of property a host possesses in total",
                                     choices=c('Single ( = 1 room)'='Single' , 
                                               'Very Low ( 2 ~ 3 rooms)'='Very Low', 
                                               'Low ( 4 ~ 5 rooms)'='Low', 
                                               'Median ( 6 ~ 20 rooms)'='Median', 
                                               'High ( > 20 rooms)' = 'High'), 
                                     selected='Single'))
                      
               ),
               # point and area graph of ggplot 
               mainPanel(   
                         div(
                           style = "position:relative",
                           plotlyOutput("trend") %>% withSpinner(color="#808080"),
                           uiOutput("hover_info")
                         )          
                         
               )
             )),
    
    tabPanel('Map',
             icon=icon("map-marked-alt"),
             titlePanel(h1("Locations of rental rooms in a region", align="center")),
             fluidRow(
               column(3, 
                      wellPanel(
                        
                        radioButtons("region", label="Select a Region",
                                     choices=c('Brooklyn'='Brooklyn' , 
                                               'Manhattan'='Manhattan', 
                                               'Bronx'='Bronx', 
                                               'Queens'='Queens', 
                                               'Staten Islands' = 'Staten Islands'), 
                                     selected='Brooklyn'))
                      
               ),
               # point and area graph of ggplot 
               mainPanel(  
                         div(
                           leafletOutput("map") %>% withSpinner(color="#808080")
                         )          
                         
               )
             )
             
    ),
    tabPanel('Wordcloud',
             icon=icon("cloud"),
             titlePanel(h1("Wordcloud according to price level", align = "center")),
             sidebarLayout(
               # Sidebar with a slider and selection inputs
               sidebarPanel(
                 selectInput("Price", "Select a Price Level:", 
                             choices=c('Very Low ( $0 ~ $50 )'='Very Low' , 
                                       'Low ( $50 ~ $100 )'='Low', 
                                       'Median ( $100 ~ $150 )'='Median', 
                                       'High ( $150 ~ $200 )'='High', 
                                       'Very High ( > $200 )' = 'Very High'),
                             selected = "Very Low"),
                 #actionButton("update", "Change"),
                 hr(),
                 sliderInput("freq",
                             "Minimum Frequency:",
                             min = 1,  max = 1000, value = 150),
                 sliderInput("max",
                             "Maximum Number of Words:",
                             min = 1,  max = 200,  value = 50)
               ),
               
               # Show Word Cloud
               mainPanel(
                 plotOutput("wordcloud") %>% withSpinner(color="#808080")
               )
             )
    ),
    #sankey chart
    tabPanel('Sankey',
             icon=icon("project-diagram"),
             titlePanel(h1("Relationship between Room Type, Region and Price level", align = "center")),
             # Row for influence option
             fluidRow(
               sankeyNetworkOutput(outputId ="graph") %>% withSpinner(color="#808080")
             ))
  )
)
