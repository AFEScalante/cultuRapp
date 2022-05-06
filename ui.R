library(shiny)
library(shinyWidgets)
library(tidyverse)
library(here)
library(sf)
library(leaflet)
library(scales)
library(echarts4r)
library(ggdark)
library(fontawesome)

#Importa datos
load("datos/puntos-culturales-cdmx.RData")
lugares <- puntos_tbl$lugar

ui <- fluidPage(
  title = "Shiny App - cultuRapp CDMX",
  setBackgroundColor("#171717"),
  column(
    br(), br(), br(),
    div(style="display: inline-block;vertical-align:left; width: 130px;
        color: white;",
        br(),
        h2("cultuRapp CDMX"), align = "left"),
    br(), br(),
    div(style="color: gray;",
        h3("Puntos culturales dentro de la Ciudad de México")),
    div(style="color: gray; width: 335px; align: left; margin-left: 50px;",
        p(align = "left", 
          "Esta aplicación muestra un mapa con todos los puntos culturales según el SIC México (Sistema de Información Cultural) extraído al 20/12/2021.")),
    br(), br(),
    selectizeInput(inputId = "tipo",
                   label = "Tipo de lugar",
                   choices = lugares,
                   selected = lugares[1],
                   multiple = TRUE
    ),
    actionButton(inputId = "mostrar", "Mostrar"),
    br(), br(),
    div(style="color: white; width: 335px; align: left; margin-left: -5px;",
        a(fa("github", fill = "white", height = "2em"), href = "https://github.com/AFEScalante/culturapp")
    ),
    align = "center", width = 4
  ),
  column(
    leafletOutput("mapa", width = 700, height = 380),
    echarts4rOutput("conteosPlot", width = 700, height = 200),
    width = 8,
    align = "right"
  )
)