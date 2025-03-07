library(dplyr)
library(ggplot2)
library(readxl)

# Cargar los datos
file_path <- "datos/df.xlsx"
dataIndice <- read_excel(file_path)

# Normalizar variables por 90 minutos
dataIndice$BalonesRecuperadosAltos_per90 <- (dataIndice$`Balones Recuperados Altos` / dataIndice$Duracion) * 90
dataIndice$DuelosGanados_per90 <- (dataIndice$`Duelos Ganados` / dataIndice$Duracion) * 90
dataIndice$TirosTotales_per90 <- (dataIndice$`Tiros Totales` / dataIndice$Duracion) * 90
# 'Posesión (%)' ya está en porcentaje

# Estandarizar las variables
dataIndice$BalonesRecuperadosAltos_z <- scale(dataIndice$BalonesRecuperadosAltos_per90)
dataIndice$DuelosGanados_z <- scale(dataIndice$DuelosGanados_per90)
dataIndice$TirosTotales_z <- scale(dataIndice$TirosTotales_per90)
dataIndice$Posesion_z <- scale(dataIndice$`Posesion (%)`)

# Crear el Índice de Presión
dataIndice$PressureIndex <- rowMeans(dataIndice[, c('BalonesRecuperadosAltos_z', 'DuelosGanados_z', 'TirosTotales_z', 'Posesion_z')])

# Escalar el Índice entre 0 y 1
min_index <- min(dataIndice$PressureIndex, na.rm = TRUE)
max_index <- max(dataIndice$PressureIndex, na.rm = TRUE)
dataIndice$PressureIndex_scaled <- (dataIndice$PressureIndex - min_index) / (max_index - min_index)

# Filtrar los empates
dataIndice_filtrado <- dataIndice %>% filter(Resultado != 0)

# Crear la variable binaria 'Win'
dataIndice_filtrado$Win <- ifelse(dataIndice_filtrado$Resultado == 1, 1, 0)

# Visualizar la relación entre el Índice de Presión y el Resultado
ggplot(dataIndice_filtrado, aes(x = PressureIndex_scaled, y = Win)) +
  geom_jitter(width = 0.1, height = 0.1) +
  geom_smooth(method = 'glm', method.args = list(family = 'binomial'), se = TRUE) +
  labs(title = 'Índice de Presión vs. Resultado del Partido',
       x = 'Índice de Presión',
       y = 'Derrota (0) o Victoria (1)')

# Ajustar el modelo de regresión logística
modelo <- glm(Win ~ PressureIndex_scaled, data = dataIndice_filtrado, family = 'binomial')
summary(modelo)


# Seleccionar solo las columnas numéricas
numerical_vars <- sapply(dataIndice_filtrado, is.numeric)
data_numeric <- dataIndice_filtrado[, numerical_vars]
# Calcular las correlaciones con 'Win'
correlations <- sapply(data_numeric, function(x) cor(data_numeric$Win, x, use = "complete.obs"))
# Excluir la correlación de 'Win' consigo mismo
correlations <- correlations[names(correlations) != "Win"]

# Ordenar las correlaciones por valor absoluto
sorted_correlations <- sort(abs(correlations), decreasing = TRUE)
# Obtener los nombres de las tres variables principales
top_3_vars <- names(sorted_correlations)

# Obtener las correlaciones correspondientes
top_3_correlations <- correlations[top_3_vars]

# Mostrar los resultados
print("Las tres variables con mayor correlación con 'Win' son:")
print(top_3_correlations)

