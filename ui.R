# Title     : Scripts for HTFome's GEO DataSet Analyser (shiny dashboard)
# Objective : Defines the UI


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
                          sliderInput("gene_num", "Number of genes to display:", min = 50, max = 1000, value = 100),
                          # TODO: extract max gene number for each GDS (and substitute in max value)
                          selectInput("distance_method", "Distance Method:",
                                      c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")),
                          selectInput("linkage_method", "Linkage Algorithm:",
                                      c("complete", "ward.D", "ward.D2", "single", "average", "mcquitty", "median", "centroid")),
                          selectInput("scaling", "Apply Scaling:",
                                      c("none", "row", "column"))
                        ),

                        mainPanel(
                          withSpinner(plotOutput("heatmap"))
                        )

                      ) # close sidebarLayout

                    ) # close fluidPage

                    ), # close hca_tab item

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
