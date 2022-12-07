#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("./reshape.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Porches and Pies Weebly reshape file"),
    sidebarPanel(
        
        # Input: Select a file ----
        fileInput("file1", "Choose CSV File",
                  multiple = TRUE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv")
                  ),
        # Horizontal line ----
        tags$hr(),
        
        # Input: Select separator ----
        radioButtons("sep", "Separator",
                     choices = c(Comma = ",",
                                 Semicolon = ";",
                                 Tab = "\t"),
                     selected = ","),
        
        downloadButton('itemsData', 'Download items.csv'),
        downloadButton('bakersData', 'Download bakers.csv')
        
        ),
    
        # Show a plot of the generated distribution
        mainPanel(
           
        )
)


server <- function(input, output) {
    
    dfs <- reactive({
        req(input$file1)
        df = read.csv(input$file1$datapath,
                   sep = input$sep
                   )
    
        df_clean = clean_up_export(df)
        combined = split_export(df_clean)
        return(combined)
    })
    
    output$bakersData <- downloadHandler(
        filename = "bakers.csv",
        content = function(file) {
            write.csv(extract_baker_category(dfs()[[1]]), file, row.names = TRUE)
        }
    )
    
    output$itemsData <- downloadHandler(
        filename = "items.csv",
        content = function(file) {
            write.csv(dfs()[[2]], file, row.names = TRUE)
        }
    )
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
