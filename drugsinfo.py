import csv
from chembl_webresource_client.new_client import new_client


#EXTARCT EXTRA INFO FOR DRUGS
drugs_ids = []

#PARSE A CSV WITH ALL DRUGS IDS
with open('INPUT_drugsid.csv', 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        drugs_ids.append(row)

flat_list = [item for sublist in drugs_ids for item in sublist]
print(flat_list)

#GET TRADE NAMES
trade_names=[]
for i in range(0, len(flat_list)):
    drugsyn = []
    molecules = new_client.molecule.filter(molecule_chembl_id__in=flat_list[i:i + 1]).only(
        ['molecule_chembl_id','molecule_synonyms'])
    for molecule in molecules:
        for synonym in molecule['molecule_synonyms']:
            if synonym['syn_type'] == "TRADE_NAME":
                drugsyn.append(synonym['molecule_synonym'])
    trade_names.append(drugsyn)
print(trade_names)

#get PREF_NAME
pref_names=[]
mol_types=[]
for i in range(0, len(flat_list)):
    pref_name=[]
    mol_type=[]
    molecules = new_client.molecule.filter(molecule_chembl_id__in=flat_list[i:i + 1]).only(
        ['molecule_chembl_id', 'pref_name','molecule_type'])
    for molecule in molecules:
        pref_name.append(molecule['pref_name'])
        mol_type.append(molecule['molecule_type'])
    pref_names.append(pref_name)
    mol_types.append(mol_type)

print(len(pref_names))
print(len(mol_types))

#PRINT OUTPUT

with open("trade_namesOUT.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(trade_names)

with open("pref_namesOUT.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(pref_names)

with open("drug_chemblOUT.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(flat_list)

with open("mol_typesOUT.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(mol_types)





