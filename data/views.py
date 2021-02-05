from django.shortcuts import render
from django.db.models import Q
from django.http import HttpResponse
from .models import Htf, Drug

# Create your views here.

# From data/urls.py
# Views = webpages
# Each function defines what to do when the url referenced in data/urls.py
# is accessed with a http request
# In these examples, each request to the function returns an httpResponse
# these are wrapped in <h1></h1> tags, meaning page headers
# Route is as follows:
# htf_web/urls.py -> data/urls.py -> views.py


# def home(request):
    # define the function to deal with home receiving a request
    # return HttpResponse("<h1>Home</h1>")
    # A request returns a HTTPResponse

htfdata = [
    {
        "ID": "HTF1",
        "Family": "HTF_family_1",
        "Location": "HTF_Location_1",
    },
    {
        "ID": "HTF2",
        "Family": "HTF_family_2",
        "Location": "HTF_Location_2",
    }
]


def home(request):
    # Define function, what to do when a request comes
    return render(request, "data/home.html", {'title': 'The Human Transcription Factor Database'})
    # return render of template located in data/templates/data/home.html

def htf(request):
    context = {
        "htfs": Htf.objects.all()
    }
    # Add a dictionary containing htf's, can now display on html page
    return render(request, "data/htf.html", context) # TODO: Fix title

def drug(request):
    return render(request, "data/drug.html", {'title': 'Drug Search'})

def genexp(request):
    return render(request, "data/genexp.html", {'title': 'GEO Analyser'})

def download(request):
    return render(request, "data/download.html", {'title': 'Download'})

def about(request):
    return render(request, "data/about.html", {'title': 'About'})

def help(request):
    return render(request, "data/help.html", {'title': 'Help'})

def documentation(request):
    return render(request, "data/documentation.html", {'title': 'Documentation'})

def search(request):
    if request.method == "GET":
        search = request.GET.get("q")
        htf = Htf.objects.all().filter(
            Q(name__icontains=search) | Q(gene_id__icontains=search)
            | Q(gene_symbol__icontains=search) | Q(family__icontains=search)
            | Q(cell_location__icontains=search) | Q(gene_regulation__icontains=search)
        )
        return render(request, "data/search.html", {"htf":htf})
