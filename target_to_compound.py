import csv
from chembl_webresource_client.new_client import new_client

compounds2targets = dict()


#PARSE CSV WITH TARGET IDS
with open('chemblids.csv', 'r') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
        compounds2targets[row[0]] = set()

chunk_size = 50
keys = list(compounds2targets.keys())

#TARGET TO COMPOUNDS
for i in range(0, len(keys), chunk_size):
    activities = new_client.activity.filter(target_chembl_id__in=keys[i:i + chunk_size]).only(['target_chembl_id', 'molecule_chembl_id'])
    for act in activities:
        compounds2targets[act['target_chembl_id']].add(act['molecule_chembl_id'])


drug_chembl_ids=[]
#PHASE 4 FILTER
for key, val in compounds2targets.items():
    lval = list(val)
    genes = []
    temp=[]
    for i in range(0, len(val), chunk_size):
        compounds = new_client.molecule.filter(molecule_chembl_id__in=lval[i:i + chunk_size]).only(
            ['molecule_chembl_id','max_phase','pref_name'])
        for compound in compounds:
            if compound['max_phase'] == 4:
                    genes.append(compound['pref_name'])
                    temp.append(compound['molecule_chembl_id'])
    drug_chembl_ids.append(temp)
    compounds2targets[key] = genes
print(drug_chembl_ids)

new_dict=compounds2targets.copy()
genesymbols=[]

#ADD GENE SYMBOLS
for key in keys:
    symbol = []
    targets = new_client.target.filter(target_chembl_id=key).only(
            ['target_components'])
    tempsymbol=[]
    for target in targets:
        for components in target['target_components']:
            for synonym in components['target_component_xrefs']:
                if synonym['xref_src_db'] == "EnsemblGene":
                        symbol.append(synonym['xref_id'])
            for synonym in components['target_component_synonyms']:
                if synonym['syn_type'] == "GENE_SYMBOL":
                        tempsymbol.append(synonym['component_synonym'])

    genesymbols.append(tempsymbol)

    new_dict[key] = symbol

print(new_dict)
ens_list=new_dict.values()

#WRITING
header = ["TF gene symbol", "Drugs"]

with open('final_phase4.tsv', 'wt', encoding='utf-8-sig', newline='') as f:
    writer = csv.writer(f, delimiter='\t')
    writer.writerow(header) # write the header
    for k,v in compounds2targets.items():
        writer.writerow([k,v])

with open("ENSMBLids.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(ens_list)

with open("drug_chembl_ids.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(drug_chembl_ids)

with open("gene_symbols.tsv", 'w', newline='') as myfile:
    wr = csv.writer(myfile, delimiter='\n')
    wr.writerow(genesymbols)

















