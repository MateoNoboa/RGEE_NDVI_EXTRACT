# Wildlife Spatial Tracking & Sentinel-2 NDVI Pipeline

This repository contains the R scripts used to extract Sentinel-2 NDVI values from wildlife GPS tracking locations and build a final database combining telemetry and satellite-derived vegetation information.

The workflow was developed using GPS data from three individuals: **Mashca, Diego and Sucre**.

The satellite data are acquired through **Google Earth Engine (GEE)** using Sentinel-2 Surface Reflectance imagery.

## Codes in R language

### 1) Sentinel-2 NDVI data acquisition from Google Earth Engine

`01_rgee-setup-and-ndvi-export.R`

This script configures the Python environment required by `rgee`, connects R with Google Earth Engine, and generates monthly NDVI composites from Sentinel-2 Surface Reflectance imagery.

The script:

* Configures the Python environment using `reticulate`.
* Authenticates Google Earth Engine.
* Filters Sentinel-2 imagery according to cloud cover.
* Calculates NDVI.
* Generates monthly median composites.
* Exports the resulting NDVI images as GeoTIFF files to Google Drive.

Before running this script, the Python environment can be created with:

```bash
conda create -n rgee_py python=3.9 -y
conda activate rgee_py
conda install -c conda-forge earthengine-api -y
pip install numpy
```

For the manual installation and configuration of `rgee`, I followed the tutorial:

> **RStudio + Google Earth Engine (GEE) with rgee: manual installation and configuration**

> YouTube: https://www.youtube.com/watch?v=1-k6wNL2hlo

The tutorial was particularly useful for configuring the Python/Conda environment required for `rgee` on Windows.

---

### 2) Spatial extraction of NDVI values

`02_spatial-ndvi-extraction.R`

This script reads the wildlife tracking coordinates and the Sentinel-2 NDVI GeoTIFF files generated in the previous step.

For each tracking location, the script extracts the NDVI value from the corresponding raster.

The main steps are:

1. Read the GPS tracking data.
2. Convert coordinates to spatial objects using `terra`.
3. Load the Sentinel-2 NDVI GeoTIFF files.
4. Match tracking points with the corresponding NDVI raster.
5. Extract the NDVI value at each GPS location.
6. Save the resulting tables for each individual.

The resulting files are:

```text
mashca_ndvi.csv
Diego_ndvi.csv
Sucre_ndvi.csv
```

---

### 3) Database consolidation and temporal matching

`03_database-consolidation-and-matching.R`

This script combines the NDVI extraction results from the three individuals and matches the tracking records with the corresponding satellite acquisition period.

The extracted data are transformed into a long format and then combined into a single database.

The final output is:

```text
Zorros_NDVI.csv
```

The resulting database contains the wildlife tracking information together with the Sentinel-2 NDVI values.

## Main packages

The workflow uses the following R packages:

* `rgee`
* `reticulate`
* `terra`
* `tidyverse`
* `lubridate`

## Data

The satellite imagery used in this workflow comes from **Sentinel-2 Surface Reflectance** through **Google Earth Engine**.

Sentinel-2 is part of the **Copernicus Programme**.

## References and credits

This workflow uses **Google Earth Engine (GEE)** and **Sentinel-2 Surface Reflectance** imagery from the **Copernicus Programme**.

The installation and configuration of `rgee` were carried out following the tutorial by **Ricardo Dal'Agnol da Silva**:

> Ricardo Dal'Agnol da Silva. *RStudio + Google Earth Engine (GEE) with rgee: manual installation and configuration.*
> YouTube: https://www.youtube.com/watch?v=1-k6wNL2hlo

The workflow also consulted the following repository:

> Ricardo Dal'Agnol da Silva. *DL_RS_GEE: Deep Learning with Remote Sensing imagery from Google Earth Engine with R language.*
> GitHub: https://github.com/ricds/DL_RS_GEE
