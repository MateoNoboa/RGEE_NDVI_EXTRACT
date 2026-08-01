# -------------------------------------------------------------
# Description:
# This script processes the NDVI datasets generated from the
# GPS locations of Mashca, Diego, and Sucre, matches NDVI
# values with the corresponding tracking month, and combines
# the results into a single dataset.
#
# Workflow:
# - Convert NDVI data from wide to long format
# - Match NDVI records with tracking dates
# - Process each individual dataset
# - Combine the results
# - Export the final database
#
# Notes:
# - Replace <username> with your local Windows user.
# -------------------------------------------------------------


# ---- processing function ----

# Convert NDVI data from wide to long format
# and keep only records matching the tracking month

process_ndvi <- function(
    path,
    date_pattern = "\\d{4}[.-]\\d{2}"
) {
  
  data <- read.csv(path)
  
  
  # ---- reshape to long format ----
  
  data_long <- data %>%
    tidyr::pivot_longer(
      cols = dplyr::starts_with("NDVI_"),
      names_to = "ndvi_date",
      values_to = "ndvi_value"
    ) %>%
    dplyr::mutate(
      ndvi_date = stringr::str_extract(
        ndvi_date,
        date_pattern
      )
    ) %>%
    dplyr::select(
      individual.local.identifier,
      timestamp,
      event.id,
      location.long,
      location.lat,
      ndvi_date,
      ndvi_value
    )
  
  
  # ---- filter by matching month ----
  
  data_filtered <- data_long %>%
    dplyr::mutate(
      timestamp_date = as.Date(timestamp),
      year_month_timestamp = format(
        timestamp_date,
        "%Y.%m"
      )
    ) %>%
    dplyr::filter(
      stringr::str_replace_all(
        ndvi_date,
        "-",
        "."
      ) == year_month_timestamp
    ) %>%
    dplyr::select(
      individual.local.identifier,
      timestamp,
      event.id,
      location.long,
      location.lat,
      ndvi_date,
      ndvi_value
    )
  
  return(data_filtered)
}


# ---- process individuals ----

diego_filtered <- process_ndvi(
  "C:/Users/<username>/OneDrive/Escritorio/Rgee/Diego_ndvi.csv"
)

sucre_filtered <- process_ndvi(
  "C:/Users/<username>/OneDrive/Escritorio/Rgee/Sucre_ndvi.csv"
)

mashca_filtered <- process_ndvi(
  "C:/Users/<username>/OneDrive/Escritorio/Rgee/mashca_ndvi.csv"
)


# ---- merge datasets ----

Zorros_NDVI <- dplyr::bind_rows(
  diego_filtered,
  sucre_filtered,
  mashca_filtered
)


# ---- inspect ----

str(Zorros_NDVI)


# ---- export ----

write.csv(
  Zorros_NDVI,
  "Zorros_NDVI.csv",
  row.names = FALSE
)