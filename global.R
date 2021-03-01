# Title     : Scripts for HTFome's GEO DataSet Analyser (shiny dashboard)
# Objective : Defines global R scripts

# Import libraries ----
library(BiocManager)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(GEOquery)
library(tidyverse)
library(dplyr)
library(limma)
library(gplots)
library(EnhancedVolcano)
library(shinycssloaders)
library(plotly)
library(RColorBrewer)

# Import libraries for HTF activity ----
library(viper)
library(dorothea)

# Set maximum file size limit to 100 MB ----
options(shiny.maxRequestSize = 100*1024^2)
