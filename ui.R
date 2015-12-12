
library(shiny)

# Define UI
shinyUI(fluidPage(

  # Application title
  titlePanel("City Of Chicago! Living Index CMPT 732"),

  sidebarLayout(position="left",

                # Drop Down

                #Slider ip
                #sliderInput(inputId = "zoom",label = "SelectI", value = 10, min = 1, max = 15),
                sidebarPanel(
                  selectInput("pts", "Select points to map:",
                              c(" "=" ",
                                "Crime Location" = "crime",
                                "Farmers Market" = "fm",
                                "School" = "sc",
                                "Police Stations" = "ps",
                                "Landlord" = "ll"),selected = " "),
                  selectInput("mapType", "Selct Type of Map:",    #   c("terrain", "satellite", "roadmap","hybrid")
                              c(" "=" ",
                                "Terrain" = "terrain",
                                "Satellite" = "satellite",
                                "Roadmap" = "roadmap",
                                "Hybrid" = "hybrid"),selected = "hybrid"),

                  selectInput("aggBlock", "See Socioeconomic Status based on COMMUNITY AREA NAME:",
                              c(" "=" ",
                                "Crime Frequency" = "Crime_Frequency",
                                "Housing Crowded" = "Housing_Crowded",
                                "Household BPL" = "Household_BPL",
                                "Unemployed" = "Unemployed",
                                "Per Capita Income" = "Per_Capita_Income",
                                "Living Index" = "Living_Index"
                               ),selected = " "),

                  sliderInput(inputId = "zoomL",label = "Select Zoom Level", value = 10, min = 1, max = 15)
                ),
                # Show a map plot
                mainPanel(
                  plotOutput("mapChicago", height="900px", width="950px")
                )
  )
))
#deployApp(appName="APPNAME")