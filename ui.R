library(shiny)
library(leaflet)

shinyUI(fluidPage("Estonian settlements", id="nav",
  mainPanel(
    div(class="outer",
      tags$head(
        includeCSS("styles.css")
      ),

      leafletOutput("map", width="100%", height="100%"),

        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 250, height = "auto",

        h3("Estonian settlements"),
        textInput("filter", "Filter:", ""),
        span("Number of places selected: ", textOutput("n_places")),
        selectInput("s_names", "", "", multiple=T, selectize=F, size=20)
      )
    )
  )
))
