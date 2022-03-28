# server.R prepare for the R shiny environment 
#install.packages(c("plotly","ggplot2","rgdal","dplyr","maptools","sp","networkD3","datasets","chorddiag","circlize","ggmap","leaflet","RColorBrewer","wordcloud","NLP","tm","tidyverse","tidytext","tidyr","lubridate","MASS","caret","ggrepel","gt","gganimate","htmlwidgets"))
#install.packages("devtools")
#devtools::install_github("mattflor/chorddiag", build_vignettes = TRUE)

library(plotly)
library(shiny)
library(ggplot2)
# library(rgdal)
library(dplyr)
library(maptools)
library(sp)
library(networkD3)
library(datasets)
#library(chorddiag)
library(circlize)
library(ggmap)
library(leaflet)
library(RColorBrewer)
library(wordcloud)
# library(NLP)
library(tm)
library(tidyverse)
library(tidytext)
library(tidyr)
library(lubridate)
library(MASS)
library(caret)
library(ggrepel)
library(gt)
library(htmlwidgets)

# Read data
#df <- read.csv(file="AB_NYC_2019.csv",head=TRUE, fileEncoding='UTF-8-BOM')
df <- read_csv("AB_NYC_2019.csv")
df <-df %>% na_if("") %>% na.omit

shinyServer(function(input, output) {
  #when select input , main panel can change with input changing
  observeEvent(input$Regionname, {
    Regionname<- switch(input$Regionname,
                        'Single'='Single' , 
                        'Very Low'='Very Low', 
                        'Low'='Low', 
                        'Median'='Median', 
                        'High' = 'High')})
  
  #make ggplot to analyze
  output$trend <- renderPlotly({
    
    df2 <- subset(df, eva_host == input$Regionname) %>% count(neighbourhood_group)
    
    p <- df2 %>%
    ggplot() + 
      geom_col(aes(x = neighbourhood_group, y = n, fill = neighbourhood_group, text = paste(" Region:", neighbourhood_group, "<br>", "Number:", n))) + 
      theme(legend.position = "none") +
      xlab("Region") + ylab("Number") + ggtitle("Number of Hosts in Different Region") + theme(plot.title = element_text(hjust = 0.5))
      
    
    ggplotly(p,tooltip=c("text"))
    
    
  })
  
  
  #make sankey graph to analyze
  output$graph <- renderSankeyNetwork({
    myData2<-aggregate(df[,9],by=list(df$room_type,df$neighbourhood_group),FUN=sum)
    myData1<-aggregate(df[,9],by=list(df$neighbourhood_group,df$eva_price),FUN=sum)
    names(myData2)<-c("source","target","value")
    names(myData1)<-c("source","target","value")
    myData<-rbind(myData2,myData1)
    library(networkD3)
    Sankeylinks<-myData
    Sankeynodes<-data.frame(name=unique(c(Sankeylinks$source,Sankeylinks$target)))
    Sankeynodes$index<-0:(nrow(Sankeynodes) - 1)
    Sankeylinks<-merge(Sankeylinks,Sankeynodes,by.x="source",by.y="name")  
    Sankeylinks<-merge(Sankeylinks,Sankeynodes,by.x="target",by.y="name")  
    Sankeydata<-Sankeylinks[,c(4,5,3)] 
    names(Sankeydata)<-c("Source","Target","Value")  
    Sankeyname<-Sankeynodes[,1,drop=FALSE]  
    sn <- sankeyNetwork(Links=Sankeydata,Nodes=Sankeyname, Source ="Source",  
                  Target = "Target", Value = "Value", NodeID = "name",fontSize = 12, fontFamily = "Consolas", nodeWidth = 50,
                  height =600, width = 650, sinksRight=FALSE)
    sn$x$Sankeyname$value <- Sankeydata$value
    sn <- htmlwidgets::onRender(
      sn,
      '
      function(el, x) {
        d3.selectAll(".node").select("title foreignObject body pre")
        .text(function(d) { return d.value; });
      }
      '
    )
    sn
  })
  observeEvent(input$region, {
    region<- switch(input$region,
                    'Brooklyn'='Brooklyn' , 
                    'Manhattan'='Manhattan', 
                    'Bronx'='Bronx', 
                    'Queens'='Queens', 
                    'Staten Islands' = 'Staten Islands')})
  
  output$map <- renderLeaflet({
    df2 <- subset(df, neighbourhood_group == input$region)
    
    leaflet(df2) %>% addTiles() %>% 
      addCircleMarkers(
        radius = ~price/1000,
        ~longitude, ~latitude,
        stroke = FALSE, fillOpacity = 0.5,
        label = lapply(paste0("Region: ", df2$neighbourhood_group, "<br>", "Room Type: ", df2$room_type, "<br>", "Price: $", df2$price, "<br>"), HTML)
      )%>% setView( -73.97237,40.64749, zoom = 10)
    
    
  })
  output$wordcloud <- renderPlot({
    terms <- reactive({
      input$update
      print(input$Price)
      isolate({
        withProgress({
          setProgress(message = "Processing corpus...")
          getTermMatrix(input$Price)
        })
      })
    })
    df2 <- subset(df, eva_price == input$Price)
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    dfa <- data.frame(doc_id = 1:length(df2[,1]), text = df2$name, stringsAsFactors = FALSE)
    df_corpusa <- Corpus(DataframeSource(dfa))
    df_corpusa <- tm_map(df_corpusa, removePunctuation)
    df_corpusa <- tm_map(df_corpusa, tolower)
    df_corpusa <- tm_map(df_corpusa, removeNumbers)
    df_corpusa <- tm_map(df_corpusa, removeWords, stopwords("english"))
    dtma <-DocumentTermMatrix(df_corpusa,control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE)))
    freqa <- sort(colSums(as.matrix(dtma)), decreasing=TRUE) 
    wf <- data.frame(word=names(freqa), freq=freqa)
    set.seed(1)
    dark2 <- brewer.pal(6, "Dark2")
    wordcloud(names(freqa), freqa, min.freq = input$freq, max.words=input$max, rot.per=0.2, colors=dark2,scale=c(2.4,1))
    
  })
  
})


