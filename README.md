# Visualización de datos de la LigaMX
Proyecto de visualizaciones con cuadros de mando en R para analizar datos de la Liga MX. Se desarrollaron dashboards interactivos y gráficos para explorar tendencias en goles esperados, rendimiento de equipos, índices de presión, distribución de victorias por estado y la relación entre PIB estatal y desempeño futbolístico.

## Herramientas y librerías utilizadas
- **Shiny**: Desarrollo de aplicaciones web interactivas para visualizar tendencias por equipo y temporada.
- **ggplot2**: Creación de gráficos para analizar puntos ganados por equipo, correlaciones con el índice de presión y relación entre PIB local y rendimiento de equipos.
- **Leaflet**: Mapas interactivos para representar estadísticas por estado.
- **dplyr**: Manipulación y filtrado de datos para cálculos y visualizaciones eficientes.
- **sf**: Importación y procesamiento de datos desde archivos geoespaciales.

## Análisis realizado
1. **Tendencia de goles esperados**: Se examinaron los goles esperados por equipo a lo largo del tiempo para identificar patrones de rendimiento.
2. **Puntos acumulados**: Se calcularon los puntos obtenidos por equipo en cada temporada y se representaron en gráficos comparativos.
3. **Índice de presión**: Se construyó un índice basado en balones recuperados, duelos ganados y posesión, analizando su relación con victorias.
4. **Distribución de victorias por estado**: Se crearon mapas interactivos para visualizar el porcentaje de victorias de equipos por estado.
5. **Relación PIB - rendimiento**: Se exploró si el PIB estatal influye en el éxito de los equipos, aplicando modelos de regresión lineal.

## Resultados obtenidos
- Se identificaron tendencias en la evolución de los goles esperados, que reflejan cambios tácticos y estratégicos en los equipos a lo largo de las temporadas.
- Se encontró que el índice de presión no tenía una correlación significativa con las victorias, lo que sugiere que otros factores son más determinantes en los resultados de los partidos.
- Se observó una distribución desigual de victorias entre estados, con algunas regiones mostrando una mayor concentración de equipos exitosos.
- Se evidenció una correlación positiva entre el PIB estatal y el rendimiento futbolístico, indicando que factores económicos pueden influir en el éxito de los equipos.

## Conclusión
El proyecto demostró cómo el análisis de datos y la visualización pueden proporcionar información valiosa sobre el rendimiento de los equipos en la Liga MX. Los hallazgos obtenidos pueden ser útiles para analistas deportivos, entrenadores y aficionados interesados en comprender los factores que influyen en el éxito de un equipo. Además, la experiencia adquirida en el trabajo con `Shiny`, `ggplot2` y `Leaflet` reforzó habilidades clave en análisis y comunicación de datos.
