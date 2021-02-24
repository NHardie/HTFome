# Title     : GEO GDS Analysis scripts for shiny dashboard
# Objective : Defines the server function
# Created on: 23/02/2021

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
        # print(spec(gds_file))
        # vroom_write(gds_file, "test.tsv.gz")
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
        # req(input$file1)
        # print(file1$datapath)
        # getGEO(file1$datapath, GSEMatrix = TRUE)
        getGEO(filename = input$file1$datapath)
    })
    
    # eset <- reactive({
    #     gdss <- gds()
    #     GDS2eSet(gdss,do.log2 = TRUE)
    # })

    # this reactive function takes the gds object and passes it as an
    # argument to GEOquery's GDS2eSet() function, which converts the GDS
    # file object to an ExpressionSet object.


    # reactive outputs ----

    # Output table of GDS file for the "summary" outputId (referenced in
    # the dashboard body UI for the stats_tab)
    output$summary <- renderDataTable({
        #problems(gds())
        gdss <- gds()
        eset <- GDS2eSet(gdss)
        print(eset)
        #Table(gds())
        #spec(gds())
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
