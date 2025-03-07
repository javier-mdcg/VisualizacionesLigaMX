library(leaflet)
library(dplyr)
library(sf)
library(readxl)

df <- read.csv("datos/mapa.csv")
mxpolig <- st_read("datos/MapaMexico.geojson")


df_agrupado <- df %>%
  group_by(Estado) %>%
  summarise(
    equipos = paste(Equipo, collapse = ", "),
    total_ganados = sum(Ganados),
    total_jugados = sum(Jugados),
    porcentaje_victorias = (total_ganados / total_jugados) * 100
  ) %>%
  mutate(Estado = toupper(Estado))

mxpolig <- mxpolig %>%
  mutate(ENTIDAD = toupper(ENTIDAD))

mxpolig_data <- mxpolig %>%
  left_join(df_agrupado, by = c("ENTIDAD" = "Estado"))

mxpolig_data <- mxpolig_data %>%
  mutate(
    categoria = case_when(
      porcentaje_victorias < 35 ~ "Bajo (<35%)",
      porcentaje_victorias >= 35 & porcentaje_victorias <= 45 ~ "Medio (35-45%)",
      porcentaje_victorias > 45 ~ "Alto (>45%)",
      TRUE ~ "Sin equipo"
    )
  )

palVictorias <- colorFactor(
  palette = c("#FF9999", "#FFCC99", "#99FF99", "#CCCCCC"),  
  levels = c("Bajo (<35%)", "Medio (35-45%)", "Alto (>45%)", "Sin equipo")
)

leaflet(mxpolig_data) %>%
  addTiles(group = "OpenStreetMap") %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.2,
    opacity = 1.0,
    fillOpacity = 0.7,
    fillColor = ~palVictorias(categoria),
    highlightOptions = highlightOptions(
      color = "white",
      weight = 2,
      bringToFront = TRUE
    ),
    label = ~paste0(
      "Estado: ", ENTIDAD, "<br>",
      "Equipos: ", ifelse(!is.na(equipos), equipos, "Ninguno"), "<br>",
      "Total Ganados: ", ifelse(!is.na(total_ganados), total_ganados, "N/A"), "<br>",
      "Total Jugados: ", ifelse(!is.na(total_jugados), total_jugados, "N/A"), "<br>",
      "% Victorias: ", ifelse(!is.na(porcentaje_victorias), 
                              round(porcentaje_victorias, 1), 
                              "N/A"), "%"
    ),
    labelOptions = labelOptions(direction = "auto", html = TRUE),
    group = "Por Categoría"
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = palVictorias,
    values = ~categoria,
    title = "Porcentaje de Victorias",
    group = "Por Categoría"
  )
