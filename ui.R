# clientside logic for DSP assignment
library(shiny)
library(shinythemes)
# Sys.setlocale("LC_ALL","English")

shinyUI(navbarPage("Capstone Project for Coursera Data Science", 
                   theme = shinytheme('United'),
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