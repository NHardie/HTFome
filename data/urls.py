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
    path('htf/<str:gene_name>/', views.htf_detail, name="detail"),
    # Allows the action of clicking through to a specific HTF with the url of htf/gene_name/
    path('drug/', views.drug, name="drug"),
    path('drug/<str:drug_name>/', views.drug_detail, name="detail"),
    path('genexp/', views.genexp, name="genexp"),
    path('download/', views.download, name="download"),
    path('about/', views.about, name="about"),
    path('help/', views.help, name="help"),
    path('documentation/', views.documentation, name="documentation"),
    path('htf_search/', views.htf_search, name="search_results"),
    path('drug_search/', views.drug_search, name="search_results"),
    path('htf_data_upload/', views.htf_data_upload, name='htf_data_upload'),
    path('drug_data_upload/', views.drug_data_upload, name='drug_data_upload')

]