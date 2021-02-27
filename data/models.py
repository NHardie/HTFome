from django.db import models

# Create your models here.
# This is the database file

# We need to create the database tables, referred to as models
# https://docs.djangoproject.com/en/3.1/ref/models/fields/#model-field-types

class Drug(models.Model):
    drug_name = models.TextField(default='N/A')
    trade_name = models.TextField(default='N/A')
    drug_chembl_id = models.TextField(default='N/A')
    year_approved = models.TextField(default='N/A')

class Htf(models.Model):
    ensemble_id = models.TextField(default='N/A')
    dbd = models.TextField(default='N/A')
    gene_name = models.TextField(default='N/A')
    chromosome_name = models.TextField(default='N/A')
    gene_start = models.TextField(default='N/A')
    gene_end = models.TextField(default='N/A')
    strand = models.TextField(default='N/A')
    uniprot_id = models.TextField(default='N/A')
    prot_name = models.TextField(default='N/A')
    function = models.TextField(default='N/A')
    sub_cell_location = models.TextField(default='N/A')
    up_reg_gene = models.TextField(default='N/A')
    down_reg_gene = models.TextField(default='N/A')
    unknown_interaction = models.TextField(default='N/A')
    drug_chembl_id = models.TextField(default='N/A')
    drug_name = models.TextField(default='N/A')








