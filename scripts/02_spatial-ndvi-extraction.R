# -------------------------------------------------------------
# Description:
# This script extracts NDVI values from Sentinel-2 GeoTIFF files
# for multiple GPS point datasets (Mashca, Diego, and Sucre).
#
# Workflow:
# - Load GPS coordinates
# - Read NDVI raster files (.tif)
# - Extract NDVI values for each GPS location
# - Append results as NDVI_YYYY-MM columns
# - Export the resulting datasets
#
# Notes:
# - Replace <username> with your local Windows user.
# -------------------------------------------------------------


# ---- packages ----

library(readr)
library(dplyr)
library(terra)


# ---- Mashca ----

# Load GPS data and convert to spatial format

mashca_points <- read.csv(
  "C:/Users/<username>/Rgee/mashca_points.csv"
)

points_vect <- vect(
  mashca_points,
  geom = c("location.long", "location.lat"),
  crs = "EPSG:4326"
)


# Load NDVI raster files

ndvi_files <- list.files(
  "C:/Users/<username>/Rgee/NDVI_Mashca",
  pattern = "\\.tif$",
  full.names = TRUE
)


# Extract NDVI values for each raster

for (f in ndvi_files) {
  
  r <- rast(f)
  
  # Extract date from filename
  
  ndvi_date <- gsub(
    "NDVI_|\\.tif.*",
    "",
    basename(f)
  )
  
  # Extract NDVI values at point locations
  
  ndvi_values <- terra::extract(
    r,
    points_vect
  )[, 2]
  
  # Append values to dataset
  
  mashca_points[[paste0(
    "NDVI_",
    ndvi_date
  )]] <- ndvi_values
}


# Export enriched dataset

write.csv(
  mashca_points,
  "C:/Users/<username>/Rgee/mashca_ndvi.csv",
  row.names = FALSE
)

mashca_ndvi <- read.csv(
  "C:/Users/<username>/Rgee/mashca_ndvi.csv"
)


# ---- Diego ----

# Load GPS data and convert to spatial format

diego_points <- read.csv(
  "C:/Users/<username>/Rgee/diego_points.csv"
)

points_vect <- vect(
  diego_points,
  geom = c("location.long", "location.lat"),
  crs = "EPSG:4326"
)


# Load NDVI raster files

ndvi_files <- list.files(
  "C:/Users/<username>/Rgee/NDVI_Diego",
  pattern = "\\.tif$",
  full.names = TRUE
)


# Extract NDVI values for each raster

for (f in ndvi_files) {
  
  r <- rast(f)
  
  # Ensure CRS compatibility
  
  if (crs(r) != crs(points_vect)) {
    points_proj <- project(
      points_vect,
      crs(r)
    )
  } else {
    points_proj <- points_vect
  }
  
  # Extract date from filename
  
  ndvi_date <- gsub(
    "NDVI_|\\.tif.*",
    "",
    basename(f)
  )
  
  # Extract NDVI values at point locations
  
  ndvi_values <- terra::extract(
    r,
    points_proj
  )[, 2]
  
  # Append values to dataset
  
  diego_points[[paste0(
    "NDVI_",
    ndvi_date
  )]] <- ndvi_values
}


# Export enriched dataset

write.csv(
  diego_points,
  "C:/Users/<username>/Rgee/Diego_ndvi.csv",
  row.names = FALSE
)

diego_ndvi <- read.csv(
  "C:/Users/<username>/Rgee/Diego_ndvi.csv"
)


# ---- Sucre ----

# Load GPS data and convert to spatial format

sucre_points <- read.csv(
  "C:/Users/<username>/Rgee/sucre_points.csv"
)

points_vect <- vect(
  sucre_points,
  geom = c("location.long", "location.lat"),
  crs = "EPSG:4326"
)


# Load NDVI raster files

ndvi_files <- list.files(
  "C:/Users/<username>/Rgee/NDVI_Sucre",
  pattern = "\\.tif$",
  full.names = TRUE
)


# Extract NDVI values for each raster

for (f in ndvi_files) {
  
  r <- rast(f)
  
  # Ensure CRS compatibility
  
  if (crs(r) != crs(points_vect)) {
    points_proj <- project(
      points_vect,
      crs(r)
    )
  } else {
    points_proj <- points_vect
  }
  
  # Extract date from filename
  
  ndvi_date <- gsub(
    "NDVI_|\\.tif.*",
    "",
    basename(f)
  )
  
  # Extract NDVI values at point locations
  
  ndvi_values <- terra::extract(
    r,
    points_proj
  )[, 2]
  
  # Append values to dataset
  
  sucre_points[[paste0(
    "NDVI_",
    ndvi_date
  )]] <- ndvi_values
}


# Export enriched dataset

write.csv(
  sucre_points,
  "C:/Users/<username>/Rgee/Sucre_ndvi.csv",
  row.names = FALSE
)

sucre_ndvi <- read.csv(
  "C:/Users/<username>/Rgee/Sucre_ndvi.csv"
)