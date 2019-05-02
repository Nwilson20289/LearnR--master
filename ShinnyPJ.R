library(shiny)
library(data.table)
library(dplyr)

# Define UI for data download app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Downloading Ebola Data"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Choose dataset ----
      selectInput("dataset", "Choose a dataset:",
                  choices = c("Ebola Sudan","Ebola Zaire", "Ebola Bundibugyo" )),
      
      # Button
      downloadButton("downloadData", "Download")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      dataTableOutput("table")
      
    )
    
  )
)

# Define server logic to display and download selected file ----
server <- function(input, output) {
  
  # Reactive value for selected dataset ----
  datasetInput <- reactive({
    df <- fread("dataset.csv")
    df <- df %>%
      filter(Virus == input$dataset)
    return(df)
  })
  
  # Table of selected dataset ----
  output$table <- renderDataTable({
    datasetInput()
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename= function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

