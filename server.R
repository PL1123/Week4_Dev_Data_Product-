# Loading Necessary Packages and data
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(dplyr))
data("diamonds")

shinyServer(function(input, output) {
    

    #Building predictive model 
    
    mod <- lm(log(price)~log(carat)+cut+color+clarity, data = diamonds)
    
    predprice <- reactive({
        exp(predict(mod, data.frame(carat = input$caratinp, 
                                             cut = input$cutinp,
                                             color = input$colorinp,
                                             clarity = input$clarityinp)))
    })
    
    
    #Diagnostic plot of the model
   
    output$model <- renderPlot({
        par(mfrow = c(2,2))
        plot(mod)})
    
    #Prediction ouput 
    
    output$pred <- renderText({
        
        predprice()
        
        
    })
    
    #Making a Plot
    output$distPlot <- renderPlot({
            
            # Only subsetting datapoints of selected features (except carat)
            di <- diamonds %>% 
                    filter(cut == input$cutinp, 
                           color == input$colorinp, 
                           clarity == input$clarityinp)
        
            ggplot(di, aes(x = carat, y = price), position = "jitter") +
            geom_point() +
            geom_smooth(method = "lm") +
            geom_point(aes(x = input$caratinp, y = predprice()), col = "red", size = 5) +
            labs(title = "Diamond Price Graph: carat vs price", subtitle = "The black data points represent the prices of all (different carat) diamonds of the selected qualities, from the R dataset Diamonds", caption = "The red dot is the estimate. *Note: Much more inaccurate if the carat size is too big.", x = "diamond carat", y = "diamond price") 
            
        })
    
    

})
