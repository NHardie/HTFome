# Title     : Old script for HTFome's GEO DataSet Analyser (shiny dashboard) - DO NOT USE.
# Objective : Do not use this script, this script is here for display/proof-of-concept purposes.
#             Shows an example of how the VIPER code could be split up into Shiny reactive expressions.
#             NB: this script has not been debugged, so likely some reactivity issues.

# ---- htf_activity_tab item ----

    # htf_activity_tab reactive expressions ----

    # Prepare eset for viper analysis
    viper_eset <- reactive({
        X <- gds_df()
        X <- avereps(X, ID = X$IDENTIFIER)
        eset <- eset[match(X[, "ID_REF"], rownames(eset)),]
        rownames(X) <- X[, "ID_REF"]
        featureNames(eset) <- X[, "IDENTIFIER"]
        rownames(X) <- X[, "IDENTIFIER"]
        exp <- X[, -c(1:2)]
        class(exp) <- "numeric"
        exprs(eset) <- exp
        eset
    })

    # Convert DoRothEA network to regulon
    get_regulon <- reactive({
        data(dorothea_hs, package = "dorothea")
        viper_regulons <- df2regulon(dorothea_hs)
        viper_regulons
    })

    viper_analysis <- reactive({

        # Get treatment factors
        factor_category <- colnames(pDat()[2])
        treatment_name <- input$treatment_name
        control_name <- input$control_name

        # Perform t-test
        eset <- viper_eset()
        signature <- rowTtest(eset, factor_category, treatment_name, control_name)
        signature <- (qnorm(signature$p.value/2, lower.tail = FALSE) *
                + sign(signature$statistic))[, 1]

        # Create nullmodel based on 1000 iterations
        nullmodel <- ttestNull(eset,
                               factor_category, treatment_name, control_name,
                               per = 1000, repos = TRUE, verbose = FALSE)

        # msVIPER analysis
        viper_regulons <- get_regulon()
        mra <- msviper(signature, viper_regulons, nullmodel, verbose = FALSE)
        plot(mra, cex = 0.8)
    })