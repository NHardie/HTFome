from django.urls import path
from . import views

# Start from htf_web/urls.py
# Input routes there cover whole website
# Url's here cover the data app
# Each path referrs to website.com/""
# So website.com/ = views.home
# website.com/htf = views.htf
# Go to views.py next


urlpatterns = [
    path('', views.home, name="home"),
    path('htf/', views.htf, name="htf"),
    path('drug/', views.drug, name="drug"),
    path('genexp/', views.genexp, name="genexp"),

]