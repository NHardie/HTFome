#This script was used to merge the HTF data and the gene regulation relationship data into one file

import pandas as pd

#import relational data
gene_regulation = pd.read_excel(r'/Users/alexander/bioinfo-group-project/gene_regulation.xlsx')

#sort values alphabetically according to EntityB
gene_regulation = gene_regulation.sort_values('EntityB')

#group rows by EntityA and Effect column values (i.e. combine rows that have the same EntityA and Effect
#additionally, join the genes in EntityB column in one cell.
gene_regulation = gene_regulation.groupby(['EntityA','Effect'])['EntityB'].apply(', '.join).reset_index()

# Make a pivot table that has EntityA as row names
# the different levels of the Effects column (e.g. Up-regulation, Down-regulation & Unknow) as column names
# and keep EntityB as values
gene_regulation = gene_regulation.set_index(["EntityA","Effect"]).unstack(level=1)['EntityB']

#load in HTF data
HTF_data = pd.read_excel(r'/Users/alexander/bioinfo-group-project/HTF_data.xlsx')

#merge the two datasets by matching row by row according to gene names
HTF_clean = HTF_data.merge(gene_regulation, how='left', left_on='Gene name' , right_on='EntityA')

#write to excel file
HTF_clean.to_excel("/Users/alexander/bioinfo-group-project/HTF_clean.xlsx", sheet_name = "Overiew")