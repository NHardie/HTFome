from django.urls import path
from . import views

# Start from htf_web/urls.py
# Input routes there cover whole website
# URLs here cover the data app
# Each path refers to website.com/""
# So website.com/ = views.home
# website.com/htf = views.htf
# Go to views.py next


urlpatterns = [
    path('', views.home, name="home"),
    path('htf/', views.htf, name="htf"),
    path('htf/<str:gene_name>/', views.detail, name="detail"),
    path('drug/', views.drug, name="drug"),
    path('genexp/', views.genexp, name="genexp"),
    path('download/', views.download, name="download"),
    path('about/', views.about, name="about"),
    path('help/', views.help, name="help"),
    path('documentation/', views.documentation, name="documentation"),
    path('search/', views.search, name="search_results"),
    path('data_upload/', views.data_upload, name="data_upload"),
]