# prc_data <- readRDS("Data visualisation/Assignment/Exercise 3/Data/prc-default.RDS")
# pfa_sf <- sf::read_sf(dsn="Data visualisation/Assignment/Exercise 3/Data/Police_Force_Areas_December_2022_EW_BUC", layer="PFA_DEC_2022_EW_BUC_V2")
# fy  = c("2021/22")
# q   = c(1:4)
# og  = prc_data$Offence.Group
# osg = prc_data$Offence.Subgroup
# od  =prc_data$Offence.Description

chloropleth_generator <- function(prc_data, pfa_sf, fy, q, og, osg, od) {
   prc_data_filtered <- prc_data %>%
    dplyr::filter(Financial.Year %in% fy) %>%
    dplyr::filter(Financial.Quarter %in% q) %>%
    dplyr::filter(Offence.Group %in% og) %>%
    dplyr::filter(Offence.Subgroup %in% osg) %>%
    dplyr::filter(Offence.Description %in% od) %>%
    group_by(Force.Name) %>%
    summarise(
      `Number of offences` = sum(Number.of.Offences, na.rm = TRUE)
    )
  
  pfa_prc_merge <- dplyr::left_join(x = pfa_sf, y = prc_data_filtered, by = c("PFA22NM" = "Force.Name"))
  
  suppressWarnings(
    {
      graph <- ggplot2::ggplot(data = pfa_prc_merge) +
        ggplot2::geom_sf(mapping = ggplot2::aes(fill = `Number of offences`, text = paste0("Police Force Area: ", PFA22NM, "\nNumber of offences: ", formatC(`Number of offences`, format="d", big.mark=",")))) +
        ggplot2::coord_sf(crs = "EPSG:27700") +
        ggplot2::theme_minimal() +
        viridis::scale_fill_viridis(labels = scales::label_comma()) + 
        ggplot2::theme(
          axis.line = ggplot2::element_blank(),
          axis.text = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_blank(),
          rect = ggplot2::element_blank()
        )
    }
  )
  graph <- plotly::ggplotly(graph, tooltip = c("text"))
  
  return(graph)
}
