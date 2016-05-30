library(shiny)
library(datasets)
library(ggmap)

distance <- 0
time <- 0
# Define server logic required to summarize and view the
# selected dataset
shinyServer(function(input, output, session) {

  # illustrating output
  output$odataset <- renderPrint({input$dataset})
  output$ostarting <- renderPrint({input$starting})
  output$odestination <- renderPrint({input$destination})

  # selecting input

  datasetInput <- reactive({
    switch(input$dataset,
           "Bicycling" = "bicycling",
           "Walking" = "walking",
           "Driving" = "driving",
           "Transit" = "transit")
  })

  # Generate map
  output$map <- renderPlot({
    if (input$goButton == 0 || is.null(input$goButton)){
      return()
    }else{

      isolate({
        from <- input$starting
        to <- input$destination
        route_df <- calculateRoute(from, to, datasetInput())

        if(sum(route_df$km, na.rm = "TRUE") > 0) {
          print("qmap")
          displayError(FALSE)

          qmap('Amsterdam, netherlands', zoom = 12) +
            geom_path(
              aes(x = lon, y = lat),  colour = 'blue', size = 1.5,
              data = route_df, lineend = 'round')
        }else{
          displayError(TRUE)
        }
      })}
  })

  #distance
  output$view <- renderText({
    if (input$goButton == 0 || is.null(input$goButton))
      return()
    isolate({
      from <- input$starting
      to <- input$destination
      route_df <- calculateRoute(from, to, datasetInput())

      if(sum(route_df$km, na.rm = "TRUE") > 0) {
        distance <- sum(route_df$km, na.rm = "TRUE")
        time <- round((sum(route_df$seconds, na.rm = "TRUE") / 60),2)
        paste("Distance: ", distance, "km")}
    })
  })

  #time
  output$view2 <- renderText({
    if (input$goButton == 0 || is.null(input$goButton))
      return()
    isolate({
      from <- input$starting
      to <- input$destination
      route_df <- calculateRoute(from, to, datasetInput())

      if(sum(route_df$km, na.rm = "TRUE") > 0) {
        distance <- sum(route_df$km, na.rm = "TRUE")
        time <- round((sum(route_df$seconds, na.rm = "TRUE") / 60),2)
        paste("Time required: ", time, "minutes")}
    })
  })

  #ActionButton
  output$varselect <- renderUI({
    if(input$starting == ''){return()}
    if(input$destination == ''){return()}
    if(input$starting == "e.g. Buitenveldert or 1083AB"){return()}
    if(input$destination == "e.g. Dam Square or 1012AB"){return()}
    actionButton('goButton', 'Go!')
  })

  #Error
  displayError <- function(error){
    output$error <- renderText(
      if(error){
        paste("Please enter a valid Start Point/Destination")
      }else{
        paste("")
        })
  }
})

calculateRoute <- function(from,to,mode){
  route_df <- tryCatch(route(from, to, structure = 'route', mode = mode, output = "simple"),
                       warning = function(w) {
                         print("warning")
                         return(w)
                       },
                       error = function(e){
                         print("error")
                         return(e)
                       })
  return(route_df)
}


