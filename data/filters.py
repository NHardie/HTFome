import django_filters

from .models import Htf

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