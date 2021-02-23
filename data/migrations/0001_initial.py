# Generated by Django 3.1.5 on 2021-02-23 17:40

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Drug',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('drug_name', models.CharField(max_length=100)),
                ('trade_name', models.CharField(max_length=10000)),
                ('drug_chembl_id', models.CharField(max_length=30)),
                ('drug_molecule_type', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='Htf',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ensemble_id', models.CharField(max_length=30)),
                ('dbd', models.CharField(max_length=30)),
                ('gene_name', models.CharField(max_length=30)),
                ('chromosome_name', models.CharField(max_length=30)),
                ('gene_start', models.CharField(max_length=30)),
                ('gene_end', models.CharField(max_length=30)),
                ('strand', models.CharField(max_length=30)),
                ('uniprot_id', models.CharField(max_length=30)),
                ('prot_name', models.CharField(max_length=1000)),
                ('function', models.CharField(max_length=100000)),
                ('sub_cell_location', models.CharField(max_length=100000)),
                ('drugs', models.CharField(max_length=10000)),
            ],
        ),
    ]
