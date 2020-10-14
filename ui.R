# Load packages
library(shiny)
library(plotly)
library(readr)

# Read in data
read.csv("tdf_winners.csv")

# Wrangle data
nationality_unique <- unique(tdf_winners_years$nationality)

# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("Tour de France Winners from 1903 - 2019"),
    
    p("This is a shiny app displaying data for the winners of the Tour de France.
      Use the sidebar on the left to manually select the years of data you wish 
      to view. The entire dataset spans 1903 to 2019. You can also select nationalities 
      of interest. This is the nationality of the winner of the race for each given year."), # Add subtitle for description of how to use app

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "startyear", label = "Enter starting year",
                         value = 1905, min = 1903, max = 2019, step = 1),
            numericInput(inputId = "endyear", label = "Enter ending year",
                         value = 2000, min = 1903, max = 2019, step = 1),
            checkboxGroupInput(inputId = "nationalities", label = "Nationalities of Winner to display",
                               sort(unique(nationality_unique)),
                               selected = nationality_unique[c(1,4)])
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("plot"),
            plotlyOutput("plot2"),
            plotlyOutput("plot3")
        )
    )
))
