#setwd("C:/Users/mateo/Desktop/school/math 399/shiny") 

library(shiny)
library(R.utils)
library(XML)
library(RColorBrewer)
library(maps)
library(stringr)
source("helpers.R")
ui <- fluidPage( 
        headerPanel(
          list(tags$head(tags$title("shiny app"),tags$style("body {background-color:#e0e0d1; }")),
             tags$div(style="color:#0066ff",tags$h1("Demographic Plots")))
        ),
        tabsetPanel(type = "pills",
          tabPanel("About",tags$div(style="margin-top:40px;font-size:18px;",column(offset=2,width =9,
                   "This application is designed to generate a world map 
                   where the user gets to select different demographic information to overlay the map.
                   The user is also able to switch the color palette of the map. The demographic information
                   selected in the text box is from the different \"field id\" numbers found in the Factbook 
                   XML file." ,tags$br(), "
                   Factbook data from this app can be found at this",
                   tags$a(href="https://www.cia.gov/library/publications/the-world-factbook/geos/xx.html",
                                                          "cia.gov"), "web site.", 
                   tags$img(src='https://www.cia.gov/++theme++contextual.agencytheme/images/logo.png'), tags$br(),
                   "This",tags$a(href="https://www.crcpress.com/Data-Science-in-R-A-Case-Studies-Approach-to-Computational-Reasoning-and/Nolan-Lang/p/book/9781482234817","R for data science"),
                    "book was an essential tool for creating this shiny app."))),
            tabPanel("Map It!",sidebarLayout(
                     
                     sidebarPanel(selectInput(inputId = "palette",label="input palette ",
                                              choices=c("YlOrRd","Set1","BuGn","Blues")),
                                  selectInput(inputId = "field",label = "input field",
                                  choices=c("Infant Mortalilty Rate"="f2091","Health Expenditures"="f2225","Obesity - Adult Prevalence"="f2228","Birth Rate"="f2054",
                                    "Death Rate"="f2066","Maternal Mortality Rate"="f2223","Idustrial Production Growth Rate"="f2089",
                                     "Internet Users"="f2153","Unemployment; Age 15-24"="f2229"),
                                  selected="Infant Mortality Rate"="f2091")),
                     mainPanel(plotOutput("mapIt")
                               )
                     )
                                          
                   )
                  )
                )


server <- function(input, output){
  
          output$mapIt <- renderPlot({
  
            map_it(
              input$palette,input$field
                  ) 
          })
            
              
}

shinyApp(ui=ui, server=server)    
