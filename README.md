# HTFome

## About

_[HTFome](https://htfome.com/) is a publicly available web application that provides 
up-to-date information on Human Transcription Factors (HTFs), drugs which target HTFs, 
and allows users to upload gene expression data for further HTF analysis. Gene expresion data analyser is available at [geostuff.shinyapps.io](https://geostuff.shinyapps.io/HTFome-GEO-Analyser/?_ga=2.21754107.1771952832.1622901748-1004923329.1614783311)_

<hr>

HTFome was developed as part of the software group project for QMUL's Bioinformatics MSc 
by A.M. Andersen, K. Antoniuk, N. Hardie and A. Sutradhar. Documentation can be found in 
the [documentation directory](https://github.com/NHardie/HTFome/tree/main/documentation) 
(or all in one page in [documentation.pdf](https://github.com/NHardie/HTFome/blob/main/HTFome%20Launch%20Presentation.pdf)). 
The schematic below summarises the software architecture for HTFome.

![HTF-web-project-Updated Software Architecture](https://user-images.githubusercontent.com/60273209/109990466-52a64600-7d01-11eb-84f6-7a6354a68996.png)

## Website Development

### Installation

1. Clone the GitHub repository:

```shell
git clone --recursive https://github.com/NHardie/HTFome.git
```

2. Install all required packages and dependencies (NB: this should be performed in a virtual environment):

```shell
pip install -r requirements.txt

# Add to this file by installing required packages, then using:
pip freeze > requirements.txt
```

3. Run the Django web-application:
```shell
python manage.py runserver
```

`htf_web/settings.py` contains settings for the overall website. In line 27, DEBUG should 
be `False` in production, but `True` in development. If CSS does not show up during 
development, replacing lines 124-125 with the below code should resolve the issue:
```shell
# STATIC_ROOT = os.path.join(BASE_DIR, 'static')
STATIC_URL = '/static/'
STATICFILES_DIRS = [os.path.join(BASE_DIR, 'static')]
```

Creation of further applications, webpages, HTML templates (etc) follows normal Django 
development guidelines.

### Notes on Elastic Beanstalk

- `.ebextensions/` contains elastic beanstalk config files. Can set commands here to be run 
  upon deployment to AWS elastic beanstalk.
- `db.sqlite3` is the database file. This shouldn't be pushed to github, but instead 
  uploaded to AWS elastic beanstalk separately, or hosted on a separate database server.
- If website is moved from hosting on AWS, the `allowed_urls` in `settings.py` must 
  include the new hosting URL.
- The current app is called `data` (existing in the `data/` directory).
    - Usually the `static/` (.css/ .js) subdirectory is contained within the app (i.e. 
      data) directory, however, due to AWS Elastic Beanstalk being unable to locate 
      `static/` in this location, the subdirectory has been moved into the root directory 
      instead.
    - During development, `static/` can be placed back into the data directory, 
      and then placed in the root directory for production (although this is not 
      necessary).
      
## Database Development

HTF database files can be found in the `HTFs_data` branch.

Drug database files can be found in the `drug_data` branch.

## GEO Dashboard Development

The scripts for HTFome's GEO DataSet Analyser can be found in the `gds-r-dev` branch 
(which contains further information for developers). The Shiny Dashboard is currently 
available as an R application.

### Initial Setup

1. Download `app.R` (or copy/paste to your console) and run on your IDE of preference 
   (it works better in RStudio).
   
2. Upload your own GDS file of choice (datasets available for download on the 
  [GDSBrowser](https://www.ncbi.nlm.nih.gov/sites/GDSbrowser/)).
   
Note: to begin analysis, you may need to install BiocManager (which many of the
packages depend upon).

- To install BiocManager, refer to BiocManager's installation code (latest version 
  available [here](https://www.bioconductor.org/install/)):
    ```r
  if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
  BiocManager::install()
    ```
  
  - Then you can begin to install packages dependent on BiocManager like so:
    ```r
    BiocManager::install("GEOquery")
    BiocManager::install("limma")
    BiocManager::install("EnhancedVolcano")
    BiocManager::install("viper")
    BiocManager::install("dorothea")
    ```
## Feedback

If you have any comments, suggestions or issues, please let us know using our [GitHub
issues](https://github.com/NHardie/HTFome/issues).
