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
            
            tabItem(tabName = "upload_tab",

                    # Dashboard content for upload tab ----

                    # create a fluidPage for responsive content
                    fluidPage(

                        # Sidebar layout with input and output definitions
                        sidebarLayout(

                            #  Sidebar panel for inputs
                            sidebarPanel(

                                # set title
                                h2("Upload GDS file"),

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

            tabItem(tabName = "stats_tab",

                    # Dashboard content for stats tab ----

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
