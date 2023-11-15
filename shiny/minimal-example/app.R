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

  prom_refuser_date_bl <- j %>%
  filter(!is.na(proms_ref_date_inj) ) %>%
  mutate(prom_ref_date_bl = proms_ref_date_inj + days(14)) %>%
  select(fall_id, gender_pers_info, proms_ref_date_inj, prom_ref_date_bl, proms_ref_what_BL, proms_ref_what_FU3M, proms_ref_what_FU1Y, proms_recr_status_inj) %>%
  filter(prom_ref_date_bl <=  Sys.Date()) %>%
  mutate(Ref_compl = case_when((proms_ref_what_BL == "Refused to participate in / will not complete any PROMS") ~ 1,
                               (proms_ref_what_BL == "Refused to participate in / will not complete the PROMS BL") ~ 1,
                               #                            (proms_ref_what_FU3M == "Refused to participate in / will not complete any PROMS") ~ 1,
                               #                             (proms_ref_what_FU1Y == "Refused to participate in / will not complete any PROMS") ~ 1,
                               is.na(proms_ref_what_BL) ~2,
                               TRUE ~NA_real_)) %>%
  filter(Ref_compl == 1) %>%
  group_by(gender_pers_info) %>%
  summarise(Refuser_BL=n())
}

# Run the application
shinyApp(ui = ui, server = server)
