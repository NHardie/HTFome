README.md
# bioinfo-group-project (geo-r-dev)

### This branch contains all the R analysis code.

#### Use these files:
- `app.R` contains the code to build a shiny dashboard (USE THIS FILE).
- `dengue-cw-script.R` contains code used in the dengue coursework, which we can re-use for this GEO-GDS analysis.

#### In addition, I've included two R files which show alternative ways of presenting our analysis to the user:
- `gds-plain-report.rmd` contains code that renders a simple HTML Markdown page (IF the Shiny dashboard fails/too difficult, we can use this as backup).
- `gds-shiny-report` contains a hybrid HTML R Markdown page with Shiny features integrated into it (DO NOT use this file, I have just put it here to show how it works).

#### Current issues:
- Cannot pass uploaded file to analysis code.
- Shiny dashboard might be too difficult - alternative is R flexdashboard (which is written in normal R).

### Useful resources:
- To learn R Shiny - nearly all the information you'll need is here: https://mastering-shiny.org/basic-app.html
