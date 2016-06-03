#serverside logic for DSP assignment
Sys.setlocale("LC_ALL","English")
suppressPackageStartupMessages(
        c(library(stringi), 
          library(stringr), 
          library(dplyr), 
          library(shiny), 
          library(wordcloud)))

source("./predictCode.R")

shinyServer(function(input, output){
        output$enteredWords <- renderText({input$inString})
        nxtWord <- reactive({predictTop(cleanInput(input$inString))})
        output$outPred <- renderText(nxtWord()[,1])
        output$outSugg <- renderText(nxtWord()[1,1])
        output$outCloud <- renderPlot({
                wordcloud(nxtWord()[,1],
                          nxtWord()[,2],
                          min.freq = 1, rot.per = 0,
                          colors=brewer.pal(5, "Set1"))})
                })
