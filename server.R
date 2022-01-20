server <- function(input, output, session) {
  load("datos/puntos-culturales-cdmx.RData") #Importa datos
  alcaldias_cdmx <- st_read("datos/alcaldias/") #Lectura mapa alcaldías
  alcaldias_longlat <- alcaldias_cdmx |> st_transform(crs = 4326) #Trans para leaflet
  alcaldias_longlat$nomgeo[c(2, 4, 5, 12, 16)] <- #Limpia nombre de alcaldías
    c("Cuauthémoc", "Álvaro Obregon", "Coyoacán", "Benito Juárez", "Tláhuac")

  paleta <- colorFactor(
    palette = "Dark2",
    domain = unique(puntos_tbl$lugar)
  )

  puntos <- eventReactive(input$mostrar, {
    puntos_tbl |> filter(lugar %in% input$tipo)
  })

  output$mapa <- renderLeaflet({
    leaflet(data = puntos()) |>
      addProviderTiles(
        "CartoDB.DarkMatter",
        options = tileOptions(minZoom = 10, maxZoom = 20)) |>
      addCircles(
        data = puntos(),
        lng = ~longitude,
        lat = ~latitude,
        color = ~paleta(lugar)
      ) |>
      addPolygons(data = alcaldias_longlat, opacity = 0.2, popup = ~nomgeo) |>
      addLegend("bottomright", pal = paleta, values = ~lugar)
  })

  output$conteosPlot <- renderEcharts4r({
    puntos_alc <- puntos() |>
      count(alcaldia, lugar) |> 
      arrange(desc(alcaldia)) |> 
      group_by(lugar)
    
    puntos_alc |>
      e_charts(alcaldia, stack = "grp") |>
      e_bar(n) |> 
      e_tooltip(
        trigger = "axis",
        axisPointer = list(
          type = "shadow"
        )) |>
      e_theme("dark") |> 
      e_color(background = "#171717") |>
      e_legend(type = "scroll") |> 
      e_y_axis(
        splitArea = list(show = FALSE),
        splitLine = list(show = FALSE)
      ) |> 
      e_flip_coords() |> 
      e_toolbox_feature(
        feature = "saveAsImage",
        title = "Guardar como imágen"
      )

  })

}
