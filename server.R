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
        pDatPlot <- ggplot(pDat(), aes(x=pDat()[,3])) +
          geom_bar(color="black", position=position_dodge()) +
          theme_minimal()
        ggplotly(pDatPlot)
    })


    # ---- hca_tab item ----

    # hca_tab reactive expressions ----

    # Combine gene names from gds and expression data from eSet, then
    # remove any duplicated genes by taking an average of probes
    # corresponding to same gene.
    # Output is a matrix containing averaged gene expression data.
    gene_exp <- reactive({
        # TODO: check what data classes we have before/after adding rownames
        geneNames <- as.character(gds_df()$IDENTIFIER)
        gene_eset <- exprs(eset())
        rownames(gene_eset) <- geneNames
        avereps(gene_eset, ID = rownames(gene_eset))
    })

    # Calculate standard deviation of genes across all samples and sort
    # rows by highest SD. Output is a data frame containing genes and
    # their expression data, sorted by SD.
    sort_gene_SD <- reactive({
        # Shiny doesn't seem to like data passed to apply() in matrix
        # form, so we need to convert it to a data frame first.
        gene_exp_df <- data.frame(matrix(gene_exp()))
        gene_SD <- transform(gene_exp_df, SD = apply(gene_exp_df, 1, sd, na.rm = TRUE))
        gene_SD[with(gene_SD, order(-SD)),]
    })

    # Extract user-defined genes with highest SD and convert to numeric matrix
    top_genes_mat <- reactive({
        sorted_num_genes <- head(sort_gene_SD(), input$gene_num)
        sorted_num_genes <- sorted_num_genes[1:(length(sorted_num_genes)-1)] # remove SD column
        as.matrix(sorted_num_genes)
        # Warning: Error in heatmap.2: `x' must have at least 2 rows and 2 columns
        # TODO: see what top_genes_mat() is returning
    })

    # Plot heatmap (base R)
    heatmap <- reactive({
        # print(nrow(top_genes())) # test to check user gene_num input works
        # print(class(top_genes())) # test to check data is right class
        print(dim(top_genes_mat())) # 100 x 1
        print(class(top_genes_mat())) # matrix
        print(class(sort_gene_SD())) # df
        print(class(gds_df())) #df
        print(class(gene_exp())) #matrix
        heatmap.2(
          top_genes_mat(),
          distfun = input$distance_method,
          hclustfun = input$linkage_method,
          scale = input$scaling,
          trace = "none",
          xlab = "Samples (n=" + ncol(top_genes_mat()) + ")",
          ylab = "Genes (n=" + nrow(top_genes_mat()) + ")",
          key.title = "SD from mean",
          key.xlab = NA,
          key.ylab = NA,
          lhei = c(1,6),
          lwid = c(1,3.5),
          keysize = 0.35,
          key.par = list(cex = 0.5),
          labRow = FALSE,
          labCol = FALSE,
          margins = c(2,2),
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

    # pca_tab reactive outputs ----


    # ---- dge_tab item ----

    # dge_tab reactive expressions ----

    # dge_tab reactive outputs ----


    # ---- htf_activity_tab item ----

    # htf_activity_tab reactive expressions ----

    # htf_activity_tab reactive outputs ----


} # close server
