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

# Define the UI for the dashboard ----
ui <- dashboardPage(

    # Set dashboard title ----
    dashboardHeader(title = "HTFome Dashboard"),

    # create dashboard sidebar menu ----
    dashboardSidebar(
        sidebarMenu(
            # Set menu item title, and tab ID
            # Each of these will be its own tab in the sidebar menu
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
    # We can define what UI we want in the body of each tab item here
    dashboardBody(

        tabItems(
            # Each tabItem is a tab page, referenced by calling its tab ID
            # (defined in the menuItem() above)
            tabItem(tabName = "upload_tab",

                    # Dashboard content for upload tab ----

                    # Define UI for data upload app
                    # creates a fluidPage for responsive content
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
                            # We define what the UI should display in its main panel.
                            # Here, UI should display a dataTableOutput, with ID
                            # "table", which will get called in the server function
                            # below.
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

    # reactive expressions ----

    # this reactive function takes user upload from the UI and passes it
    # to the read.delim() function, to read the data from the file.
    # input$file1$datapath -> is the data path contained in the value of
    # the input that uploads the data.
    data <- reactive({
        req(input$file1) # require input file to be available before showing the output
        read.delim(input$file1$datapath)
    })

    # reactive outputs ----

    # Output interactive table of file summary
    output$table <- renderDataTable({
        data()
        })


    # stats_tab output ----

    # reactive expressions ----

    # this reactive function takes the user-uploaded file from the UI, and
    # passes it to the GEOquery package. The file name gets passed as an
    # argument to the getGEO function, which converts the file to a gds
    # object/data structure (with class GDS).
    gds <- reactive({
        req(data())
        getGEO(data(), GSEMatrix = TRUE)
        # getGEO(filename = input$file1$datapath, GSEMatrix = TRUE)
    })



    # this reactive function takes the gds object and passes it as an
    # argument to GEOquery's GDS2eSet() function, which converts the GDS
    # file object to an ExpressionSet object.


    # reactive outputs ----

    # Output table of GDS file for the "summary" outputId (referenced in
    # the dashboard body UI for the stats_tab)
    output$summary <- renderDataTable({
        gds()
    })


    # # Checking data are uploaded before plotting etc
    # output$map <- renderLeaflet({
    #     if (is.null(data()) | is.null(map())) {
    #         return(NULL)
    #     }
    #     ...
    # })

    # Output ExpressionSet table


    # Output phenotypic summary (summary(pData)) table


    # Output full phenotype (pData) table


    # hca_tab output ----



    # pca_tab output ----



    # dge_tab output ----



    # htf_activity_tab output ----

} # close server

# Run the application
shinyApp(ui = ui, server = server)
