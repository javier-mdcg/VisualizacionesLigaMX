library(ggplot2)

pib <- read.csv("datos/pib.csv")
equipos <- read.csv("datos/mapa.csv")

equipos$ratio_victorias <- equipos$Ganados / equipos$Jugados
equipos_agregados <- aggregate(
  cbind(ratio_victorias, Jugados) ~ Estado, 
  data = equipos, 
  FUN = mean
)

datos_completos <- merge(pib, equipos_agregados, 
                         by.x = "estado", 
                         by.y = "Estado", 
                         all = FALSE)

modelo <- lm(ratio_victorias ~ porcentaje, data = datos_completos)

ggplot(datos_completos, aes(x = porcentaje, y = ratio_victorias)) +
  geom_point(aes(size = Jugados), alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  geom_text(aes(label = estado), 
            vjust = -0.5, 
            hjust = 0.5, 
            size = 3) +
  labs(
    title = "Relación entre PIB Estatal y Rendimiento Futbolístico",
    x = "Porcentaje del PIB Estatal",
    y = "Ratio de Victorias",
    size = "Partidos Jugados"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title = element_text(face = "bold")
  )

