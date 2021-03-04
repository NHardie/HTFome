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
        # GEOquery cannot currently parse full SOFT GDS files into eSet,
        # as the _full.soft.gz files seem to have an extra GPL line which
        # GDS2eset() is unable to parse.
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
    data_summ <- reactive({

        get_title <- Meta(gds())$title

        desc <- Meta(gds())$description
        matrix_desc <- matrix(desc) # need to convert to matrix
        get_desc <- matrix_desc[1] # extract only the actual description

        get_num_features <- Meta(gds())$feature_count
        get_num_samples <- Meta(gds())$sample_count
        get_organism <- Meta(gds())$sample_organism
        get_sample_type <- Meta(gds())$sample_type
        get_platform <- Meta(gds())$platform
        get_channel_count <- Meta(gds())$channel_count
        # get_factor_levels <- as.character(unique(unlist(pDat()[,2]))) # TODO: debug why adding any further info causes info in frontend to repeat

        title <- paste("Experiment title: ",get_title, sep = "")
        description <- paste("Description: ",get_desc, sep = "")
        features <- paste("Number of features (genes) in dataset: ", get_num_features, sep = "")
        num_samples <- paste("Number of samples: ", get_num_samples, sep = "")
        organism <- paste("Organism: ", get_organism, sep = "")
        sample_type <- paste("Sample type: ", get_sample_type, sep = "")
        platform_info <- paste("Platform: ",get_platform, sep = "")
        channel_count <- paste("Channel count: ",get_channel_count, sep = "")

        HTML(paste(title, description, features, num_samples, organism, sample_type, platform_info, channel_count, sep = '<br/><br/>'))

    })



    # upload_tab reactive outputs ----

    # display file summary information for "data_summary" tab
    output$data_summary <- renderUI({
        validate_upload()
        data_summ()
    })

    # display preview of gds data in "gds_preview" tab
    output$gds_preview <- renderDataTable({
        validate_upload()
        gds_df()[1:25,1:5] # displaying first 5 columns fixes over-sized rows
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
        gene_exp_df <- as.data.frame(gene_exp())
        gene_SD <- transform(gene_exp_df, SD = apply(gene_exp_df, 1, sd, na.rm = TRUE))
        gene_SD[with(gene_SD, order(-SD)),]
    })

    # Extract user-defined genes with highest SD and convert to numeric matrix
    top_genes_mat <- reactive({
        top_num_genes <- head(sort_gene_SD(), input$gene_num)
        top_num_genes <- top_num_genes[1:(length(top_num_genes)-1)]
        as.matrix(top_num_genes)
    })

    # Plot heatmap (using heatmap.2)
    heatmap <- reactive({
        top_genes_mat <- as.matrix(top_genes_mat())
        samples <- paste("Samples (n=",ncol(top_genes_mat),")", sep = "")
        genes <- paste("Genes (n=",nrow(top_genes_mat),")", sep = "")
        heatmap.2(top_genes_mat,
          # TODO: Colour samples by sample type.
          distfun = function(x) dist(x, method = input$distance_method),
          hclustfun = function(x) hclust(x, method = input$linkage_method),
          scale = input$scale,
          trace = "none",
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

    # Display column names user can colour samples by
    output$pDat_cols_hca <- renderUI({
        pDat_col <- names(pDat()[2:3])
        selectInput("hca_cols", "Colour samples by:",
                    choices = pDat_col)
    })

    output$heatmap <- renderPlot({
        validate_upload()
        heatmap()
    })

    # ---- pca_tab item ----

    # pca_tab reactive expressions ----

    # Perform PCA: get averaged gene expression data, transform it and
    # remove any columns containing zeros and NAs first
    pca <- reactive({
        gene_exp_mat <- gene_exp()
        tX <- t(gene_exp_mat)
        Xpca <- tX[, colSums(tX != 0, na.rm = TRUE) > 0]
        Xpca <- prcomp(Xpca, center = TRUE, scale. = TRUE)
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
        legend("topright", legend = "Eigenvalue = 1",
               col = "red", lty = 5, cex = 0.9)
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

    # Plot PCA scores
    pca_scores <- reactive({
        scores <- pca()$x
        plot(scores[,1],
             scores[,2],
             xlab = "PC1",
             ylab = "PC2",
             pch = 19,
             main = "PCA scores (per sample)",
             col =
        )
    })

    # Set colours by sample type # TODO: still in progress
    my_cols <- reactive({
        pDat_col_name <- names(pDat()[input$pca_cols])
        pDat_choice <- pDat()[input$pca_cols]
        num_sample_types <- length(unique(pDat_choice$pDat_col_name))

        rows <- pDat()[,input$pca_cols]
        num_rows <- length(unique(rows))
        unique_rows <- unique(rows)
        unique_rows

        x <- colnames(pDat()[2])
        treatment_name <- input$treatment_name
        control_name <- input$control_name

        #my_cols <- c("#0096FF", "#F8766D", "#E76CF3", "#00BA38")
        #names(my_cols) <- c("Convalescent", "Dengue Hemorrhagic Fever", "Dengue Fever", "healthy control")

    })


    # pca_tab reactive outputs ----

    # Display column names user can colour samples by
    output$pDat_cols_pca <- renderUI({
        pDat_col <- names(pDat()[2:3]) # select categorical variables only
        selectInput("pca_cols", "Colour samples by:",
                    choices = pDat_col)
    })

    output$pca_data <- renderPrint({
        validate_upload()
        pca_summary()
        #my_cols()
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
    # TODO: Add code for differential gene expression analysis here.

    # dge_tab reactive expressions ----

    # dge_tab reactive outputs ----


    # ---- htf_activity_tab item ----

    # htf_activity_tab reactive expressions ----

    # File upload validation
    validate_htf_button <- reactive({
        validate(
          need(input$htf_activity_button,
               "Nothing to display here, please assign treatment and control variables and click the button to begin analysis.")
        )
    })

    # Run VIPER analysis
    viper_output <- reactive({

        # Get treatment factors
        sample_type <- colnames(pDat()[2])
        treatment_name <- input$treatment_name
        control_name <- input$control_name

        # Run analysis
        viper_analysis(gds(), eset(), sample_type, treatment_name, control_name)
    })

    # htf_activity_tab reactive outputs ----

    # Define sample choices for HTF activity analysis
    sample_choice <- reactive({
        pDat_sample_col <- pDat()[,2]
        unique(pDat_sample_col)
    })

    # Let user select treatment variable
    output$get_treatment_name <- renderUI({
        selectInput("treatment_name",
                    "Select treatment variable:",
                    choices = sample_choice())
    })

    # Let user select control variable
    output$get_control_name <- renderUI({
        selectInput("control_name",
                    "Select control variable:",
                    choices = sample_choice())
    })

    # Plot viper output
    output$viper_plot <- renderPlot({
        validate_upload()
        validate_htf_button()
        input$htf_activity_button
        plot(viper_output(), cex = 0.7)
    })

    # Display VIPER summary table
    output$viper_summary <- renderDataTable({
        validate_upload()
        validate_htf_button()
        summary(viper_output())
    })

    # VIPER tests - uncomment for developer testing
    # output$viper_test <- renderPrint({
    #     # test functions/reactives with print/class/dim statements here
    # })

} # close server
