# Title     : Scripts for HTFome's GEO DataSet Analyser (shiny dashboard)
# Objective : Defines the UI


# Create GDS file object ----

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
        ),
        br(),
        actionButton("htfome_button", "Return to HTFome", icon("home"),
                     style = "color: #222D32",
                     onclick = "location.href='https://htfome.com/'")
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
                                            tabPanel("Data Summary", withSpinner(htmlOutput("data_summary"))),
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
                                   withSpinner(plotlyOutput("pheno_plot"))
                            )

                        ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close stats_tab item


            # Dashboard content for HCA tab ----
            tabItem(tabName = "hca_tab",

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
                                       c("No", "Yes"), inline = TRUE),
                          uiOutput("pDat_cols_hca")
                        ),

                        mainPanel(
                          withSpinner(plotOutput("heatmap"))
                        )

                      ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close hca_tab item


            # Dashboard content for PCA tab ----
            tabItem(tabName = "pca_tab",

                    fluidPage(

                      titlePanel("Principal Component Analysis"),

                      sidebarPanel(
                        numericInput("pc_num", "Number of Principal Components to retain:",
                                     value = 10, min = 10), # set min value to 10 as screeplot() only takes min 10 npcs
                        uiOutput("pDat_cols_pca")
                        # TODO: try get the scaling and centering options working
                        # radioButtons("pca_scale", "Apply scaling:",
                        #             c("TRUE", "FALSE"), inline = TRUE),
                        # radioButtons("pca_center", "Center:",
                        #             c("TRUE", "FALSE"), inline = TRUE)
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

                    ) # close fluidPage

                    ), # close pca_tab item


            # Dashboard content for DGE tab ----
            tabItem(tabName = "dge_tab",

                    fluidPage(

                      titlePanel("Differential Gene Expression Analysis")

                    ) # close fluidPage

                    ), # close dge_tab item


            # Dashboard content for HTF activity tab ----
            tabItem(tabName = "htf_activity_tab",

                    fluidPage(

                      titlePanel("Human Transcription Factor Activity"),

                      sidebarLayout(

                        sidebarPanel(
                          uiOutput("get_treatment_name"),
                          uiOutput("get_control_name"),
                          actionButton("htf_activity_button", "Estimate HTF activity"),
                          helpText("Click this button to begin analysis."),

                          p("Please be patient as this analysis take a few minutes to run! As a guide, a GDS file with ~10 samples takes around 5 minutes to compute, whereas a GDS file with 50 samples takes around 10 minutes."),
                          p("Human transcription factor (TF) activity will be analysed using the R packages: DoRothEA (a gene set resource containing signed TF-target interactions) and VIPER (which provides computational inference of protein activity)."),
                          p("Once the analysis is complete, a VIPER plot will appear, along with a summary table. The VIPER plot shows the projected expression levels of targets for the top ten differentially active TFs, where up-regulated (red) and down-regulated (blue) targets are displayed as vertical lines, resembling a barcode."),
                          p("The two-column heatmap on the right of the image shows the differential activity ('Act', in the first column) and differential expression ('Exp', in the second column) of the top ten regulators."),
                          p("The numbers on the right side represent the TF ranking according to their relative expression level in the ’test’ vs. ‘control’ conditions.")
                        ),

                        mainPanel(
                          tabsetPanel(
                            type = "tabs",
                            tabPanel("VIPER Plot", withSpinner(plotOutput("viper_plot"))),
                            tabPanel("VIPER Summary", withSpinner(dataTableOutput("viper_summary")))
                            # tabPanel("VIPER Tests", withSpinner(verbatimTextOutput("viper_test"))) # Uncomment for developer testing, a test tab will appear when app is run
                          )
                        )

                      ) # close sidebarPanel

                    ) # close fluidPage

            ) # close htf_activity tab

        ) # close tabItems

    ) # close dashboardBody

) # close UI
