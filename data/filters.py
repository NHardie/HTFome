import django_filters

from .models import Htf, Drug

# Import database models to filter

class Htffilter(django_filters.FilterSet):
    # Create filters

    Gene = django_filters.CharFilter(field_name='gene_name', lookup_expr='icontains', label='Gene Name')
    # Name of object to be passed to HTML = .Type of filter(Field name in model, icontains or iexact, label used in HTML)

    Chromosome = django_filters.CharFilter(field_name='chromosome_name', lookup_expr='iexact', label='Chromosome')
    Protein = django_filters.CharFilter(field_name='prot_name', lookup_expr='icontains', label='Protein Name')
    Function = django_filters.CharFilter(field_name='function', lookup_expr='icontains', label='Function')
    Location = django_filters.CharFilter(field_name='sub_cell_location', lookup_expr='icontains', label='Subcellular Location')
    Up_Reg = django_filters.CharFilter(field_name='up_reg_gene', lookup_expr='icontains', label='Up-Regulates Gene Name')
    Down_Reg = django_filters.CharFilter(field_name='down_reg_gene', lookup_expr='icontains', label='Down-Regulates Gene name:')
    Drug_Name = django_filters.CharFilter(field_name='drug_name', lookup_expr='icontains', label='Drug Name')

    class Meta:
        model = Htf
        # Name model to be used

        fields = ['Gene', 'Chromosome',
                  'Protein', 'Function', 'Location', 'Up_Reg',
                  'Down_Reg', 'Drug_Name']
        # Fields for HTML

class Drugfilter(django_filters.FilterSet):
    Drug = django_filters.CharFilter(field_name='drug_name', lookup_expr='icontains', label='Drug Name')
    Trade_name = django_filters.CharFilter(field_name='trade_name', lookup_expr='icontains', label='Trade Name')
    Year_approved = django_filters.CharFilter(field_name='year_approved', lookup_expr='icontains', label='Year of Approval')

    class Meta:
        model = Drug
        fields = ['Drug', 'Trade_name',
                  'year_approved']
