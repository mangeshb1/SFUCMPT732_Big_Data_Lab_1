Instruction to Run R Shiny Server Files ::
Create new R Project (Shiny application) with RStudio.
It will have two files named ui.R and server.R same as git repository. File name has to be same so R Shiny Server can identify them properly. 
Replaced them with ui.R and server.R Files from git.
To run R shiny server locally Update path accordingly in server.R in R Studio based on where you have stored input files used in server.R File. This step is not required when deployed on R Shiny Server. 
Click Run app to start R Shiny application. Make you have active internet connection while trying to run R Shiny Application. 
To see points such as crime location, schools etc. please select points to map on UI. 
Map will be plotted in real time basic. To see any output such as crime frequency, living index select dropdown from See Socioeconomic Status based on COMMUNITY AREA NAME: at this point make sure selection in Select points to map: is empty as being reactive code we are plotting just one thing at a time. 


To run all spark file please refer to RUNNING.txt
