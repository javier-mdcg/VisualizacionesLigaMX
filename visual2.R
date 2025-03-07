library(ggplot2)
library(dplyr)
library(readxl)

# Leer los datos
file_path <- "datos/df.xlsx"
graf2 <- readxl::read_excel(file_path)

# Convertir la fecha a formato Date
graf2$Fecha <- as.Date(graf2$Fecha, format = "%Y-%m-%d")

# Calcular la columna Resultado según Goles Netos
graf2 <- graf2 %>%
  mutate(Resultado = case_when(
    `Goles Netos` > 0 ~ 1,
    `Goles Netos` == 0 ~ 0,
    `Goles Netos` < 0 ~ -1,
    TRUE ~ NA_real_
  ))

# Asignar puntos según la columna "Resultado"
graf2 <- graf2 %>%
  mutate(Puntos = case_when(
    Resultado == 1 ~ 3,
    Resultado == 0 ~ 1,
    Resultado == -1 ~ 0,
    TRUE ~ NA_real_
  ))

graf2 <- graf2 %>%
  filter(Temporada != "-2025")

# Calcular los puntos acumulados por equipo y temporada
puntos_acumulados <- graf2 %>%
  group_by(Temporada, Equipo) %>%
  summarize(Puntos_Totales = sum(Puntos, na.rm = TRUE), .groups = "drop")

# Crear la gráfica con facet_wrap para separar por temporada
ggplot(puntos_acumulados, aes(y = reorder(Equipo, -Puntos_Totales), x = Puntos_Totales, fill = Equipo)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~Temporada, ncol = 2) + # Crear una gráfica separada por temporada
  labs(
    title = "Puntos Ganados por Equipo por Temporada",
    x = "Equipo",
    y = "Puntos Totales"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

