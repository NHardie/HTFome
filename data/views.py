from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def home(request):
    return HttpResponse("<h1>Home</h1>")

def htf(request):
    return HttpResponse("<h1>HTF</h1>")

def drug(request):
    return HttpResponse("<h1>DRUG</h1>")

def genexp(request):
    return HttpResponse("<h1>GENE EXPRESSION</h1>")