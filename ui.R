# Title     : GEO GDS Analysis scripts for shiny dashboard
# Objective : Defines the UI
# Created on: 23/02/2021


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
