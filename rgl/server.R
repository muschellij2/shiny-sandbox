library(rgl)
library(RColorBrewer)
library(colorspace)
library(xtable)


choices <- c("WM", "GM", "Lesion")
ccols <- c("red", "green", "blue")
names(ccols) <- choices
dset <- list(matrix(rnorm(100*3), ncol=3), 
             matrix(rnorm(100*3), ncol=3), 
             matrix(rnorm(100*3), ncol=3))
names(dset) <- choices
scan1 <- dset
dset <- list(matrix(rnorm(100*3), ncol=3), 
             matrix(rnorm(100*3), ncol=3), 
             matrix(rnorm(100*3), ncol=3))
names(dset) <- choices
scan2 <- dset

reactiveWebGL <- function(func){
  reactive(function(){
    func()
    
    source("webGLParser.R")
    extractWebGL()    
  })
}



shinyServer(function(input, output) {

#   #eval(dset <- input$dataset)
  

  datasetInput <- reactive(function() {
    switch(input$dataset,
           "scan1" = scan1,
           "scan2" = scan2)
  })
  
  output$webGL <- reactiveWebGL(function() {
    
    dset <- datasetInput()
    # print(input)
    
    
    
#    chosen <- c(input[[choices]])
    chosen <- c(input$WM, input$GM, input$Lesion)
    sum_c <- sum(chosen)
    cc <- choices[chosen]
    cols <- ccols[chosen]
    
    output$view <- reactivePrint(function() {
#       print(input$dataset)
    })
    
    print(sum_c)
    if (sum_c > 0){
      plot3d(dset[[cc[1]]], xlab="x", ylab="y", zlab="z", col=cols[1]) 
      if (sum_c > 1)
        for (itype in 2:sum_c) points3d(dset[[cc[itype]]], col=cols[itype])
    }
    
  })

})
