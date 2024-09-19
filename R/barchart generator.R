# prc_data <- readRDS("Data visualisation/Assignment/Exercise 3/Data/prc-default.RDS")
# pfa_sf <- sf::read_sf(dsn="Data visualisation/Assignment/Exercise 3/Data/Police_Force_Areas_December_2022_EW_BUC", layer="PFA_DEC_2022_EW_BUC_V2")
# fy  = c("2021/22")
# q   = c(1:4)
# og  = prc_data$Offence.Group
# osg = prc_data$Offence.Subgroup
# od  =prc_data$Offence.Description

barchart_generator <- function(prc_data, pfa_sf, fy, q, og, osg, od) {
  other_pfas <- base::setdiff(prc_data$Force.Name, pfa_sf$PFA22NM)
  
  prc_data_pfa_filter <- dplyr::filter(prc_data, Force.Name %in% other_pfas)
  
  include_0s <- tibble::tibble(Force.Name =other_pfas, `Number of offences` = base::rep(0, base::length(other_pfas)))
  
  prc_data_filtered <- prc_data_pfa_filter %>%
    dplyr::filter(Financial.Year %in% fy) %>%
    dplyr::filter(Financial.Quarter %in% q) %>%
    dplyr::filter(Offence.Group %in% og) %>%
    dplyr::filter(Offence.Subgroup %in% osg) %>%
    dplyr::filter(Offence.Description %in% od) %>%
    group_by(Force.Name) %>%
    summarise(
      `Number of offences` = sum(Number.of.Offences, na.rm = TRUE)
    )
  include_0s <- dplyr::filter(include_0s, !(Force.Name %in% prc_data_filtered$Force.Name))
  
  prc_data_filtered <- dplyr::bind_rows(prc_data_filtered, include_0s)
  
  graph <- ggplot2::ggplot(
    data = prc_data_filtered, 
    mapping = ggplot2::aes(y = `Number of offences`, x = Force.Name, fill = Force.Name)
  ) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::label_comma()) +
    ggplot2::geom_text(
      mapping = ggplot2::aes(label = formatC(`Number of offences`, format="d", big.mark=",")),
      position = ggplot2::position_dodge(width = 1),
      vjust = -0.5,
      size = 5
    ) +
    ggplot2::xlab("Force Name") +
    ggplot2::coord_cartesian(clip = "off") + 
    ggplot2::scale_x_discrete(guide = ggplot2::guide_axis(n.dodge = 2)) +
    viridis::scale_fill_viridis(discrete = TRUE, guide = "none") +
    my_theme()
  
  return(graph)
} 
