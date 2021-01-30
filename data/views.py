from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

# From data/urls.py
# Views = webpages
# Each function defines what to do when the url referenced in data/urls.py
# is accessed with a http request
# In these examples, each request to the function returns an httpResponse
# these are wrapped in <h1></h1> tags, meaning page headers
# Route is as follows:
# htf_web/urls.py -> data/urls.py -> views.py


def home(request):
    # define the function to deal with home receiving a request
    return HttpResponse("<h1>Home</h1>")
    # A request returns a HTTPResponse

def htf(request):
    return HttpResponse("<h1>HTF</h1>")

def drug(request):
    return HttpResponse("<h1>DRUG</h1>")

def genexp(request):
    return HttpResponse("<h1>GENE EXPRESSION</h1>")