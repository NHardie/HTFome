import django_filters

from .models import Htf, Drug

class Htffilter(django_filters.FilterSet):
    Gene = django_filters.CharFilter(field_name='gene_name', lookup_expr='icontains', label='Gene Name')
    Chromosome = django_filters.CharFilter(field_name='chromosome_name', lookup_expr='iexact', label='Chromosome')
    Protein = django_filters.CharFilter(field_name='prot_name', lookup_expr='icontains', label='Protein Name')
    Function = django_filters.CharFilter(field_name='function', lookup_expr='icontains', label='Function')
    Location = django_filters.CharFilter(field_name='sub_cell_location', lookup_expr='icontains', label='Subcellular Location')

    class Meta:
        model = Htf
        fields = ['Gene', 'Chromosome',
                  'Protein', 'Function', 'Location']

class Drugfilter(django_filters.FilterSet):
    Drug = django_filters.CharFilter(field_name='drug_name', lookup_expr='icontains', label='Drug Name')
    Trade_name = django_filters.CharFilter(field_name='trade_name', lookup_expr='icontains', label='Trade Name')
    Molecule_type = django_filters.CharFilter(field_name='drug_molecule_type', lookup_expr='icontains', label='Drug molecule type')

    class Meta:
        model = Drug
        fields = ['Drug', 'Trade_name',
                  'Molecule_type']