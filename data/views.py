from django.shortcuts import render
from django.db import models
from django.db.models import Q
from .models import Htf, Drug
from django.contrib import messages, admin
from django.contrib.auth.decorators import login_required
from django.conf.urls import url
import csv, io
from django.core.paginator import Paginator
from .filters import Htffilter


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

def detail(request, gene_name):
    htf = Htf.objects.get(gene_name=gene_name)
    # Again we want the HTF table but a GET request for the specific HTF by gene name

    context={
        "htf":htf
    }
    # Use this context dictionary as an example of another way of releasing this variable
    # for the HTML page to access. Could do {'htf": htf} instead of context.
    return render(request, "data/details.html", context)

def drug(request):
    return render(request, "data/drug.html", {'title': 'Drug Search'})

def genexp(request):
    if request.method == 'POST':
        uploaded_file = request.FILES['document']
        print(uploaded_file.name)
        print(uploaded_file.size)
    return render(request, "data/genexp.html", {'title': 'GEO DataSet Analyser'})

def download(request):
    return render(request, "data/download.html", {'title': 'Download'})

def about(request):
    return render(request, "data/about.html", {'title': 'About'})

def help(request):
    return render(request, "data/help.html", {'title': 'Help'})

def documentation(request):
    return render(request, "data/documentation.html", {'title': 'Documentation'})

def search(request):
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
                Q(chromosome_name__iexact=search) | Q(dbd__icontains=search)
                | Q(ensemble_id__iexact=search)
                | Q(function__icontains=search) | Q(gene_end__icontains=search)
                | Q(gene_name__icontains=search) | Q(gene_start__icontains=search)
                | Q(id__icontains=search) | Q(prot_name__iexact=search)
                | Q(strand__icontains=search) | Q(sub_cell_location__iexact=search)
                | Q(uniprot_id__iexact=search)
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

    return render(request, "data/search.html", {'filter': fil, 'page_obj':page_obj,'page_obj_1':page_obj_1,
                                                'new_request': new_request, 'search':search})



@login_required
# Must be logged in as admin to access this page, returns an error otherwise
def data_upload(request):
    data = Htf.objects.all()
    prompt = {
        "Order": "Order of the CSV should be:"
                 "Ensemble ID, DBD, Gene name, Chromosome/scaffold name, "
                 "Gene start (bp), Gene end (bp), Strand, "
                 "UniProt ID, Protein names, Function [CC], Subcellular location [CC]"
    }
    # Order of csv file format required to populate database
    if request.method=="GET":
        return render(request, "data/data_upload.html", prompt)

    csv_file = request.FILES["file"]

    if not csv_file.name.endswith(".csv"):
        messages.error(request, "This is not a .csv file")

    data_set = csv_file.read().decode("UTF-8")
    # Read file, creates a data stream
    io_string = io.StringIO(data_set)
    # Can now use object in memory
    next(io_string)
    for column in csv.reader(io_string, delimiter='\t', quotechar="|"):
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
            sub_cell_location=column[10]
        )
        # Iterates through the original csv file, copies the data to the database
    context = {}
    return render(request, "data/data_upload.html", context)


