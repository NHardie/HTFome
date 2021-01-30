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


#def home(request):
    # define the function to deal with home receiving a request
    #return HttpResponse("<h1>Home</h1>")
    # A request returns a HTTPResponse

def home(request):
    # Define function, what to do when a request comes
    return render(request, "data/home.html")
    # return render of template located in data/templates/data/home.html

def htf(request):
    return render(request, "data/htf.html")

def drug(request):
    return render(request, "data/drug.html")

def genexp(request):
    return render(request, "data/genexp.html")