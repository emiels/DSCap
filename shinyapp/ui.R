# clientside logic for DSP assignment
Sys.setlocale("LC_ALL","English")
suppressPackageStartupMessages(
        c(library(stringi), 
          library(stringr), 
          library(dplyr), 
          library(shiny), 
          library(wordcloud)))
library(shinythemes)

shinyUI(navbarPage("Capstone Project for Coursera Data Science", 
                   theme = shinytheme('united'),
        tabPanel("Predict Word",
                 fluidRow(
                         column(1),
                         column(6,
                                br(),
                                textInput("inString",
                                          label = "Enter (English) Text Here",
                                          value = ""),
                                br(),
                                h4("The suggested (predicted) next word is:"),
                                h2(textOutput("outSugg")),
                                br(),br()),
                         column(4, plotOutput("outCloud", 
                                              width="300px", height="300px"),
                                h4("Sofar you entered"),
                                textOutput("enteredWords")))
        ),
        navbarMenu("More",
                   tabPanel("About the App", includeMarkdown("about.md")),
                   tabPanel("About Prediction", includeMarkdown("prediction.md")))
        ))