# Title     : GEO GDS Analysis scripts for shiny dashboard
# Objective : Defines the server function
# Created on: 23/02/2021

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
