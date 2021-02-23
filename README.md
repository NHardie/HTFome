README.md
# bioinfo-group-project (geo-r-dev)

### This branch contains all the R analysis code.

#### Use these files:
- `app.R` contains the code to build a shiny dashboard (this is the shiny application).
- `dengue-cw-script.R` contains code used in the dengue coursework, which we can re-use for this GEO-GDS analysis.

#### In addition, I've included two R files which show alternative ways of presenting our analysis to the user:
- `old_scripts/gds-plain-report.rmd` contains code that renders a simple HTML Markdown page (IF the Shiny dashboard fails/too difficult, we can use this as backup).
- `old_scripts/gds-shiny-report` contains a hybrid HTML R Markdown page with Shiny features integrated into it (DO NOT use this file, I have just put it here to show how it works).

#### Current issues:
- Cannot pass uploaded file to analysis code.
- Shiny dashboard might be too difficult - alternative is R flexdashboard (which is written in normal R).

### Useful resources:
- Nearly all the information you'll need to learn R Shiny is here: https://mastering-shiny.org/basic-app.html
- Download GEO DataSet (GDS) files here: https://www.ncbi.nlm.nih.gov/sites/GDSbrowser/
- GEOquery documentation here: https://www.bioconductor.org/packages/release/bioc/vignettes/GEOquery/inst/doc/GEOquery.html