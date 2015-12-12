
# This is the server logic for a Shiny web application.
#

library(shiny)
library(ggmap)
library(googleVis)
shinyServer(function(input, output) {
  output$mapChicago <- renderPlot({

    if(input$zoomL != ' ' ){
       zL <<- as.integer(input$zoomL)
    }
    if(input$mapType == ' '){
       mapType <<- 'hybrid'
    }else{
      mapType <<- toString(input$mapType)
    }
    aggFile <- read.csv(file="C:/Users/Mangesh/Documents/app/Census_Data_-_Selected_socioeconomic_indicators.csv",head=TRUE,sep=",")
    if(input$pts == 'crime'){
    crimepoints <-read.csv(file="C:/Users/Mangesh/Documents/app/Crimes_-_Map.csv",head=TRUE,sep=",")
    #coords <- cbind(Longitude = as.numeric(as.character(crimepoints$LONGITUDE)), Latitude = as.numeric(as.character(crimepoints$LATITUDE)))
    #crime.pts <- SpatialPointsDataFrame(coords, crimes[, -(5:6)], proj4string = CRS("+init=epsg:4326"))
    map <- qmap('Chicago', zoom = zL, maptype = mapType)
    # generate bins based on input$bins from ui.R
    myMap <- map + geom_point(data = crimepoints, aes(x = Longitude, y = Latitude), color="red", size=3, alpha=0.5)

    print(myMap, newpage = FALSE)
    }
    else if(input$pts == 'll'){
      problem_landlord <-read.csv(file="C:/Users/Mangesh/Documents/app/Problem_Landlord_List_-_Map.csv",head=TRUE,sep=",")
      map <- qmap('Chicago', zoom = zL, maptype = mapType)
      myMap <- map + geom_point(data = problem_landlord, aes(x = Longitude, y = Latitude), color="yellow", size=3, alpha=0.5)

      print(myMap, newpage = FALSE)
    }
    else if(input$aggBlock == 'PERCENT_OF_HOUSING_CROWDED'){
    selcol = aggFile[,c("COMMUNITY.AREA.NAME","PERCENT.OF.HOUSING.CROWDED")]
    selcol.data <- as.data.frame(selcol)
    pie <- gvisPieChart(selcol.data,options=list(height=500,width=500))
    plot(pie)
    }
    else if(input$aggBlock == 'PERCENT_HOUSEHOLDS_BELOW_POVERTY'){
      selcol = aggFile[,c("COMMUNITY.AREA.NAME","PERCENT.HOUSEHOLDS.BELOW.POVERTY")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=500,width=500))
      plot(pie)
    }
    else if(input$aggBlock == 'PERCENT_AGED_16+_UNEMPLOYED'){
      selcol = aggFile[,c("COMMUNITY.AREA.NAME","PERCENT.AGED.16..UNEMPLOYED")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=500,width=500))
      plot(pie)
    }
    else if(input$aggBlock == 'PERCENT_AGED_25+_WITHOUT_HIGH_SCHOOL_DIPLOMA'){
      selcol = aggFile[,c("COMMUNITY.AREA.NAME","PERCENT.AGED.25..WITHOUT.HIGH.SCHOOL.DIPLOMA")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=500,width=500))
      plot(pie)
    }
    else if(input$aggBlock == 'PERCENT_AGED_UNDER_18_OR_OVER_64'){
      selcol = aggFile[,c("COMMUNITY.AREA.NAME","PERCENT.AGED.UNDER.18.OR.OVER.64")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=500,width=500))
      plot(pie)
    }
    else if(input$aggBlock == 'PER_CAPITA_INCOME'){
      selcol = aggFile[,c("COMMUNITY.AREA.NAME","PER.CAPITA.INCOME")]
      selcol.data <- as.data.frame(selcol)
      pie <- gvisPieChart(selcol.data,options=list(height=500,width=500))
      plot(pie)
    }

   })
})
