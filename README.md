README.md
# HTFome GEO DataSet Analyser

### This branch contains all the R scripts for HTFome's GEO DataSet analyser (Shiny Dashboard app).

#### How to run on your local machine:
- Download `app.R` (or copy/paste to your console) and run on your IDE of preference (it works better in RStudio).
- Upload your own GDS file of choice (available on the 
  [GDSBrowser](https://www.ncbi.nlm.nih.gov/sites/GDSbrowser/)).
- Note: to begin analysis, you may need to install BiocManager (which many of the
  packages depend upon).
    - To install BiocManager, refer to BiocManager's installation code (latest version 
      available [here](https://www.bioconductor.org/install/)):
    ```r
  if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
  BiocManager::install()
    ```
  - Then you can begin to install packages dependent on BiocManager like so: e.g. GEOquery:
    ```r
    BiocManager::install("GEOquery")
    ```
    e.g. LIMMA:
    ```r
    BiocManager::install("limma")
    ```
    e.g. EnhancedVolcano:
    ```r
    BiocManager::install("EnhancedVolcano")
    ```

#### Current issues:
- Deploy Shiny app as web-app online (update/solution: system dependencies have to be 
  installed on shinyapps.io's servers, so a request to install dependencies has been made, 
  see issue [here](https://github.com/rstudio/shinyapps-package-dependencies/issues/276)).

#### Resolved issues:
- Can now pass uploaded GDS file to analysis code (thank you, Millie!) - solution: had 
  to reference input file datapath, also removed `GSEMatrix` argument as file is GDS. 
  Then needed to wrap gds inside Table() function to display properly.
- `GDS2eSet()` function not working for `GDSxxxx_full.soft.gz` files (unable to get GPL URL). 
  This is actually a bug on GEOquery's side, as `_full.soft.gz` files seem to have an 
  extra GPL line which is unable to be parsed by GDS2eset(). Quick workaround solution 
  is to extract the GDS accession number for `_full.soft.gz` files and pass that
  to `getGEO()` and then `GDS2eSet()`.
- Issues with HTF activity package resolved, now integrated into app.
    
### Useful resources for developers:
- Nearly all the information you'll need to learn R Shiny is here: https://mastering-shiny.org/basic-app.html
- Download GEO DataSet (GDS) files here: https://www.ncbi.nlm.nih.gov/sites/GDSbrowser/
- GEOquery documentation here: https://www.bioconductor.org/packages/release/bioc/vignettes/GEOquery/inst/doc/GEOquery.html

### Additional info

#### Additional details on files:
- `app.R` contains both the global, ui and server code to build a shiny dashboard (this is the shiny application).
- Because app.R is a massive file, to make it easier I've split it into `ui.R` (contains UI script), `server.R` (contains server script) and `global.R` (defines global environment).
- The `/original_R-scripts` folder contains the normal base R code to run the analysis (i.e. no use of Shiny reactives). You can run the scripts to reproduce HTFome's GDS analysis yourself.

#### In addition, I've included two R files which show alternative ways of presenting our analysis to the user:
- `old_scripts/gds-plain-report.rmd` contains code that renders a simple HTML Markdown page (future development could include users downloading the analysis into an RMarkdown report).
- `old_scripts/gds-shiny-report` contains a hybrid HTML R Markdown page with Shiny features integrated into it (future development could include users downloading the analysis as an interactive report).
