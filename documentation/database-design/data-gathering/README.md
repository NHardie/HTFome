# 2.4.2. Data Gathering

HTFome requires HTF and drug data to provide to the user, and for simplicity this data has to be freely and easily accessible by the public. We utilised the Application-Programming Interface’s (API’s) of major biological data repositories to write requests specific to the HTF and drug background data we required. Once this data was gathered, we used Python to clean/manipulate the data before it was added to the webapp database.

For the HTF data, several recognized resources were combined to produce a thorough and curated list that possessed sufficient supporting evidence. Firstly, a starting point for a comprehensive list of HTFs had to be established. A list was generated from Lambert, Samuel A. et. al 2018, as this review went over a catalog of over 1,600 HTFs and looked at how they were identified and at their functional characterization.

After establishing an initial list of HTFs, UniProt, which is a collaboration between the European Bioinformatic Institute, the Swiss Institute of Bioinformatics and the Protein Information Resource and a protein sequence and annotation database, was used to gather essential information of HTF function and subcellular location(s). This was done by utilizing UniProt’s “Retrieve ID/mapping” tool. From the HTFs list, the gene names were extracted and used as identifiers and the UniProtKB data type was used as target format. UniProt.org contains a lot of information, both revised, as well as computationally proposed information. Only HTF results that had been reviewed were chosen for further implementation.

The data on relationships between HTFs and their targeted genes was gathered from Signor (The SIGnalling Network Open Resource), which is an open source database that contains curated signalling networks for the entire human genome and several other species.

Supporting information regarding chromosome and gene position, for all HTFs were gathered from Ensemble Biomart, which is a datasite based at  European Molecular Biology Laboratory's European Bioinformatics Institute and produces, as well as maintains automatic annotation on selected eukaryotic genomes.
 
The drug data were gathered from ChEMBL, a database organised and maintained by the European Molecular Biology Laboratory (EMBL), containing data on small molecules with drug-like effects, including drugs used in medicine, drugs used in research, including in trials, and predicted drug compounds. ChEMBL includes a wealth of data for each compound, as well as drug targets, making it perfect for our requirements.
