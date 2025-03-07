library(leaflet)
library(dplyr)
library(sf)

datos <- read.csv("datos/pib.csv")
mxpolig <- st_read("datos/MapaMexico.geojson")

datos <- datos %>%
  mutate(estado = toupper(estado))

mxpolig <- mxpolig %>%
  mutate(ENTIDAD = toupper(ENTIDAD))

mxpolig_data <- mxpolig %>%
  left_join(datos, by = c("ENTIDAD" = "estado"))

mxpolig_data <- mxpolig_data %>%
  mutate(
    categoria = case_when(
      porcentaje < 2 ~ "Bajo (<2%)",
      porcentaje >= 2 & porcentaje <= 4 ~ "Medio (2-4%)",
      porcentaje > 4 ~ "Alto (>4%)"
    )
  )


palPIB <- colorFactor(
  palette = c("red", "orange", "green"),
  levels = c("Bajo (<2%)", "Medio (2-4%)", "Alto (>4%)")
)


leaflet(mxpolig_data) %>%
  addTiles(group = "OpenStreetMap") %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.2,
    opacity = 1.0,
    fillOpacity = 0.5,
    fillColor = ~palPIB(categoria),
    highlightOptions = highlightOptions(
      color = "white",
      weight = 2,
      bringToFront = TRUE
    ),
    label = ~paste0(
      "PIB: ", porcentaje
    ),
    labelOptions = labelOptions(direction = "auto", html = TRUE),  
    group = "Por Categoría"
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = palPIB,
    values = ~categoria,
    title = "Categoría del PIB (%)",
    group = "Por Categoría"
  )

