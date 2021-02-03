from django.db import models

# Create your models here.
# This is the database file

# We need to create the database tables, referred to as models
# https://docs.djangoproject.com/en/3.1/ref/models/fields/#model-field-types

class Drug(models.Model):
    name = models.CharField(max_length=100)

class Htf(models.Model):
    name = models.CharField(max_length=30)
    gene_id = models.CharField(max_length=30)
    gene_symbol = models.CharField(max_length=30)
    family = models.CharField(max_length=30)
    cell_location = models.CharField(max_length=30)
    gene_regulation = models.CharField(max_length=30)
    drugs = models.ManyToManyField(Drug)








