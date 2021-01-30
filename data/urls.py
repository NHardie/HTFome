from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name="home"),
    path('htf/', views.htf, name="htf"),
    path('drug/', views.drug, name="drug"),
    path('genexp/', views.genexp, name="genexp"),

]