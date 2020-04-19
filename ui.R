library(shiny)

shinyUI(fluidPage(
    
    titlePanel("Word Prediction"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Enter your phrase."),
            textInput("text", "Text:"),
            
            # Read result range (Possible values 1 through 5)
            helpText("Define the required number of results by moving the slider."),
            sliderInput("resultRange", "Number of results:", min=1, max=5, value=1),
            checkboxGroupInput("addInfo", "Additional Information:", c("Frequency" = "prop"), selected = NULL)
            
        ),
        
        mainPanel(
            helpText("The Word Prediction app provides predictions of the next possible word 
                    the user might enter, based on the last one, two or three words already 
                    entered (NLP).It is configurable by the text input,
                     a range of words to be provided."),
            
            br(),
            tags$head(
                tags$style(type='text/css', ".nav-tabs {font-size: 20px"),
                tags$style(type='text/css', ".tab-content {font-size: 20px")
            ),
            tabsetPanel(type = "tabs", tabPanel("Next word",  tableOutput("prediction"))
            )
        )
    )
))