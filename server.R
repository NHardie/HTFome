# Title     : Scripts for HTFome's GEO DataSet Analyser (shiny dashboard)
# Objective : Defines the server function

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

        # GEOquery cannot currently parse full SOFT GDS files into eSet.
        # Workaround solution: extract GDS accession from filename and
        # pass to getGEO() to retrieve online instead.
        if (str_detect(gds_file_name, "_full")) {
            gds_acc <- reactive({
                str_extract(gds_file_name, "GDS[:digit:]+")
            })

            getGEO(gds_acc())
        }

        else {
            getGEO(filename = input$file1$datapath)
        }
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
        gds_df <- Table(gds())
        gds_df[,1:5] # displaying first 5 columns fixes over-sized rows
    })

    # display phenotype data in "pDat_preview" tab
    output$pDat_preview <- renderDataTable({
        validate_upload()
        pDat()
    })


    # ---- stats_tab item ----

    # data cleaning
    geneNames <- reactive({
        as.character()
    })


    # ---- hca_tab item ----


    # ---- pca_tab item ----


    # ---- dge_tab item ----


    # ---- htf_activity_tab item ----


} # close server
