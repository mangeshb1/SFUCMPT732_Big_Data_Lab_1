
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
                                "Crime" = "crime",
                                "Landlord" = "ll"),selected = " "),
                  selectInput("mapType", "Selct Type of Map:",    #   c("terrain", "satellite", "roadmap","hybrid")
                              c(" "=" ",
                                "Terrain" = "terrain",
                                "Satellite" = "satellite",
                                "Roadmap" = "roadmap",
                                "Hybrid" = "hybrid"),selected = "hybrid"),

                  selectInput("aggBlock", "See Socioeconomic Status based on COMMUNITY AREA NAME:",
                              c(" "=" ",
                                "PERCENT OF HOUSING CROWDED" = "PERCENT_OF_HOUSING_CROWDED",
                                "PERCENT HOUSEHOLDS BELOW POVERTY" = "PERCENT_HOUSEHOLDS_BELOW_POVERTY",
                                "PERCENT AGED 16+ UNEMPLOYED" = "PERCENT_AGED_16+_UNEMPLOYED",
                                "PERCENT AGED 25+ WITHOUT HIGH SCHOOL DIPLOMA" = "PERCENT_AGED_25+_WITHOUT_HIGH_SCHOOL_DIPLOMA",
                                "PERCENT AGED UNDER 18 OR OVER 64" = "PERCENT_AGED_UNDER_18_OR_OVER_64",
                                "PER CAPITA INCOME" = "PER_CAPITA_INCOME"
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