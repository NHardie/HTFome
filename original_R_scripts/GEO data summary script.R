#script for gathering summary description of the GEO data

desc <- Meta(gse)$description #get description of the data
matrix_desc <- matrix(desc) #convert into matrix
cur_desc <- matrix_desc[1] #extract only the actual description

number_of_features <- Meta(gse)$feature_count #get the number of probes gathered in the experiment

number_of_samples <- Meta(gse)$sample_count #get the number of samples

organism <- Meta(gse)$sample_organism #get the sample organism

sampletype <- Meta(gse)$sample_type #get the sample type
