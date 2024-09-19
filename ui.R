# Define UI for application that draws a histogram

shiny::navbarPage(
  "Police Recorded Crime dashboard",
  tabPanel(
    "Plots by Financial Year",
        # Sidebar layout
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        id = "plot-sidebar",
        shinyWidgets::pickerInput(
          inputId = "fy",
          label = "Financial year",
          choices = c("2012/13", "2013/14", "2014/15", "2015/16", "2016/17", 
                      "2017/18", "2018/19", "2019/20", "2020/21", "2021/22",
                      "2022/23", "2023/24"),
          selected = "2023/24",
          multiple = FALSE
        ),
        uiOutput("picker_q"),
        uiOutput("picker_og"),
        uiOutput("picker_osg"),
        uiOutput("picker_od")
      ),
      
      # Show my plots
      shiny::mainPanel(
        shiny::fluidRow(
          htmltools::div(
            id = "plot-text",
            htmltools::p(
              "This is a shiny dashboard showing Police Recorded data from the open data tables published by the Home Office here: ",
              htmltools::a("Police recorded crime open data tables.", href = "https://www.gov.uk/government/statistics/police-recorded-crime-open-data-tables"),
              "The shapefile used can be downloaded from the ONS Open Geography Portal here: ",
              htmltools::a("Police Force Area Shapefile download.", href = "https://geoportal.statistics.gov.uk/datasets/ons::police-force-areas-december-2022-ew-buc/explore?location=53.007314%2C-0.021147%2C7.01"),
              "The ultra-generalised shapefile is used to render the map quickly."
            ),
            htmltools::br(),
            htmltools::p("Note that the table being used is the Police Force Area table containing data from March 2013 onwards."),
            htmltools::br(),
            htmltools::p("Data is included from Law Enforcement Agencies which may not have an easily mappable area such as the British Transport Police."),
            htmltools::p("This data on its own is not necessarily an indicator of the level of crime in a Police Force Area as unreported crimes won't appear. There may also be differences in how police forces will record different types of crimes")
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 6,
            htmltools::h4("Choropleth map of selected offences recorded by Police Force Areas"),
            plotly::plotlyOutput("chloroplot")
          ),
          shiny::column(
            width = 6,
            htmltools::h4("Bar chart of selected offences recorded by Law Enforcement Agencies which don't have a mappable Police Force Area."),
            shiny::plotOutput("xtrabar")
          )
        )
      )
    )
  ),
  shiny::tabPanel(
    "Data table",
    # Sidebar layout
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        id = "plot-sidebar",
        uiOutput("picker_table_fn"),
        uiOutput("picker_table_og"),
        uiOutput("picker_table_osg"),
        uiOutput("picker_table_od")
      ),
      
      # Show my plots
      shiny::mainPanel(
        shiny::fluidRow(
          htmltools::div(
            class= "table-text",
            id = "plot-text",
            htmltools::p(
              "This is a shiny dashboard showing Police Recorded data from the open data tables published by the Home Office here: ",
              htmltools::a("Police recorded crime open data tables.", href = "https://www.gov.uk/government/statistics/police-recorded-crime-open-data-tables")
            ),
            htmltools::br(),
            htmltools::p("Note that the table being used is the Police Force Area table containing data from March 2013 onwards."),
            htmltools::p("This data on its own is not necessarily an indicator of the level of crime in a Police Force Area as unreported crimes won't appear. There may also be differences in how police forces will record different types of crimes")
          )
        ),
        shiny::fluidRow(
          id = "download-button",
          style = "margin-bottom: 1rem;",
          downloadButton("download", "Download sidebar selected data .csv")
        ),
        shiny::fluidRow(
          DT::dataTableOutput("prcdata")
        )
      )
    )
  ),
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "my_styles.css")
  ),
)
                  
  
