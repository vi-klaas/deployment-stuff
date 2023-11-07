library(shiny)
library(shinydashboard)

list_shiny_apps <- function(directory) {
  apps <- list.dirs(path = directory, full.names = FALSE, recursive = FALSE)
  apps <- setdiff(apps, "index") # Exclude the 'index' directory
  return(apps)
}

ui <- dashboardPage(
  dashboardHeader(title = "Shiny Applications"),
  dashboardSidebare(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(title = "Available Apps", status = "primary", solidHeader = TRUE, collapsible = TRUE,
          uiOutput("app_list")))
  )
)

server <- function(input, output) {
  output$app_list <- renderUI({
    apps <- list_shiny_apps("/srv/shiny-server/")
    links <- lapply(apps, function(app) {
      tags$li(a(href=paste0("/shiny/", app), app))
    })
    do.call(tagList, links)
  })
}

shinyApp(ui, server)
