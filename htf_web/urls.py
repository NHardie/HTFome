"""htf_web URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include

# Add URL's here for whole website
# Empty path("", is the same as website.com/""
# Includes "data.urls" which is data/urls.py, go there next

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include("data.urls")),
]

urlpatterns += static(settings.MEDIA_URL,document_root = settings.MEDIA_ROOT)

# Allows us to upload geo data to the directory under MEDIA_ROOT and access via MEDIA_URL
# Found in settings.py