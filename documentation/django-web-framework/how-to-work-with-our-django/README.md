# 2.2.2. How to work with our django

Developers should activate a virtual environment within the directory where they wish to instantiate their project, then download the Django package, or if continuing development, should activate their virtual environment and install the required packages found in the requirements.txt. 

Virtual environments allow developers to create isolated environments in which they can work on a specific project without any influence from the already installed packages on their machine. Standardisation of environments ensures all developers are using the same versions of languages and package versions, as well as avoiding any odd conflicts, or errors generated from multiple developers with separate environments working together. Simple instructions on the creation of virtual environments in Pycharm were written, and a requirements.txt was generated through the use of the command: 

`$ pip freeze > requirements.txt`

This copies all the installed packages and their current versions to the file requirements.txt. Once a virtual environment has been created and activated, the developer can then use the command:

`$ pip install -r requirements.txt`  

This installs all required packages of specific version, ensuring all developers are using the “same” environment. As the list of packages used grew, the requirements.txt was updated to reflect this.

Django development begins by running the command:

`$ django-admin startproject PROJECT_NAME`

Where PROJECT_NAME should be replaced by the desired project name. In the example of our group, this is “htf_web”. This will create the required Django files and folders, including a manage.py file, which is of great importance during development. The folder created will take the input name, i.e. /htf_web/, and will contain an __init__.py, allowing the project to be used as a package, a settings.py, containing project settings, a urls.py, which will contain website-wide urls, and two files which allow web apps written in python/ with python frameworks to communicate with compatible web servers: asgi.py and wsgi.py.

The manage.py file contains commands that can be run via the terminal, these include methods for running a development server locally, making database changes (migrations) and creating admin or superusers.

Following the startproject command, future development should continue through the creation of modular applications. This allows the developer to separate out different aspects of their website as they see fit, and also makes the reuse of code easier in the future. 

To create a new app, the developer runs the command:

`$ python manage.py startapp APP_NAME`

Where APP_NAME should be replaced as required. The chosen name should reflect the app's function. As our app is essentially a data repo, the name “data” was chosen (after checking there were no conflicts in naming convention, i.e. “test”). 
We could have seperated the app functions into smaller modules; an app for HTF data, one for drug data and one for GDS analysis, this would have the benefit of specifying the app functions, rather than having one app with a wider range. However the data used in this project are all related, so there is an argument that the apps should be combined to avoid replicating the database model code in each app. The app database models could be linked through import statements, however one of the benefits of modular development is the ability to copy an app across multiple projects, unless the developer is copying the database as well, this would sever the relationship between app and database (Here it is assumed the developer wants to copy the app exactly, however in reality the app would most-likely be chosen as a generic template for future development, and thus would be repurposed, with a new data set, changing variable names etc as necessary). 
For simplicity, one app was seen as sufficient, however for future development multiple, more focussed, apps could be beneficial.

The startapp command creates a subdirectory (called APP_NAME) of the project directory. The startapp command will create several template files and a migrations subdirectory. The migrations subdirectory will contain database migrations, i.e. the way a django developer updates the database objects. The files created include: __init__.py, allowing the use of the app as a package, admin.py, allowing the creation of admin profiles for the app, apps.py which contains the app data for use in the project-level settings.py file and tests.py, a specific file for development testing. The startapp command also creates two additional files, which will be discussed in more detail: views.py and models.py.
