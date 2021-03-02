### Alexander Malling Andersen
### HTF activity script


#Install Bioconductor and the GEOquery package
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("viper")
BiocManager::install("dorothea")
BiocManager::install(c("GEOquery"))

#load libraries
library(BiocManager)
library(GEOquery)
library(viper)
library(dorothea)
library(limma)
library(dplyr)


gse <- getGEO("GDS5093", GSEMatrix = TRUE) #load data set
eset <- GDS2eSet(gse, do.log2=TRUE) #create ExpressionSet
pDat <- pData(eset)

#MODIFICATION BY MAGDALENA
#converting probe names to gene symbols
X <- Table(gse)
X <- avereps(X, ID=X$IDENTIFIER) # summarise probe values to a single expression value per gene
eset <- eset[match(X[, "ID_REF"], rownames(eset)),] # update eset dimensions
rownames(X) <- X[, "ID_REF"]
featureNames(eset) <- X[, "IDENTIFIER"] # rename featureNames from probeids to gene symbols
rownames(X) <- X[, "IDENTIFIER"]
exp <- X[, -c(1:2)]
class(exp) <- "numeric"
exprs(eset) <- exp # write expression matrix back to eset

#get treatment factors 
factor_category <- "infection"
treatment_name <- "Dengue virus"
control_name <- "control"

### NEEDS TO GET USER INPUT ####


#convert DoRothEA network to regulon
data(dorothea_hs, package = "dorothea")
viper_regulons = df2regulon(dorothea_hs)

#perform t-test
signature <- rowTtest(eset, factor_category, treatment_name, control_name)
signature <- (qnorm(signature$p.value/2, lower.tail = FALSE) *
                + sign(signature$statistic))[, 1]

#create nullmodel based on 1000 iterations
nullmodel <- ttestNull(eset, factor_category, treatment_name, control_name, per = 1000, repos = TRUE, verbose = FALSE)

#msVIPER analysis
mra <- msviper(signature, viper_regulons, nullmodel, verbose = FALSE)

plot(mra) #plot the analysis
