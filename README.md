README.md
# bioinfo-group-project
Group project for Bioinformatics masters degree


## Future reference 

### Website development


#### Root

Within the root directory for the project there are several directories and files. 

.ebextensions: elastic beanstalk config files, can also set commands here to be run upon deployment to AWS elastic beanstalk

.gitignore: File telling github which files to allow to be committed and pushed to github

db.sqlite3: database file, contains actual data, this shouldn't be pushed to github, should be uploaded to AWS elastic beanstalk seperately, or hosted on a seperate database server

manage.py: Allows user to run django commands in the command line, such as runserver, makemigrations etc

Future applications should be generated as normal in Django using the command: startapp app_name, this command must be run from the directory containing the manage.py file

requirements.txt: pip install -r requirements.txt will install all required packages/ dependancies to further develop the webapp, add to this file by installing required packages then using pip freeze > requirements.txt to ensure all developers are using same packages.
(This should be performed in a virtual environment)


Creation of further applications/ webpages/ HTML templates etc follows normal Django development guidelines.


#### htf_web

Start in htf_web, this is the main folder containing the "website" (The Django project)

Settings.py contains settings for overall website, any future apps must be referenced in settings, Debug mode should be False in production, but True in development.

If website is moved from hosting on AWS, the allowed_urls in settings must include the new hosting URL.

urls.py contains the urls for the website, must add any new app urls in this file, and reference the app correctly.

ASGI and WSGI settings are found in their respective .py files, shouldn't need changing.


#### Webapp development, data

Current app is called data, existing in the data directory within the group project directory.

Within this app directory are multiple subdirectories: migrations (Database data), templates (HTML), usually with Django app's there would be a static (.css/ .js) subdirectory within the app directory, however this subdirectory has been moved into the root directory to allow AWS Elastic Beanstalk to interact with it appropriately.

During development, this directory can be placed back into the data directory, however the Django environment in AWS Elastic Beanstalk will struggle to find this directory, so it should be placed in the root directory for production. 

There is an init.py allowing the data app to be referenced as a package

admin.py sets up the admin page, comes as standard with Django, can be useful in creating test data for a database

apps.py must contain the name of the app, i.e. data/apps.py must contain the name of the data app. This file must then be referenced in settings.py under allowed_apps.

filters.py is a file used by the django_filters package, allows the creation of filter forms, to make website searches simple.

models.py contains the database models (tables), add new models here to generate new database objects, then instantiate them using makemigrations and migrate commands.

tests.py should contain any development tests required.


#### data/urls.py

One of the most important files, urls.py contains the url patterns/paths for the app to match and link users to the correct HTML template


#### data/views.py

Another crucial file, this is where the views (webpages) are created. Each view contains python functions/ classes which generate objects which the HTML template can then utilise. Various data manipulations can be performed here, to then output something for the user.


#### data/templates/data/*.html

These HTML files are the templates which the views link to, these are what actually displays a webpage to the user. The views must render these templates, and the urls must point to them. Hence the urls, views and templates are all connected.


