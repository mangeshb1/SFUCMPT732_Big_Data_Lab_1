
# Server logic for a Shiny web application.
#

library(shiny)
library(ggmap)  # Lib for google maps
library(googleVis)  # Lib for gvisGauge and gvisPieChart
shinyServer(function(input, output) {
  output$mapChicago <- renderPlot({

    if(input$zoomL != ' ' ){
       zL <<- as.integer(input$zoomL) #Storing as Global
    }
    if(input$mapType == ' '){
       mapType <<- 'hybrid'
    }else{
      mapType <<- toString(input$mapType)
    }
    aggFile <- read.csv(file="C:/Users/Mangesh/Documents/app/op_LI_KmeansUpdated.csv",head=TRUE,sep=",")
    if(input$pts == 'crime'){
    crimepoints <-read.csv(file="C:/Users/Mangesh/Documents/app/Crimes_-_Map - update.csv",head=TRUE,sep=",")
    map <- qmap('Chicago', zoom = zL, maptype = mapType)
    myMap <- map + geom_point(data = crimepoints, aes(x = Longitude, y = Latitude), color="red", size=3, alpha=0.5)

    print(myMap, newpage = FALSE)
    }
    else if(input$pts == 'll'){
      problem_landlord <-read.csv(file="C:/Users/Mangesh/Documents/app/Problem_Landlord_List_-_Map.csv",head=TRUE,sep=",")
      map <- qmap('Chicago', zoom = zL, maptype = mapType)
      myMap <- map + geom_point(data = problem_landlord, aes(x = Longitude, y = Latitude), color="red", size=3, alpha=0.5)

      print(myMap, newpage = FALSE)
    }
    else if(input$pts == 'fm'){
      farmMarket <-read.csv(file="C:/Users/Mangesh/Documents/app/Farmers_Markets_-_2015.csv",head=TRUE,sep=",")
      map <- qmap('Chicago', zoom = zL, maptype = mapType)
      myMap <- map + geom_point(data = farmMarket, aes(x = Longitude, y = Latitude), color="green", size=3, alpha=0.5)

      print(myMap, newpage = FALSE)
    }
    else if(input$pts == 'sc'){
      schools <-read.csv(file="C:/Users/Mangesh/Documents/app/schools.csv",head=TRUE,sep=",")
      map <- qmap('Chicago', zoom = zL, maptype = mapType)
      myMap <- map + geom_point(data = schools, aes(x = Longitude, y = Latitude), color="green", size=3, alpha=0.5)

      print(myMap, newpage = FALSE)
    }
    else if(input$pts == 'ps'){
      police <-read.csv(file="C:/Users/Mangesh/Documents/app/Police_Stations.csv",head=TRUE,sep=",")
      map <- qmap('Chicago', zoom = zL, maptype = mapType)
      myMap <- map + geom_point(data = police, aes(x = Longitude, y = Latitude), color="yellow", size=3, alpha=0.5)

      print(myMap, newpage = FALSE)
    }
    else if(input$aggBlock == 'Crime_Frequency'){
    selcol = aggFile[,c("Community_Name","Crime_Frequency")]
    selcol.data <- as.data.frame(selcol)
    pie <- gvisPieChart(selcol.data,options=list(height=700,width=700))
    plot(pie)
    }
    else if(input$aggBlock == 'Housing_Crowded'){
      selcol = aggFile[,c("Community_Name","Housing_Crowded")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=700,width=700))
      plot(pie)
    }
    else if(input$aggBlock == 'Household_BPL'){
      selcol = aggFile[,c("Community_Name","Household_BPL")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=700,width=700))
      plot(pie)
    }
    else if(input$aggBlock == 'Unemployed'){
      selcol = aggFile[,c("Community_Name","Unemployed")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=700,width=700))
      plot(pie)
    }
    else if(input$aggBlock == 'Per_Capita_Income'){
      selcol = aggFile[,c("Community_Name","Per_Capita_Income")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=700,width=700))
      plot(pie)
    }
    else if(input$aggBlock == 'Living_Index'){
      selcol = aggFile[,c("Community_Name","Living_Index")]
      selcol.data <- as.data.frame(selcol)
      Gauge <-  gvisGauge(selcol.data,
                          options=list(min=-1, max=1, greenFrom=0.5,
                                       greenTo=1, yellowFrom=-0.2, yellowTo=0.4,
                                       redFrom=-1, redTo=-0.3, width=800, height=800))
      plot(Gauge)
    }

   })
})
