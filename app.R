# Title     : Script for shiny dashboard - GEO GDS Analysis
# Objective : GEO GDS Analysis
# Created on: 22/02/2021


# Import libraries ----
library(shiny)
library(shinydashboard)
library(ggplot2)
library(GEOquery)
library(dplyr)
library(limma)
library(gplots)
library(EnhancedVolcano)


# Create GDS file object ----

# Set maximum file size limit to 100 MB ----
options(shiny.maxRequestSize = 100*1024^2)

# Define UI for dashboard ----
ui <- dashboardPage(

    # Set dashboard title ----
    dashboardHeader(title = "HTFome Dashboard"),

    # create dashboard sidebar menu ----
    dashboardSidebar(
        sidebarMenu(
            # Set tab title, and tab ID
            menuItem("Upload GDS File",
                     tabName = "upload_tab"),
            menuItem("Summary Statistics",
                     tabName = "stats_tab"),
            menuItem("Hierarchical Clustering Analysis",
                     tabName = "hca_tab"),
            menuItem("Principal Component Analysis",
                     tabName = "pca_tab"),
            menuItem("Differential Gene Expression",
                     tabName = "dge_tab"),
            menuItem("Estimate of HTF Activity",
                     tabName = "htf_activity_tab")
        )
    ),

    # Create items in dashboard body ----
    dashboardBody(

        tabItems(
            # Each tabItem is a tab page and its contents
            # all plots will go into each tabItem
            tabItem(tabName = "upload_tab",

                    # Dashboard content for upload tab ----

                    # Define UI for data upload app
                    fluidPage(

                        # Sidebar layout with input and output definitions
                        sidebarLayout(

                            #  Sidebar panel for inputs
                            sidebarPanel(

                                # Input: Select a file
                                fileInput(
                                    inputId = "file1",
                                    label = "Upload GEO DataSet. Choose TSV file",
                                    accept = c("text/tsv",
                                               "text/tab-separated-values,text/plain",
                                               ".tsv"),
                                    multiple = FALSE
                                ),

                                # Add help text
                                helpText("Must be GDS format. Default max. file size is 100 MB."),

                            ),

                            # Main panel for displaying outputs
                            mainPanel(
                                dataTableOutput(outputId = "table")
                            )
                        ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close upload_tab item

            tabItem(tabName = "stats_tab",

                    # Dashboard content for summary statistics tab ----

                    fluidPage(

                        sidebarLayout(

                            sidebarPanel(

                            ), # close sidebarPanel

                            mainPanel(
                                dataTableOutput(outputId = "summary")
                                )

                        ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close stats_tab item

            tabItem(tabName = "hca_tab",

                    # Dashboard content for HCA tab ----

                    ),
            tabItem(tabName = "pca_tab,

                    # Dashboard content for PCA tab ----

                    "),
            tabItem(tabName = "dge_tab,

                    # Dashboard content for DGE tab ----

                    "),
            tabItem(tabName = "htf_activity_tab,

                    # Dashboard content for HTF activity tab ----

                    ")
        ) # close tabItems

    ) # close dashboardBody

) # close UI

# Define server logic
server <- function(input, output) {

    # upload_tab output ----
    data <- reactive({
        req(input$file1) # require input files to be available
        gds_file <- read.csv(input$file1$datapath)
        gds_file
    })
    # Output interactive table of file summary
    output$table <- renderDataTable({
        data()
        })

    # add observe event
    observe ({

        req(input$file1)
        gds_file <- read.csv(input$file1$datapath)

    })

    # stats_tab output ----

    gds_stats <- reactive({

        gds_file <- read.csv(input$file1$datapath)
        req(data(input$file1))

        gds <- getGEO(filename=gds_file, GSEMatrix = TRUE)
        #gds <- getGEO(filename = input$file1$datapath, GSEMatrix = TRUE)
        eset <- GDS2eSet(gds, do.log2 = TRUE)
        pDat <- pData(eset)
        pDat

    })

    # Output summary table of GDS file
    output$summary <- renderDataTable({
        gds_stats()
    })

    # hca_tab output ----



    # pca_tab output ----



    # dge_tab output ----



    # htf_activity_tab output ----

}

# Run the application
shinyApp(ui = ui, server = server)

