# 2.5.2. Main features

Below shows the server reactives along with their associated reactive outputs for each tab item in the dashboard, a description of the reactive functions are also included.

Upload GDS file tab:

|Server reactives| Reactive output| Description|
|:----------------:|:--------------:|:---------|
|validate_upload()|All outputs|Checks if file has been uploaded by user. If not, it pastes a message for user to upload file.
|gds()| N/A gets passed to gds_df()| Object created when user uploads GDS file, processes file using getGEO(). Output is the GDS data structure (class GDS).|
|gds_df()|output$gds_preview|Converts gds() reactive to a dataframe, using function Table(gds()).|
|eset()|N/A gets passed to pDat() reactive.|Convert gds() reactive (data structure) to ExpressionSet using GDS2eSet() function.|
|pDat()|output$pDat_preview|Extract phenotype data from eSet object, using pData() function.|
|data_sum()|output$data_summary|extract file summary information from gds, eset and pDat objects.|


Summary statistics tab:

|Server reactives| Reactive output| Description|
|:----------------:|:--------------:|:---------|
|N/A|output$pheno_plot|Display phenotype plot, of pDat() reactive.|



Hierarchical clustering analysis tab:


|Server reactives| Reactive output| Description|
|:----------------:|:--------------:|:---------|
|gene_exp()|N/A gets passed to sort_gene_SD() reactive.|Combine gene names from gds and expression data from eSet, then remove any duplicated genes by taking the average expression of probes corresponding to same gene. Output is a matrix containing averaged gene expression data.|
|sort_gene_SD()|N/A gets passed to top_genes_mat() reactive.|Calculate standard deviation of genes across all samples and sort rows by highest SD. Output is a data frame containing genes and their expression data, sorted by SD.(NB: Shiny doesn't seem to like data passed to apply() in matrix form, so we need to convert it to a data frame first.)|
|top_genes_mat()|N/A gets passed to heatmap() reactive.|Extract user-defined genes with highest SD and convert to numeric matrix|
|heatmap()|output$heatmap|Plot heatmap (using heatmap.2)|
|N/A (# TODO)|output$pDat_cols_hca|Display column names user can colour samples by.|



Principal component analysis tab:

|Server reactives| Reactive output| Description|
|:----------------:|:--------------:|:---------|
|pca()|N/A gets passed to pca_summary() and pca_scores() reactives.|Perform PCA: get averaged gene expression data, transform it and remove any columns containing zeros and NAs first.|
|pca_summary()|output$pca_data|Get summary of PCA results.|
|scree_plot()|output$screeplot|Plot scree plot.|
|cum_var()|output$cum_var_plot|Plot cumulative variance.|
|pca_scores()|output$pca_plot|Plot PCA scores.|
|my_cols()|NA (# TODO)|output$pDat_cols_pca|Set colours by sample type, to display column names user can colour samples by.|



Differential gene expression analysis tab:

|Server reactives| Reactive output| Description|
|:----------------:|:--------------:|:---------|
|FUTURE DEVELOPMENT WORK|



Estimate of HTF activity tab:

|Server reactives| Reactive output| Description|
|:----------------:|:--------------:|:---------|
|validate_htf_button()||File upload validation.|
|viper_output()|output$viper_plot, output$viper_summary|Run VIPER analysis. Uses function viper_analysis() (defined in global.R).|
|sample_choice()|output$get_treatment_name,output$get_control_name|Define sample choices for HTF activity analysis. Let user select treatment variable and control variable.|


