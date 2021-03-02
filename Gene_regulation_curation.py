#This script was used to clean the data extracted from Signor and organize the relational data between HTFs and their targeted gens

import pandas as pd

HTF = pd.read_excel('HTF_data.xlsx', header=0) #read excel sheet with HTF list
Genes = pd.read_excel('all_data_08_02_21.xlsx', header=0) #read excel sheet with genes and their targeted genes

Gene_names = HTF["Gene name"] #create list of HTF gene names
Gene_names = Gene_names.sort_values() #sort gene names alphabetically

Gene_target = pd.DataFrame(zip(Genes.ENTITYA, Genes.ENTITYB, Genes.EFFECT, Genes.MECHANISM)) #extract genes, their target and mechanism of action to new df
Gene_target.columns = ["EntityA", "EntityB", "Effect", "Mechanism"] #rename columns

HTF_new = Gene_target[(Gene_target["EntityA"].isin(Gene_names))] #extract only information on genes listed in Gene_names
HTF_new = HTF_new.sort_values(by=['EntityA']) #sort alphabetically
HTF_new = HTF_new[HTF_new.Mechanism.isin(["transcriptional regulation", "transcriptional repression", "transcriptional activation"])] #filter out genes with activity that is not correlated to transcription
HTF_new = HTF_new.drop_duplicates() #drop duplicates

HTF_new.to_excel("gene_regulation.xlsx", sheet_name = 'Overview') #write to excel
