from django.db import models

# Create your models here.
# This is the database file

# We need to create the database tables, referred to as models
# https://docs.djangoproject.com/en/3.1/ref/models/fields/#model-field-types

class Drug(models.Model):
    drug_name = models.CharField(max_length=100000)
    trade_name = models.CharField(max_length=1000000)
    drug_chembl_id = models.CharField(max_length=30)
    drug_molecule_type = models.CharField(max_length=50)

class Htf(models.Model):
    ensemble_id = models.CharField(max_length=30)
    dbd = models.CharField(max_length=30)
    gene_name = models.CharField(max_length=30)
    chromosome_name = models.CharField(max_length=30)
    gene_start = models.CharField(max_length=30)
    gene_end = models.CharField(max_length=30)
    strand = models.CharField(max_length=30)
    uniprot_id = models.CharField(max_length=30)
    prot_name = models.CharField(max_length=1000)
    function = models.CharField(max_length=100000)
    sub_cell_location = models.CharField(max_length=100000)
    drugs = models.CharField(max_length=10000)








