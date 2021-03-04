# 2.2.4. How to develop further

Further development of HTFome will mostly include adding more web apps/ pages, greater functionality and improving upon the database design. 

Adding web apps/ pages requires some knowledge of Django development, but generally follows a standard workflow:

Create the new web app as described above
Add the web app to the list of installed apps in /settings.py

```/settings.py

INSTALLED_APPS = [
   'django.contrib.admin',
   'django.contrib.auth',
   'django.contrib.contenttypes',
   'django.contrib.sessions',
   'django.contrib.messages',
   'django.contrib.staticfiles',
   'htf_web',
   'data.apps.DataConfig',
   'django_filters',
]
```
For our project we added the htf_web project and django_filters to allow use of these as packages. The main app “data” is added by the line 'data.apps.DataConfig'. The DataConfig file is a part of the data app, so Django treats this app as installed without the need to specify it. 

Add the app to the project-level /urls.py

```/urls.py

urlpatterns = [
   path('admin/', admin.site.urls),
   path('', include("data.urls")),
]
```
For HTFome, we added the URL’s for the data app to the path following an empty string. Typically a developer will create a urls.py file within the app directory, then link the project urls.py to the app name, providing some additional modularity to the django app. If the website is very simple, then the desired URL could be provided straight to the project-level /urls.py

Add required app URL’s for web pages to the app/urls.py (data/urls.py)

```data/urls.py

urlpatterns = [
   path('', views.home, name="home"),
   #path('path to be used as url/', views. view function name, view name)
   
   path('htf/', views.htf, name="htf"),
   path('htf/<str:gene_name>/', views.htf_detail, name="detail"),
   #Allows the action of clicking through to a specific HTF with the url of  # htf/gene_name/
... ]
```
The url patterns allow the developer to select what URL should be linked to which view, and allow the addition of subsequent variables to be passed to the URL, as in our example above, a user who clicks on a specific HTF link for more detail will be sent to a unique URL containing the HTF’s gene symbol.

Write the view/s for the web page/s

A webapp’s views can be described as the backend equivalent of the webpage the user sees when they access a URL. The view.py in Django will include a list of instructions for the webapp to execute when a user accesses a certain webpage. A very simple example is a home page function, which displays a HTML (Hypertext Markup Language) header as a response to a HTTP (Hypertext Transfer Protocol) request:

```/views.py

def home(request):
   #define the function to deal with home receiving a request
   return HttpResponse("<h1>Home</h1>")
   #A request returns a HTTPResponse
```
Through the use of different Django functions, these views can be made more complex:

```/views.py

def home(request):
   #Define function, what to do when a request comes
   return render(request, "data/home.html", {'title': 'The Human Transcription
   Factor Database'})
#return render of template located in data/templates/data/home.html, pass	
#title variable to html page
```
Here the view returns an HTML page template, with a dictionary object containing a variable that’s passed to the template, and can be accessed within the HTML through use of Django’s DTL (Django Template Language). A similar language, Jinja2, used by Flask is originally modelled on DTL, so some experience with one informs the other. Usage and benefits of template languages are discussed below. 

Views can also incorporate database objects, and functions from various packages, these require importing in the /views.py file, as is standard in Python:

```/views.py

def htf(request):
all_htfs = Htf.objects.all().order_by('gene_name')
#This is the model (database table) containing the HTF's, we take the table 
#of all the HTF's and order them alphabetically by gene_name

paginator = Paginator(all_htfs, 15)
#This is the Paginator function working on the HTF list, displaying 15 per page

page_number = request.GET.get('page')
#Need to know the page_number, i.e. page 1, 2, 3...

page_obj = paginator.get_page(page_number)
#This releases a page object for us to use in the html template
#page_object contains the list of HTF's for each page.

return render(request, "data/htf.html", {'page_obj': page_obj, 'title': 'HTF Search'})
#Add a dictionary containing htf's as a page object, can now display on html page
```
This function defines the output for the /htf/ url. The view takes a database model object, in alphabetical order by the field gene_name, then paginates these data in groups of 15. For the ability to switch between pages, a GET request is required to inform which page the user is currently on. A final function allows the view to access a specific page, given it’s number. 
We return the render of htf.html, and a dictionary containing the page_obj and title, for use in the HTML. 

Use of HTML templates in Django relies upon the views, the views rely on the URL’s. 
Views can be written as functions or as classes, for simplicity we chose to write our views as functions, however class views could be incorporated in later development to avoid code replication. 

Write the HTML templates for each web page

As mentioned, Django has an in-built template language, allowing a developer more control over how to present their data on the web. Generally it is good practice to separate the HTML templates by app, in our case: /data/templates/data/base.html.

This base.html is used as the standard template, setting the design of the other templates. These other templates then “extend” the base.html. Objects from the views can be utilised in the HTML through use of double curly-braces {{ }}, and simple code can be executed by use of curly-braces with percentage signs {% %}.

```
{% for htf in htfs %}
    {{ htf.gene_name }}
{% endfor %} 
```
Test

Once a view has been created, the HTML written, and the URL specified, the developer should then test their changes. In Django, this is completed by using the python command:

`$ python manage.py runserver`

This should be executed with the virtual environment activated.
This command will start an instance of the Django project, hosting the website locally. Developers will often be checking their code changes, and during development it’s useful to turn debug mode on (True) in the /settings.py file. This aids debugging, as error messages will be shown to the developer in the browser. Debug mode should be turned off (False) during production however.
