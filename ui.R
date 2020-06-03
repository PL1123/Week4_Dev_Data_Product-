# Loading Necessary Packages and data
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(dplyr))
data("diamonds")

shinyUI(fluidPage(
    titlePanel("Diamond Price Estimate"),
    sidebarLayout(
        sidebarPanel(h3("Please select diamond features"),
            sliderInput("caratinp","carat", min = 0, max = 10, value = 5, step = 0.1),
            selectInput("colorinp", "color", unique(diamonds$color)),
            selectInput("cutinp", "cut", unique(diamonds$cut)),
            selectInput("clarityinp", "clarity", unique(diamonds$clarity)),
            h5("Diagnostics plots of the model: lm(log(price)~log(carat)+cut+color+clarity"), plotOutput("model"),
        ),


        mainPanel("Diamond Price Graph",
            plotOutput("distPlot"),
            h3("Predicted Diamond Price Based on Features:"),
            textOutput("pred"),
        )
    )
))
