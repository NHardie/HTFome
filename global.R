# Title     : Scripts for HTFome's GEO DataSet Analyser (shiny dashboard)
# Objective : Defines global R scripts

# Import libraries ----
library(shiny)
library(shinydashboard)
library(ggplot2)
library(GEOquery)
library(dplyr)
library(limma)
library(gplots)
library(EnhancedVolcano)
library(tidyverse)
library(shinycssloaders)
library(plotly)

# Set maximum file size limit to 100 MB ----
options(shiny.maxRequestSize = 100*1024^2)