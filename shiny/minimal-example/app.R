library(shiny)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Minimal Shiny App"),

    # Sidebar with sliders for mean and standard deviation
    sidebarLayout(
        sidebarPanel(
            sliderInput("mean",
                        "Mean:",
                        min = -10,
                        max = 10,
                        value = 0),
            sliderInput("sd",
                        "Standard Deviation:",
                        min = 0.1,
                        max = 10,
                        value = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic
server <- function(input, output) {

    output$distPlot <- renderPlot({
        x    <- rnorm(1000, mean = input$mean, sd = input$sd)
        hist(x, breaks = 50, col = 'darkgray', border = 'white')
    })
}

# Run the application
shinyApp(ui = ui, server = server)
