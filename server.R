library(shiny)
library(leaflet)
library(dplyr)

shinyServer(function(input, output, session) {

  filteredPlaces <- reactive({
    infilter <- input$filter
    inselect <- input$s_names

    if (!is.null(infilter) && infilter != "") {
      p <- filter(places, grepl(infilter, Kohanimi, ignore.case=T, perl=T))
    } else {
      p <- places
    }
    p$radius = 3
    p$opacity = 0.5
    p$color = "red"

    #if (!is.null(inselect) && inselect != "") {
    #  if (any(p$Kohanimi == inselect)) {
    #    p[p$Kohanimi %in% inselect, ]$radius = 5
    #    p[p$Kohanimi %in% inselect, ]$opacity = 0.7
    #    p[p$Kohanimi %in% inselect, ]$color = "green"
    #  }
    #}
    
    p <- p[order(p[2]), ]
  })

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = 'http://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
        attribution = 'Maps by <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> and <a href="http://cardodb.org/attributions">CartoDB</a> | Place data from <a href="http://www.maaamet.ee/">Estonian Land Board</a>'
      ) %>%
      setView(lng = 25.47, lat = 58.35, zoom = 8)
  })

  observe({
    f <- filteredPlaces()
    n <- sort(f[,2])

    leafletProxy("map", data = places) %>%
      clearMarkers()
    leafletProxy("map", data = f) %>%
      clearMarkers() %>%
      addCircleMarkers(~lat, ~lng, radius=~radius, layerId=~Kohanimi,
        stroke=FALSE, fillOpacity=~opacity, fillColor=~color, popup=~Kohanimi)
    
    updateSelectInput(session, "s_names", choices = f[,2], selected = f[f$color=="green",2])
    output$n_places <- renderText({ nrow(f) })
  })
})
