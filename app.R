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
library(shinycssloaders)
library(plotly)
library(RColorBrewer)


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
            menuItem("Data Statistics",
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

    # Define UI for body of each tab item here
    dashboardBody(

        # Each tabItem is a tab page, referenced by calling its tab ID (defined in menuItem())
        tabItems(

            # Dashboard content for upload tab ----
            tabItem(tabName = "upload_tab",

                    # create a fluidPage for responsive content
                    fluidPage(

                        titlePanel("Upload GDS file"),

                        # Sidebar layout with input and output definitions
                        sidebarLayout(

                            #  Sidebar panel for inputs
                            sidebarPanel(

                                # Input: Select a file
                                fileInput(
                                    inputId = "file1",
                                    label = "Upload GEO DataSet (GDS format)",
                                    accept = c("text/tsv",
                                               "text/tab-separated-values,text/plain",
                                               ".tsv"),
                                    multiple = FALSE
                                ),

                                # Add help text
                                helpText("Default max. file size is 100 MB."),

                                p("Upload gene expression data extracted from the GEO database ",
                                  "(data must be in GDS format)."),
                                p("Once uploaded, a data preview will become available where ",
                                  "you will be able to view summary information of the file."),
                                p("The file will then be parsed by the GEOquery package to ",
                                  "return a GEOquery data structure (of class GDS), which will ",
                                  "then be converted into an ExpressionSet. Previews for the ",
                                  "GDS class and ExpressionSet will also be available."),

                            ),

                            # Main panel for displaying outputs
                            mainPanel(

                                tabsetPanel(type = "tabs",
                                            tabPanel("Data Summary", withSpinner(dataTableOutput("data_summary"))),
                                            tabPanel("GDS Preview", withSpinner(dataTableOutput("gds_preview"))),
                                            tabPanel("Phenotype Data Preview", withSpinner(dataTableOutput("pDat_preview")))
                                            )

                            )

                        ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close upload_tab item


            # Dashboard content for stats tab ----
            tabItem(tabName = "stats_tab",

                    fluidPage(

                        titlePanel("Data Statistics"),
                        h4("See basic statistics for this GDS sample."),

                        fluidRow(

                            #sidebarPanel(),

                            column(6,
                                   withSpinner(plotlyOutput("pheno_plot")))

                            #mainPanel(

                               # tabsetPanel(type = "tabs",
                                #            tabPanel("Phenotype Plot", plotlyOutput("pheno_plot")),
                                #            tabPanel("Sample Boxplot", verbatimTextOutput("eset_summary")),
                                #            tabPanel("Phenotype Summary", dataTableOutput("phenotype_summary"))
                                #            )
                             #   )

                        ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close stats_tab item

            tabItem(tabName = "hca_tab",

                    # Dashboard content for HCA tab ----
                    fluidPage(

                      titlePanel("Hierarchical Clustering Analysis"),

                      sidebarLayout(

                        sidebarPanel(
                          sliderInput("gene_num", "Number of genes to display:",
                                      min = 50, max = 5000, value = 100),
                          # TODO: extract max gene number for each GDS (and substitute in max value)
                          selectInput("distance_method", "Distance Method:",
                                      c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")),
                          selectInput("linkage_method", "Linkage Algorithm:",
                                      c("complete", "ward.D", "ward.D2", "single", "average", "mcquitty", "median", "centroid")),
                          selectInput("scale", "Apply Scaling:",
                                      c("none", "row", "column")),
                          radioButtons("display_genes", "Display Gene Names:",
                                       c("No", "Yes"), inline = TRUE),
                          radioButtons("display_samples", "Display Sample Names:",
                                       c("No", "Yes"), inline = TRUE)
                        ),

                        mainPanel(
                          withSpinner(plotOutput("heatmap"))
                        )

                      ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close hca_tab item

            tabItem(tabName = "pca_tab",

                    # Dashboard content for PCA tab ----

                    fluidPage(

                      titlePanel("Principal Component Analysis"),

                      sidebarPanel(
                        numericInput("pc_num", "Number of Principal Components to retain:",
                                     value = 10, min = 10), # set min value to 10 as screeplot() only takes min 10 npcs
                        radioButtons("pca_scale", "Apply scaling:",
                                    c("TRUE", "FALSE"), inline = TRUE),
                        radioButtons("pca_center", "Center:",
                                    c("TRUE", "FALSE"), inline = TRUE)
                      ),

                      mainPanel(
                        tabsetPanel(
                          type = "tabs",
                          # TODO: options not currently in use - may need to remove OR debug
                          tabPanel("PCA Data", withSpinner(verbatimTextOutput("pca_data"))),
                          tabPanel("Screeplot",
                                   withSpinner(plotOutput("screeplot")),
                                   br(),
                                   withSpinner(plotOutput("cum_var_plot"))),
                          tabPanel("PCA Plot", withSpinner(plotOutput("pca_plot")))
                        )
                      )

                    )

                    ),
            tabItem(tabName = "dge_tab",

                    # Dashboard content for DGE tab ----

                    fluidPage(

                      titlePanel("Differential Gene Expression Analysis")

                    )

                    ),
            tabItem(tabName = "htf_activity_tab",

                    # Dashboard content for HTF activity tab ----

                    fluidPage(

                      titlePanel("Human Transcription Factor Activity"),

                    )

                    )
        ) # close tabItems

    ) # close dashboardBody

) # close UI


# Define server logic
server <- function(input, output) {

    # ---- upload_tab item ----

    # upload_tab reactive expressions ----

    # File upload validation
    validate_upload <- reactive({
        validate(
          need(input$file1, "Unable to display information, please upload a GDS file.")
          # TODO: Add test to verify GDS format
          # TODO: Add test to check for empty file
        )
    })

    # Pass user-upload file to GEOquery for parsing.
    # Output is gds data structure (with class GDS).
    gds <- reactive({
        req(input$file1)
        gds_file_name <- input$file1$name

        # If user uploads full SOFT GDS file format
        # GEOquery cannot currently parse full SOFT GDS files into eSet.
        # Workaround solution: extract GDS accession from filename and
        # pass to getGEO() to retrieve online instead.
        if (str_detect(gds_file_name, "_full")) {
            gds_acc <- reactive({
                str_extract(gds_file_name, "GDS[:digit:]+")
            })

            getGEO(gds_acc())
        }

        # If user uplaods SOFT GDS file format
        else {
            getGEO(filename = input$file1$datapath)
        }
    })

    # Convert gds object to data frame
    gds_df <- reactive({
        Table(gds())
    })

    # Convert GDS data structure to ExpressionSet
    eset <- reactive({
        GDS2eSet(gds(), do.log2 = TRUE)
    })

    # Extract phenotype data from eSet object
    pDat <- reactive({
        pData(eset())
    })

    # extract file summary information from gds, eset and pDat objects
    # TODO: Add scripts to extract file summary information here


    # upload_tab reactive outputs ----

    # display file summary information for "data_summary" tab
    output$data_summary <- renderDataTable({
        validate_upload()
        # TODO: Add scripts to display file summary information here
    })

    # display preview of gds data in "gds_preview" tab
    output$gds_preview <- renderDataTable({
        validate_upload()
        gds_df()[,1:5] # displaying first 5 columns fixes over-sized rows
    })

    # display phenotype data in "pDat_preview" tab
    output$pDat_preview <- renderDataTable({
        validate_upload()
        pDat()
    })


    # ---- stats_tab item ----

    # stats_tab reactive expressions ----


    # stats_tab reactive outputs ----

    # Display phenotype plot
    # TODO: variable type column varies by sample. Remove this plot?
    output$pheno_plot <- renderPlotly({
        validate_upload()
        #plot(pDat()[,3])
        pDatPlot <- ggplot(pDat(), aes(x=pDat()[,2])) +
          geom_bar(color="black", position=position_dodge()) +
          theme_minimal()
        ggplotly(pDatPlot)
    })


    # ---- hca_tab item ----

    # hca_tab reactive expressions ----

    # Combine gene names from gds and expression data from eSet, then
    # remove any duplicated genes by taking the average expression of
    # probes corresponding to same gene.
    # Output is a matrix containing averaged gene expression data.
    gene_exp <- reactive({
        geneNames <- as.character(gds_df()$IDENTIFIER)
        gene_eset <- exprs(eset()) # class: matrix, dim: 54715 56 -> expected, correct
        rownames(gene_eset) <- geneNames # class: matrix, dim: 54715 56 -> expected, correct
        avereps(gene_eset, ID = rownames(gene_eset)) # class: matrix, dim: 31654 56 -> expected, correct
    })

    # Calculate standard deviation of genes across all samples and sort
    # rows by highest SD. Output is a data frame containing genes and
    # their expression data, sorted by SD.
    sort_gene_SD <- reactive({
        # Shiny doesn't seem to like data passed to apply() in matrix
        # form, so we need to convert it to a data frame first.
        #gene_exp_df <- data.frame(matrix(gene_exp())) # class: df, dim: 31654 56 -> expected, incorrect: df, 1772624 1
        gene_exp_df <- as.data.frame(gene_exp()) # class: df, dim: 31654 56 -> expected, correct
        gene_SD <- transform(gene_exp_df, SD = apply(gene_exp_df, 1, sd, na.rm = TRUE)) # class: df, dim: 31654 57 -> expected, correct
        gene_SD[with(gene_SD, order(-SD)),] # class: df, dim: 31654 57 -> expected, correct
    })

    # Extract user-defined genes with highest SD and convert to numeric matrix
    top_genes_mat <- reactive({
        top_num_genes <- head(sort_gene_SD(), input$gene_num) # class: df, dim: 100 57 -> expected, correct
        top_num_genes <- top_num_genes[1:(length(top_num_genes)-1)] # remove SD column # class: df, dim: 100 56 -> expected, correct
        as.matrix(top_num_genes) # class: matrix, dim: 100 56 -> expected, correct!
    })

    # Plot heatmap (using heatmap.2)
    heatmap <- reactive({
        # print(nrow(top_genes_mat())) # test to check user gene_num input works
        # print(class(top_genes_mat())) # test to check data is right class
        # print(dim(top_genes_mat())) # test to check data is right dim
        top_genes_mat <- as.matrix(top_genes_mat())
        samples <- paste("Samples (n=",ncol(top_genes_mat),")", sep = "")
        genes <- paste("Genes (n=",nrow(top_genes_mat),")", sep = "")
        #title <- paste(Meta(gds())$title, sep = "")
        heatmap.2(top_genes_mat,
          # TODO: Colour samples by sample type.
          distfun = function(x) dist(x, method = input$distance_method),
          hclustfun = function(x) hclust(x, method = input$linkage_method),
          scale = input$scale,
          trace = "none",
          #main = title,
          xlab = samples,
          ylab = genes,
          key.title = "SD from mean",
          key.xlab = NA,
          key.ylab = NA,
          lhei = c(1,6),
          lwid = c(1,3.5),
          keysize = 0.35,
          key.par = list(cex = 0.5),
          labRow = if (input$display_genes == "No") {FALSE} else rownames(top_genes_mat),
          labCol = if (input$display_samples == "No") {FALSE} else colnames(top_genes_mat),
          margins = if (input$display_genes == "No" && input$display_samples == "No") {c(2,2)}
                        else if (input$display_genes == "Yes" && input$display_samples == "No") {c(2,7)}
                        else if (input$display_genes == "No" && input$display_samples == "Yes") {c(9,2)}
                        else c(9,7), # shifts x-/y-axis labels depending whether user chooses to show sample/gene labels
          col = greenred(75)
        )
    })

    # hca_tab reactive outputs ----
    output$heatmap <- renderPlot({
        validate_upload()
        heatmap()
    })

    # ---- pca_tab item ----

    # pca_tab reactive expressions ----

    # Perform PCA: get averaged gene expression data, transform it and
    # remove any columns containing zeros and NAs first
    pca <- reactive({
        gene_exp_mat <- gene_exp() # class matrix expected, correct
        tX <- t(gene_exp_mat)
        Xpca <- tX[, colSums(tX != 0, na.rm = TRUE) > 0]
        Xpca <- prcomp(Xpca, center = TRUE, scale. = TRUE) # class prcomp expected, correct!
        Xpca
    })

    # Get summary of PCA results
    pca_summary <- reactive({
        summary(pca())
    })

    # Screeplot
    scree_plot <- reactive({
        screeplot_title <- paste("Screeplot of the first ",input$pc_num," PCs", sep = "")
        summ <- pca_summary()
        exp_var <- summ$importance[2,] * 100
        plot(exp_var[1:input$pc_num],
             type = "b",
             xlab = "PCs",
             ylab = "Variance",
             main = screeplot_title
        )
        abline(h = 1, col = "red", lty = 5)
        legend("topright", legend = c("Eigenvalue = 1"),
               col = c("red"), lty = 5, cex = 0.9)
    })

    # Plot cumulative variance
    cum_var <- reactive({
        summ <- pca_summary()
        cum_var <- summ$importance[3,] * 100
        plot(cum_var[1:input$pc_num],
             type = "b",
             xlab = "PCs",
             ylab = "Cumulative explained variance",
             main = "Cumulative variance plot"
        )
    })

    # Set colours by sample type


    # Plot PCA scores
    pca_scores <- reactive({
        scores <- pca()$x # class matrix expected, correct!
        plot(scores[,1],
             scores[,2],
             xlab = "PC1",
             ylab = "PC2",
             pch = 19,
             main = "PCA scores (per sample)",
             col =
        )
    })


    # pca_tab reactive outputs ----

    output$pca_data <- renderPrint({
        validate_upload()
        pca_summary()
    })

    output$screeplot <- renderPlot({
        validate_upload()
        scree_plot()
    })

    output$cum_var_plot <- renderPlot({
        validate_upload()
        cum_var()
    })


    output$pca_plot <- renderPlot({
        validate_upload()
        pca_scores()
    })

    # ---- dge_tab item ----

    # dge_tab reactive expressions ----

    # dge_tab reactive outputs ----


    # ---- htf_activity_tab item ----

    # htf_activity_tab reactive expressions ----

    # htf_activity_tab reactive outputs ----


} # close server


# Run the application
shinyApp(ui = ui, server = server)
