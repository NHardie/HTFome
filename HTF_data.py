import pandas as pd

df = pd.read_excel('/Users/alexander/bioinfo-group-project/HTF_data.xlsx', header=0)

df['Subcellular location [CC]'] = df['Subcellular location [CC]'].str.replace(r'{.*?}','') # remove redundant curly brackets
df['Subcellular location [CC]'] = df['Subcellular location [CC]'].str.replace(r'theNucleus','the Nucleus') # clean misspells
df['Subcellular location [CC]'] = df['Subcellular location [CC]'].str.replace(r'Note=','') #remove redundancy
df['Subcellular location [CC]'] = df['Subcellular location [CC]'].str.replace(r'theCytoplasm','the Cytoplasm') # clean misspells
df['Function [CC]'] = df['Function [CC]'].str.replace(r'FUNCTION: ','') #remove redundancy from "Function" column
df['Function [CC]'] = df['Function [CC]'].str.replace(r'{.*?}','') # remove redundant curly brackets

df.to_excel("/Users/alexander/bioinfo-group-project/HTF_data.xlsx", sheet_name = 'Overview') #write to excel
