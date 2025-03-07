# Cargar librerías necesarias
library(ggplot2)
library(dplyr)
library(shiny)
library(readxl)

# Leer el archivo de datos
file_path <- "datos/df.xlsx"
data <- readxl::read_excel(file_path)
data$Fecha <- as.Date(data$Fecha, format = "%Y-%m-%d")
data$Ano <- format(data$Fecha, "%Y")
ui <- fluidPage(
  titlePanel("Tendencia de Goles Esperados (xG) por Equipo y Año"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "equipos",
        label = "Seleccione hasta 3 equipos:",
        choices = unique(data$Equipo),
        selected = unique(data$Equipo)[1:3],
        multiple = TRUE
      ),
      selectInput(
        inputId = "anos",
        label = "Seleccione los años a incluir:",
        choices = unique(data$Ano),
        selected = unique(data$Ano),
        multiple = TRUE
      ),
      helpText("Elige equipos y años para visualizar su tendencia de xG.")
    ),
    mainPanel(
      plotOutput("tendencia_xg_plot")
    )
  )
)

server <- function(input, output) {
  output$tendencia_xg_plot <- renderPlot({
    # Filtrar los datos por los equipos y años seleccionados
    data_filtrada <- data %>%
      filter(Equipo %in% input$equipos, Ano %in% input$anos) %>%
      group_by(Equipo, Fecha) %>%
      summarize(xG_promedio = mean(xG, na.rm = TRUE), .groups = "drop")
    
    # Crear el gráfico
    ggplot(data_filtrada, aes(x = Fecha, y = xG_promedio, color = Equipo, group = Equipo)) +
      geom_line(size = 1) +
      labs(
        title = "Tendencia de Goles Esperados (xG) por Equipo y Año",
        x = "Fecha",
        y = "Promedio de xG",
        color = "Equipo"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
}

# Ejecutar la app
shinyApp(ui = ui, server = server)
