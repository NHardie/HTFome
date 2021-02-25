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
library(tidyverse)


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
            menuItem("Data Summary",
                     tabName = "summary_tab"),
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
            
            tabItem(tabName = "summary_tab",
                    
                    # Dashboard content for data summary tab ----
                    
                    fluidPage(
                        
                        sidebarLayout(
                            
                            sidebarPanel(), # close sidebarPanel
                            
                            # Main panel for displaying outputs ----
                            mainPanel(
                                
                                # Output: Tabs
                                tabsetPanel(type = "tabs",
                                            tabPanel("GDS Summary", dataTableOutput("gds_summary")),
                                            tabPanel("eSet Summary", verbatimTextOutput("eset_summary")),
                                            tabPanel("Phenotype Summary", dataTableOutput("phenotype_summary"))
                                ),
                            )
                            
                        ) # close sidebarLayout
                        
                    ) # close fluidPage
                    
            ), # close summary_tab item
            
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
    
    # upload_tab reactive expressions ----
    
    # this reactive function takes user upload from the UI and passes it
    # to the read.delim() function, to read the data from the file.
    # input$file1$datapath -> is the data path contained in the value of
    # the input that uploads the data.
    data <- reactive({
        req(input$file1) # require input file to be available before showing the output
        #print(input$file1)
        #print(input$file1$datapath)
        read.delim(input$file1$datapath)
    })
    
    # upload_tab reactive outputs ----
    
    # Output interactive table of file summary
    output$table <- renderDataTable({
        data()
    })
    
    
    # summary_tab output ----
    
    # summary_tab reactive expressions ----
    
    # this reactive function takes the user-uploaded file from the UI, and
    # passes it to the GEOquery package. The file name gets passed as an
    # argument to the getGEO function, which converts the file to a gds
    # object/data structure (with class GDS).
    gds <- reactive({
        req(input$file1)
        getGEO(filename = input$file1$datapath)
    })
    
    
    # summary_tab reactive outputs ----
    
    # get output for "gds_summary" (outputId referenced in dashboard body UI)
    output$gds_summary <- renderDataTable({
        gds_df <- Table(gds()) # Must specify GDS object to display as table
        gds_df[,1:5] # display only first 5 columns (this fixes over-sized rows)
        # problems(gds()) # test command
        # spec(gds()) # test command
    })
    
    # Output ExpressionSet table
    
    # this reactive expression converts the GDS data structure to an
    # ExpressionSet object
    # eset <- reactive({
    #     gds_obj <- gds() # GDS2eSet only takes object as an argument
    #     eset <- GDS2eSet(gds_obj,do.log2 = TRUE)
    #     eset
    # })
    
    # alternative eset code that extracts GDS accession from file name
    # passes it through getGEO() and GDS2eSet() to return eSet object
    eset <- reactive({
        gds_file_name <- input$file1$name
        gds_acc <- str_extract(gds_file_name, "GDS[:digit:]+")
        gds <- getGEO(gds_acc)
        eset <- GDS2eSet(gds, do.log2 = TRUE)
        eset
    })
    
    
    # Output phenotypic summary (summary(pData)) table
    output$eset_summary <- renderPrint({
        eset()
    })
    
    
    # Output full phenotype (pData) table
    
    
    # hca_tab output ----
    
    
    
    # pca_tab output ----
    
    
    
    # dge_tab output ----
    
    
    
    # htf_activity_tab output ----
    
} # close server


# Run the application
shinyApp(ui = ui, server = server)
