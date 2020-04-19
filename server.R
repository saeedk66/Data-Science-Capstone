library(shiny)
library(stringr)
library(tm)

dict2EN <- readRDS(file="dictionary2EN.RDS")
dict3EN <- readRDS(file="dictionary3EN.RDS")




shinyServer(function(input, output) {
    output$prediction <- renderTable(predictNextWord(input$text, input$resultRange, input$lang, input$addInfo), colnames = FALSE, bordered = TRUE)
})


# Function to clean string entered by user
cleanString <- function(text){
    cleanString <- tolower(text)
    cleanString <- removeNumbers(cleanString)
    cleanString <- removePunctuation(cleanString)
    cleanString <- stripWhitespace(cleanString)
    cleanString <- unlist(strsplit(cleanString, " "))
    
    return(cleanString)
}


predictNextWord <- function(text, resultRange, lang, addInfo){
    cleanText <- cleanString(text)
    len <- length(cleanText)  # Number of words
    
    
    
    
    searchString2 <- NA
    searchString1 <- NA
    prediction <- NA
    
    
if (len >= 2) {
        # Last two words entered
        searchString2 <- paste(cleanText[(length(cleanText)-1):length(cleanText)], collapse=" ")
    } else if (len == 1) {
        # Last word entered
        searchString1 <- cleanText[(length(cleanText)):length(cleanText)]
    }
    
    
    # Predict based on last two words
    if (!is.na(searchString2)) {
        prediction <- dict3EN[dict3EN$term == searchString2, c(2,4)]
        if (nrow(prediction) == 0) {
            # If string not found, create search string with last word entered
            searchString1 <- cleanText[(length(cleanText)):length(cleanText)]
        }
    }
    # Predict based on last word
    if (!is.na(searchString1)) {
        prediction <- dict2EN[dict2EN$term == searchString1, c(2,4)]
    }
    
    # Return top n rows with n defined by user input (resultRange)
    # If required add frequency
    if (is.null(addInfo)) {
        head(as.data.frame(prediction[c(1)]), resultRange)
    } else {
        head(as.data.frame(prediction[c(1,2)]), resultRange)
    }
}