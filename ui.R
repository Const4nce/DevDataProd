library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(

  # Application title.
  titlePanel("Amsterdam Transportation"),

  # Sidebar with controls to select a dataset and specify the
  # number of observations to view. The helpText function is
  # also used to include clarifying text. Most notably, the
  # inclusion of a submitButton defers the rendering of output
  # until the user explicitly clicks the button (rather than
  # doing it immediately when inputs change). This is useful if
  # the computations required to render output are inordinately
  # time-consuming.
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a method:",
                  choices = c("Bicycling","Driving", "Walking", "Transit")),
      textInput("starting", "Starting Point:", "e.g. Buitenveldert or 1083AB"),
      textInput("destination", "Destination:", "e.g. Dam Square or 1012AB"),

      helpText("Note: You can define the area (e.g. Dam Square) or zipcode (e.g. 1012AB)"),
      uiOutput('varselect'),

      h3("Outputs"),
      h4("For method you entered"),
      verbatimTextOutput("odataset"),
      h4("For Starting Point you entered"),
      verbatimTextOutput("ostarting"),
      h4("For Destination Point you entered"),
      verbatimTextOutput("odestination")
    ),

    # Show a summary of the dataset and an HTML table with the
    # requested number of observations. Note the use of the h4
    # function to provide an additional header above each output
    # section.
    mainPanel(
      tabsetPanel(
        tabPanel("About", includeMarkdown("about.Rmd")),
        tabPanel("Route", textOutput("error"),
                 plotOutput("map"),
                 textOutput("view"),
                 textOutput("view2"))
      )
    )
  )
))
