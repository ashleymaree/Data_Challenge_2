# Load packages
library(shiny)
library(plotly)
library(dplyr)
library(lubridate)
library(RColorBrewer)
library(rsconnect)

# Load data
tdf_winners <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-07/tdf_winners.csv')
write.csv(tdf_winners, "tdf_winners.csv")

# Wrangle data
tdf_winners_years <- tdf_winners %>% mutate(year_raw = year(start_date)) %>% ## Create column for year only
    mutate(distance_thou = distance/1000) %>% ## Create column for distance in thousands of kilometers
    add_count(nationality) ## Add column for count of winners by nationality

shinyServer(function(input, output) {
    
    output$plot <- renderPlotly({
        req(input$nationalities)
        ds <- tdf_winners_years %>%
            filter(year_raw >= input$startyear, year_raw <= input$endyear, nationality %in% input$nationalities)
        
        ggplot.plot <- ggplot(ds, aes(x = year_raw, y = time_overall, color = nationality)) +
            geom_point(size = 2) + ## display data in scatterplot
            labs(title = "Tour de France Winner's Time Over the Years", ## Add title 
                 x = "Year", ## Add x-axis label
                 y = "Overall Finish Time (hours)", ## Add y-axis label
                 color = "Nationality") + ## Update legend title
            scale_color_brewer(palette = "Paired") + ## Change color palette using RColorBrewer
            theme(title = element_text(size = 8), legend.text = element_text(size = 8)) ## Decreased size of graph, legend and axes labels
        
        ggplotly(ggplot.plot)
    })
    
    output$plot2 <- renderPlotly({
        req(input$nationalities)
        ds_2 <- tdf_winners_years %>%
            filter(year_raw >= input$startyear, year_raw <= input$endyear, nationality %in% input$nationalities)
        
        ggplot.plot <- ggplot(ds_2, aes(x = age, fill = nationality)) + ## Initiate ggplot with age versus nationality
            geom_histogram() + ## display data in histogram
            labs(title = "Ages of Tour de France Winners", ## Add title 
                 x = "Age (years)", ## Add x-axis label
                 y = "Total Number of Winners", ## Add y-axis label
                 fill = "Nationality") + ## Update legend title
            scale_x_continuous(breaks = seq(22, 36, 1)) + ## Scale x-axis to show all ages
            scale_fill_brewer(palette = "Paired") + ## Change color palette using RColorBrewer
            theme(title = element_text(size = 8), legend.text = element_text(size = 8)) ## Decreased size of graph, legend and axes labels
        
        ggplotly(ggplot.plot)
    })
    
    output$plot3 <- renderPlotly({
        req(input$nationalities)
        ds_3 <- tdf_winners_years %>%
            filter(year_raw >= input$startyear, year_raw <= input$endyear, nationality %in% input$nationalities)
        
        ggplot.plot <- ggplot(ds_3, aes(x = nationality, y = distance_thou/n, fill = nationality)) +
            geom_bar(stat = 'identity') + ## display data in bar graph
            labs(title = "Total Distance Traveled Normalized by Number of Wins \nin the Tour de France by Nationality of Winner", ## Add title 
                 x = "Nationality of Winner", ## Add x-axis label
                 y = "Total Distance Traveled (thousands of kilometers) \nDivide by Number of Total Wins", ## Add y-axis label
                 fill = "Nationality") + ## Update legend title
            coord_flip() + ## Flip x and y coordinates
            scale_fill_brewer(palette = "Paired") + ## Change color palette using RColorBrewer
            theme(title = element_text(size = 8), legend.text = element_text(size = 8)) ## Decreased size of graph, legend and axes labels
        
        ggplotly(ggplot.plot)
    })
}
)  
