#shapefile download
#https://geoportal.statistics.gov.uk/datasets/ons::police-force-areas-december-2022-ew-bfc/explore?location=52.596555%2C-2.489483%2C6.00
# convert_prc_data_to_rds("Data visualisation/Assignment/Exercise 3/Data/prc-pfa-mar2013-onwards-tables-191023.ods")

convert_prc_data_to_rds <- function(file_name) {
  sheets_to_read_in <- readODS::list_ods_sheets(
    path = file_name
  )
  
  sheets_to_read_in <- base::unlist(
    x = stringr::str_extract_all(
      string = sheets_to_read_in,
      pattern = "^[:digit:]{4}-[:digit:]{2}$"
    )
  )
  
  prc_data <- purrr::map(
    .x = sheets_to_read_in,
    .f = \(x) readODS::read_ods(path = file_name, sheet = x)
  )
  
  prc_data_combined <- purrr::map_dfr(
    .x = prc_data,
    .f = dplyr::bind_rows
  )  
  
  #Matching up to shapefile and consistency
  prc_data_combined$Force.Name[prc_data_combined$Force.Name == "Devon and Cornwall"] <- "Devon & Cornwall"
  prc_data_combined$Force.Name[prc_data_combined$Force.Name == "Cifas"] <- "CIFAS"
  
  #Financial Fraud Action UK was integrated into UK Finance in Q2 2017/18. 
  #They are directly comparable before + after this date
  prc_data_combined$Force.Name[prc_data_combined$Force.Name == "Financial Fraud Action UK"] <- "UK Finance"
  
  base::saveRDS(
    object = prc_data_combined,
    file = "Data visualisation/Assignment/Exercise 3/Data/prc-default.RDS"
  )
  
  return(1)
}

load_prc_data <- function(file_name = "Data/prc-default.RDS") {
  return(base::readRDS(file_name))
}

load_pfa_shapefile <- function() {
  file_path <- "Data/Police_Force_Areas_December_2022_EW_BUC"
  pfa_boundaries <- sf::read_sf(dsn=file_path, layer="PFA_DEC_2022_EW_BUC_V2")
  return(pfa_boundaries)
}
