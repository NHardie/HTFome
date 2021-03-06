# Generated by Django 3.1.5 on 2021-02-25 18:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='drug',
            name='drug_chembl_id',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='drug',
            name='drug_name',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='drug',
            name='trade_name',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='drug',
            name='year_approved',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='chromosome_name',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='dbd',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='down_reg_gene',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='drug_chembl_id',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='drug_name',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='ensemble_id',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='function',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='gene_end',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='gene_name',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='gene_start',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='prot_name',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='strand',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='sub_cell_location',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='uniprot_id',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='unknown_interaction',
            field=models.TextField(default='N/A'),
        ),
        migrations.AlterField(
            model_name='htf',
            name='up_reg_gene',
            field=models.TextField(default='N/A'),
        ),
    ]
