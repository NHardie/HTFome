# Title     : Scripts for HTFome's GEO DataSet Analyser (shiny dashboard)
# Objective : Defines global R scripts

# Import libraries for Shiny ----
library(shiny)
library(shinydashboard)
library(shinycssloaders)

# Import libraries for GEOquery
library(BiocManager)
library(ggplot2)
library(GEOquery)
library(tidyverse)
library(dplyr)
library(limma)
library(gplots)
library(EnhancedVolcano)
library(plotly)
library(RColorBrewer)

# Import libraries for HTF activity ----
library(viper)
library(dorothea)

# Set maximum file size limit to 100 MB ----
options(shiny.maxRequestSize = 100*1024^2)

# Viper function ----

viper_analysis <- function(gds, eset, sampleType, treatment, control) {

  # Converting probe names to gene symbols
  X <- Table(gds)
  X <- avereps(X, ID=X$IDENTIFIER) # summarise probe values to a single expression value per gene
  eset <- eset[match(X[, "ID_REF"], rownames(eset)),] # update eset dimensions
  rownames(X) <- X[, "ID_REF"]
  featureNames(eset) <- X[, "IDENTIFIER"] # rename featureNames from probeids to gene symbols
  rownames(X) <- X[, "IDENTIFIER"]
  exp <- X[, -c(1:2)]
  class(exp) <- "numeric"
  exprs(eset) <- exp # write expression matrix back to eSet

  ### NEEDS TO GET USER INPUT ####
  # Get treatment factors
  factor_category <- sampleType
  treatment_name <- treatment
  control_name <- control

  # Convert DoRothEA network to regulon
  data(dorothea_hs, package = "dorothea")
  viper_regulons = df2regulon(dorothea_hs)

  # Perform t-test
  signature <- rowTtest(eset, factor_category, treatment_name, control_name)
  signature <- (qnorm(signature$p.value/2, lower.tail = FALSE) *
                + sign(signature$statistic))[, 1]

  # Create nullmodel based on 1000 iterations
  nullmodel <- ttestNull(eset, factor_category, treatment_name, control_name, per = 1000, repos = TRUE, verbose = FALSE)

  # msVIPER analysis
  mra <- msviper(signature, viper_regulons, nullmodel, verbose = FALSE)
  mra

}