# Title     : GEO GDS Analysis scripts for shiny dashboard
# Objective : Defines the server function
# Created on: 23/02/2021

# Define server logic
server <- function(input, output) {

    # ---- upload_tab item ----

    # upload_tab reactive expressions ----

    # Pass user-upload file to GEOquery for parsing.
    # Output is gds data structure (with class GDS).
    gds <- reactive({
        req(input$file1)
        getGEO(filename = input$file1$datapath)
    })

    # TODO: unable to pass gds() reactive to GDS2eSet() function - debug
    # Current solution: extract GDS accession from filename and pass
    # to getGEO(), then convert new gds object to an ExpressionSet object
    gds_acc <- reactive({
        gds_file_name <- input$file1$name
        str_extract(gds_file_name, "GDS[:digit:]+")
    })

    eset <- reactive({
        new_gds <- getGEO(gds_acc())
        GDS2eSet(new_gds, do.log2 = TRUE)
    })

    # Extract phenotype data from eSet object
    pDat <- reactive({
        pData(eset())
    })

    # extract file summary information from gds, eset and pDat objects
    # TODO: Add scripts to extract file summary information here

    # File upload validation
    validate_upload <- reactive({
        validate(
          need(input$file1, "Unable to display table, please upload a GDS file.")
          # TODO: Add test to verify GDS format
          # TODO: Add test to check for empty file
        )
    })


    # upload_tab reactive outputs ----

    # display file summary information in "data_summary" tab
    # TODO: Add scripts to display file summary information here
    output$data_summary <- renderDataTable({
        validate_upload()
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
        summary(pDat())
    })


    # ---- stats_tab item ----

    # ---- hca_tab item ----
    
    # data cleaning
    geneNames <- reactive({
        as.character()
    })
    



    # ---- pca_tab item ----



    # ---- dge_tab item ----



    # ---- htf_activity_tab item ----

} # close server
