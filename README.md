README.md
# bioinfo-group-project (geo-r-dev)

### This branch contains all the R analysis code.

#### How to run on your local machine:
- Download `app.R` and run on your IDE of preference (preferably RStudio).
- Upload your own GDS file of choice, or you can download the included `data/GDS5093_full.soft.gz` or `data/GDS6063_full.soft.gz` files available in this repo.

#### Current issues + next steps:
- Anima: Define UI, parameters and information to present.
- Insert R scripts into Shiny (extra hands would be appreciated for this!).
- Need to run tests for each function, catch possible bugs.  
- Alex: Work on resolving issue with HTF activity package + insert into Shiny.
- Karol: Figure out how to deploy Shiny app as web-app online (including how to set up R environment with the required libraries installed).
- Anima: If time, wrap Shiny web-app around custom HTFome HTML/CSS/Bootstrap.

#### Resolved issues:
- Can now pass uploaded GDS file to analysis code (thank you, Millie!) - solution: had to pass a gds object (before I was passing the gds() reactive function). ALSO, gds object was not displaying properly, displaying within Table() fixed issue.
- GDS2eset function not working (unable to get URL). Millie suggestion: write an R script to extract GDS accession name from filepath, then pass to GDS2eset(). Solution: obtained eSet by manually extracting GDS accession from filename. This still doesn't resolve issue of passing actual uploaded file to GDS2eSet() - if time, I will debug.

### Useful resources:
- Nearly all the information you'll need to learn R Shiny is here: https://mastering-shiny.org/basic-app.html
- Download GEO DataSet (GDS) files here: https://www.ncbi.nlm.nih.gov/sites/GDSbrowser/
- GEOquery documentation here: https://www.bioconductor.org/packages/release/bioc/vignettes/GEOquery/inst/doc/GEOquery.html

### Additional info

#### Additional details on files:
- `app.R` contains both the global, ui and server code to build a shiny dashboard (this is the shiny application).
- Because app.R is a massive file, to make it easier I've split it into `ui.R` (contains UI script), `server.R` (contains server script) and `global.R` (defines global environment).
- `dengue-cw-script.R` contains code used in the dengue coursework, which we can re-use for this GEO-GDS analysis.

#### In addition, I've included two R files which show alternative ways of presenting our analysis to the user:
- `old_scripts/gds-plain-report.rmd` contains code that renders a simple HTML Markdown page (IF the Shiny dashboard fails/too difficult, we can use this as backup).
- `old_scripts/gds-shiny-report` contains a hybrid HTML R Markdown page with Shiny features integrated into it (DO NOT use this file, I have just put it here to show how it works).
