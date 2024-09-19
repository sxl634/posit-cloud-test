library(shiny)
library(dplyr)
library(ggplot2)
library(sf)
source("R/load_data.R")
source("R/chloropleth generator.R")
source("R/my_theme.R")


server <- function(input, output) {
  prc_data <- load_prc_data()
  pfa_sf <- load_pfa_shapefile()
  # pfa_sf <- rmapshaper::ms_simplify(pfa_sf)
  
  # pfa_sf <- sf::forti
  
  output$picker_q <- renderUI({
    choices <- unique(
      prc_data$Financial.Quarter[prc_data$Financial.Year %in% input$fy]
    )
    shinyWidgets::pickerInput(
      inputId = "q",
      label = "Quarter",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  })  

  output$picker_og <- renderUI({
    choices <- unique(
      prc_data$Offence.Group
    )
    og <- shinyWidgets::pickerInput(
      inputId = "og",
      label = "Offence group",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  }) 
  
  output$picker_osg <- renderUI({
    choices <- unique(
      prc_data$Offence.Subgroup[prc_data$Offence.Group %in% input$og]
    )
    osg <- shinyWidgets::pickerInput(
      inputId = "osg",
      label = "Offence Subgroup",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
    
  }) 
  
  output$picker_od <- renderUI({
    choices <- unique(
      prc_data$Offence.Description[prc_data$Offence.Group %in% input$og &
                                     prc_data$Offence.Subgroup %in% input$osg]
    )
    od <- shinyWidgets::pickerInput(
      inputId = "od",
      label = "Offence Description",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  })

  output$picker_table_fn <- renderUI({
    choices <- unique(prc_data$Force.Name)
    
    shinyWidgets::pickerInput(
      inputId = "fn_table",
      label = "Force Name",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  })
  
  output$picker_table_og <- renderUI({
    choices <- unique(
      prc_data$Offence.Group
    )
    og <- shinyWidgets::pickerInput(
      inputId = "og_table",
      label = "Offence group",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  }) 
  
  output$picker_table_osg <- renderUI({
    choices <- unique(
      prc_data$Offence.Subgroup[prc_data$Offence.Group %in% input$og_table]
    )
    osg <- shinyWidgets::pickerInput(
      inputId = "osg_table",
      label = "Offence Subgroup",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
    
  }) 
  
  output$picker_table_od <- renderUI({
    choices <- unique(
      prc_data$Offence.Description[prc_data$Offence.Group %in% input$og_table &
                                     prc_data$Offence.Subgroup %in% input$osg_table]
    )
    od <- shinyWidgets::pickerInput(
      inputId = "od_table",
      label = "Offence Description",
      choices = choices,
      selected = choices[1:length(choices)],
      multiple = TRUE,
      options = list(`actions-box` = TRUE)
    )
  })

  output$chloroplot <- plotly::renderPlotly({
    req(length(input$od) > 0)
    chloropleth_generator(
      prc_data = prc_data,
      pfa_sf = pfa_sf,
      fy = input$fy,
      q = input$q,
      og = input$og,
      osg = input$osg,
      od = input$od
    )
  })
  
  output$xtrabar <- shiny::renderPlot({
    req(length(input$od) > 0)
    barchart_generator(
      prc_data = prc_data,
      pfa_sf = pfa_sf,
      fy = input$fy,
      q = input$q,
      og = input$og,
      osg = input$osg,
      od = input$od
    )
  })
  
  output$prcdata <- DT::renderDataTable({
    req(length(input$od_table) > 0)
    as.data.frame(prc_data) %>%
      dplyr::select(
        `Financial Year` = Financial.Year,
        `Financial Quarter` = Financial.Quarter,
        `Force Name` = Force.Name,
        `Offence Group` = Offence.Group, 
        `Offence Subgroup` = Offence.Subgroup, 
        `Offence Description` = Offence.Description, 
        `Number of Offences` = Number.of.Offences
      ) %>%
      dplyr::filter(`Force Name` %in% input$fn_table) %>%
      dplyr::filter(`Offence Group` %in% input$og_table) %>%
      dplyr::filter(`Offence Subgroup` %in% input$osg_table) %>%
      dplyr::filter(`Offence Description` %in% input$od_table) %>%
      dplyr::mutate(
        `Number of Offences` = formatC(`Number of Offences`, format="d", big.mark=",")
      )
    },
    server = TRUE,
    options = list(
      order = list(list(0, "desc"))
    ),
    filter = "top",
    rownames = FALSE
  )
  
  data <- reactive({
    data <- prc_data %>%
      dplyr::select(
        `Financial Year` = Financial.Year,
        `Financial Quarter` = Financial.Quarter,
        `Force Name` = Force.Name,
        `Offence Group` = Offence.Group, 
        `Offence Subgroup` = Offence.Subgroup, 
        `Offence Description` = Offence.Description, 
        `Number of Offences` = Number.of.Offences
      ) %>%
      dplyr::filter(`Force Name` %in% input$fn_table) %>%
      dplyr::filter(`Offence Group` %in% input$og_table) %>%
      dplyr::filter(`Offence Subgroup` %in% input$osg_table) %>%
      dplyr::filter(`Offence Description` %in% input$od_table)
    
  })
  
  output$download <- downloadHandler(
    
    filename = function() {
      paste0("data.csv")
    },
    content = function(file) {
      readr::write_csv(data(), file)
    }
  )
}
