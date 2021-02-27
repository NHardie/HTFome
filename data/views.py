from django.shortcuts import render
from django.db import models
from django.db.models import Q
from .models import Htf, Drug
from django.contrib import messages, admin
from django.contrib.auth.decorators import login_required
from django.core.files.storage import FileSystemStorage
import csv, io
from django.core.paginator import Paginator
from .filters import Htffilter, Drugfilter


# Create your views (Webpages) here.

# From data/urls.py
# Views = webpages
# Each function defines what to do when the url referenced in data/urls.py
# is accessed with a http request
# In these examples, each request to the function returns an httpResponse,
# or a template.
# Route is as follows:
# htf_web/urls.py -> data/urls.py -> views.py


# def home(request):
    # define the function to deal with home receiving a request
    # return HttpResponse("<h1>Home</h1>")
    # A request returns a HTTPResponse

def home(request):
    # Define function, what to do when a request comes
    return render(request, "data/home.html", {'title': 'The Human Transcription Factor Database'})
    # return render of template located in data/templates/data/home.html

def htf(request):
    all_htfs = Htf.objects.all().order_by('gene_name')
    # This is the model (database table) containing the HTF's, we take the table,
    # all the HTF's and order them alphabetically by gene_name

    paginator = Paginator(all_htfs, 15)
    # This is the Paginator function working on the HTF list, displaying 15 per page

    page_number = request.GET.get('page')
    # Need to know the page_number, i.e. page 1, 2, 3...109

    page_obj = paginator.get_page(page_number)
    # This releases a page object for us to use in the html template
    # page_object contains the list of HTF's for each page.

    # Add a dictionary containing htf's as a page object, can now display on html page
    return render(request, "data/htf.html", {'page_obj': page_obj, 'title': 'HTF Search'})

def htf_detail(request, gene_name):
    htf = Htf.objects.get(gene_name=gene_name)
    # Again we want the HTF table but a GET request for the specific HTF by gene name
    drug_name = str(htf.drug_name).split(',')
    drug_chembl_id = str(htf.drug_chembl_id).split(',')
    zipped = zip(drug_chembl_id, drug_name)
    context={
        "htf":htf, 'zipped':zipped
    }
    # Use this context dictionary as an example of another way of releasing this variable
    # for the HTML page to access. Could do {'htf": htf} instead of context.
    return render(request, "data/htf_details.html", context)

def drug(request):
    all_drugs = Drug.objects.all().order_by('drug_name')
    # This is the model (database table) containing the drug's, we take the table,
    # all the drug's and order them alphabetically by drug_name

    paginator = Paginator(all_drugs, 15)
    # This is the Paginator function working on the drug list, displaying 15 per page

    page_number = request.GET.get('page')
    # Need to know the page_number, i.e. page 1, 2, 3...109

    page_obj = paginator.get_page(page_number)
    # This releases a page object for us to use in the html template
    # page_object contains the list of drugs's for each page.

    # Add a dictionary containing drugs's as a page object, can now display on html page
    return render(request, "data/drug.html", {'page_obj': page_obj, 'title': 'Drug Search'})

def drug_detail(request, drug_name):
    drug = Drug.objects.get(drug_name=drug_name)
    htf = Htf.objects.filter(drug_name__icontains=drug_name)
    # Again we want the HTF table but a GET request for the specific HTF by gene name
    context={
        "drug":drug, 'htf': htf
    }
    # Use this context dictionary as an example of another way of releasing this variable
    # for the HTML page to access. Could do {'htf": htf} instead of context.
    return render(request, "data/drug_details.html", context)

def genexp(request):
    context = {}
    if request.method == 'POST':
        uploaded_file = request.FILES['document']
        fs = FileSystemStorage()
        name = fs.save(uploaded_file.name, uploaded_file)
        context['url'] = fs.url(name)
    return render(request, "data/genexp.html", context)

def download(request):
    return render(request, "data/download.html", {'title': 'Download'})

def about(request):
    return render(request, "data/about.html", {'title': 'About'})

def help(request):
    return render(request, "data/help.html", {'title': 'Help'})

def documentation(request):
    return render(request, "data/documentation.html", {'title': 'Documentation'})

def htf_search(request):
    fil = Htffilter(request.GET, queryset=Htf.objects.all())
    # This is the filter object as designed in the filters.py, allows us to generate a
    # filter form on the webpage
    paginator_1 = Paginator(fil.qs, 15)
    page_number_1 = request.GET.get('page', 1)
    page_obj_1 = paginator_1.get_page(page_number_1)


    if request.method == "GET":
        search = request.GET.get("q", '')
        # Need to create a search using GET requests from the webpage.
        # Here "q" stands for query, on the HTML template this is what the user inputs as a search
        if search:
            search_function = Htf.objects.filter(
                Q(ensemble_id__iexact=search) | Q(dbd__iexact=search)
                | Q(gene_name__icontains=search)
                | Q(chromosome_name__iexact=search) | Q(gene_start__icontains=search)
                | Q(gene_end__icontains=search) | Q(strand__iexact=search)
                | Q(uniprot_id__iexact=search) | Q(prot_name__icontains=search)
                | Q(function__icontains=search) | Q(sub_cell_location__iexact=search)
                | Q(up_reg_gene__iexact=search) | Q(down_reg_gene__iexact=search)
                | Q(unknown_interaction__iexact=search) | Q(drug_chembl_id__iexact=search)
                | Q(drug_name__iexact=search)
            )
        else:
            search_function = Htf.objects.none()
        # This is the query function for the full search, allows user to search
        # any of the database table fields, returns results that match the search
        # exactly, or the result contains the search.

        paginator = Paginator(search_function, 15)
        # Pagination function for search_function

        page_number = request.GET.get('page', 1)
        # Need to know page numbers

        page_obj = paginator.get_page(page_number)
        # Need a page object for the HTML template

        new_request = ''
        # Empty string to put url's into

        for i in request.GET:
            if i != 'page':
                val = request.GET.get(i)
                new_request += f"&{i}={val}"
                # Adds the search parameters to the empty string
                # This is then added into the HTML template as pagination
                # to allow the user to click next/ previous page without
                # losing their search terms.

    return render(request, "data/htfsearch.html", {'filter': fil, 'page_obj':page_obj,'page_obj_1':page_obj_1,
                                                'new_request': new_request, 'search':search})

def drug_search(request):
    fil = Drugfilter(request.GET, queryset=Drug.objects.all())
    # This is the filter object as designed in the filters.py, allows us to generate a
    # filter form on the webpage
    paginator_1 = Paginator(fil.qs, 15)
    page_number_1 = request.GET.get('page', 1)
    page_obj_1 = paginator_1.get_page(page_number_1)


    if request.method == "GET":
        search = request.GET.get("q", '')
        # Need to create a search using GET requests from the webpage.
        # Here "q" stands for query, on the HTML template this is what the user inputs as a search
        if search:
            search_function = Drug.objects.filter(
                Q(drug_name__iexact=search) | Q(trade_name__icontains=search)
                | Q(drug_chembl_id__iexact=search)
                | Q(year_approved__icontains=search)
            )
        else:
            search_function = Drug.objects.none()
        # This is the query function for the full search, allows user to search
        # any of the database table fields, returns results that match the search
        # exactly, or the result contains the search.

        paginator = Paginator(search_function, 15)
        # Pagination function for search_function

        page_number = request.GET.get('page', 1)
        # Need to know page numbers

        page_obj = paginator.get_page(page_number)
        # Need a page object for the HTML template

        new_request = ''
        # Empty string to put url's into

        for i in request.GET:
            if i != 'page':
                val = request.GET.get(i)
                new_request += f"&{i}={val}"
                # Adds the search parameters to the empty string
                # This is then added into the HTML template as pagination
                # to allow the user to click next/ previous page without
                # losing their search terms.

    return render(request, "data/drugsearch.html", {'filter': fil, 'page_obj':page_obj,'page_obj_1':page_obj_1,
                                                'new_request': new_request, 'search':search})



@login_required
# Must be logged in as admin to access this page, returns an error otherwise
def htf_data_upload(request):
    data = Htf.objects.all()
    prompt = {
        "Order": "Order of the CSV should be:"
                 "Ensemble ID, DBD, Gene name, Chromosome/scaffold name, "
                 "Gene start (bp), Gene end (bp), Strand, "
                 "UniProt ID, Protein names, Function [CC], Subcellular location [CC]"
    }
    # Order of csv file format required to populate database
    if request.method=="GET":
        return render(request, "data/htf_data_upload.html", prompt)

    csv_file = request.FILES["file"]

    if not csv_file.name.endswith(".csv"):
        messages.error(request, "This is not a .csv file")

    data_set = csv_file.read().decode("UTF-8")
    # Read file, creates a data stream
    io_string = io.StringIO(data_set)
    # Can now use object in memory
    next(io_string)
    for column in csv.reader(io_string, delimiter='\t', quotechar="|"):
        if len(column) >= 15:
            _, created = Htf.objects.update_or_create(
                ensemble_id=column[0],
                dbd=column[1],
                gene_name=column[2],
                chromosome_name=column[3],
                gene_start=column[4],
                gene_end = column[5],
                strand = column[6],
                uniprot_id = column[7],
                prot_name = column[8],
                function = column[9],
                sub_cell_location=column[10],
                up_reg_gene=column[11],
                down_reg_gene=column[12],
                unknown_interaction=column[13],
                drug_chembl_id=column[14],
                drug_name=column[15],
            )
        # Iterates through the original csv file, copies the data to the database
    context = {}
    return render(request, "data/htf_data_upload.html", context)

@login_required
# Must be logged in as admin to access this page, returns an error otherwise
def drug_data_upload(request):
    data = Drug.objects.all()
    prompt = {
        "Order": '''Order of the CSV should be: drug name,' 
                 'drug Trade names, drug chembl id,' 
                 'drug approval date''',

    }
    # Order of csv file format required to populate database
    if request.method=="GET":
        return render(request, "data/drug_data_upload.html", prompt)

    csv_file = request.FILES["file"]

    if not csv_file.name.endswith(".csv"):
        messages.error(request, "This is not a .csv file")

    data_set = csv_file.read().decode("UTF-8")
    # Read file, creates a data stream
    io_string = io.StringIO(data_set)
    # Can now use object in memory
    next(io_string)
    for column in csv.reader(io_string, delimiter='\t', quotechar="|"):
        if len(column) >= 4:
        # Had to include this, as was getting index out of range errors
            _, created = Drug.objects.update_or_create(
                drug_name=column[0],
                trade_name=column[1],
                drug_chembl_id=column[2],
                year_approved=column[3]
            )
        # Iterates through the original csv file, copies the data to the database
    context = {}
    return render(request, "data/drug_data_upload.html")
