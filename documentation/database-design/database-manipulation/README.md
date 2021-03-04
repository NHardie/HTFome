# 2.4.1. Database Manipulation 

models.py

In Django, the models.py contains the database schema for the various database objects available to the webapp, in our example we made one model to handle HTF data, and one model for drug data. 


```
/models.py

class Drug(models.Model):
#Set Drug as a model
   
   drug_name = models.TextField(default='N/A')
   #Set drug_name as a model text field, no max limit of characters like            
   #with a CharField, default value to ‘N/A’ if no input

   trade_name = models.TextField(default='N/A')
   drug_chembl_id = models.TextField(default='N/A')
   year_approved = models.TextField(default='N/A')
```

Here we set the database object ‘Drug’ as a class, with the required fields as TextField and the default value of ‘N/A’. 
Other field types are available, such as numerical, character (accept all characters but with a maximum length), datetime etc.

ForeignKey fields can be used if one model belongs to another model, as in ‘Car’ and ‘Car Manufacturer’, OneToOne and ManyToMany fields can be used as well to map out database relationships, or these relationships can be produced manually in the views.py. Which method is best depends on how the data is gathered/ uploaded to the database, and also what is the most simple. For our needs it was easier to produce the relationships manually in the views/ HTML pages than to alter the data input. 

Once models have been set, Django has a specific set of commands related to updating the database. Firstly the database being used must be referenced in the settings.py.

```
/settings.py

DATABASES = {
   'default': {
       'ENGINE': 'django.db.backends.sqlite3',
       'NAME': BASE_DIR / 'db.sqlite3',
   }
}
```
Then the user must make the SQL for the models they’ve specified. 

`$ python manage.py makemigrations APP_NAME`

This command translates the simple changes made in the models.py to SQL, and also creates the database tables for any Django apps (such as admin features) which come as standard in Django.

The user must add their app to the settings.py list of installed apps, then can run:

`$ python manage.py migrate`

This will create the database tables for the user app models by applying the SQL changes to the database.

For HTFome, database changes are performed via two html pages, one for the HTF data, and one for the drug data. For security these are not linked on any of the webpages, and require admin permissions to access. Creation of an admin is performed via the command:

`$ python manage.py createsuperuser`

A new superuser can be created locally, or via SSH into the Elastic Beanstalk instance. 
If only a small number of changes are required, this can be performed manually through the admin page of the website: /admin/, this however is prohibitively slow and not recommended for batch updates.

The developer must then execute the commands:

`$ python manage.py makemigrations`

`$ python manage.py migrate`

To then confirm the migrations.

The developer can then start their local server, log in as admin via the admin page localhost:8000/admin, then upload the htf data localhost:8000/htf_data_upload, and drug data localhost:8000/drug_data_upload. 

The data provided should take 3 to 4 minutes to upload, and the developer will see a POST request message in their terminal when complete.  

```/views.py

@login_required
#Must be logged in as admin to access this page, returns an error otherwise
def drug_data_upload(request):
   data = Drug.objects.all()
   prompt = {
       "Order": "Order of the CSV should be:"     
    "drug name, drug Trade names, drug chembl id, "
                "drug approval date"
   }
   #Order of csv file format required to populate database
   if request.method=="GET":
       return render(request, "data/drug_data_upload.html", prompt)

   csv_file = request.FILES["file"]

   if not csv_file.name.endswith(".csv"):
       messages.error(request, "This is not a .csv file")

   data_set = csv_file.read().decode("UTF-8")
   #Read file, creates a data stream
   io_string = io.StringIO(data_set)
   #Can now use object in memory
   next(io_string)
   #Skip header row
   for column in csv.reader(io_string, delimiter='\t', quotechar="|"):
       if len(column) >= 4:
       #Had to include this, to avoid index out of range errors
           _, created = Drug.objects.update_or_create(
               drug_name=column[0],
               trade_name=column[1],
               drug_chembl_id=column[2],
               year_approved=column[3]
           )
       #Iterates through the original csv file, copies the data to the       
       #database
   context = {}
   return render(request, "data/drug_data_upload.html", context)
```

This view simply takes an input .csv file and using the update_or_create function overwrites the current database object column by column. The column headers here should be the same as those in the models.py. 

Note that if replacing the database entirely the developer will have to delete the db.sqlite3 file as well as any migrations in the app/migrations directory, then perform the steps above to create the migrations, apply the migrations and create a superuser before logging in as an admin via the /admin page, and then uploading the new drug and HTF databases via /drug_data_upload and /htf_data_upload. If using this method both the database tables will be wiped, so both must be reuploaded. This particular aspect to the web app is especially in need of further development, as it works, but not ideally.

One issue is the data input must be in the .csv format, however, multiple columns have commas within them, so the data must be arranged tab-separated, then saved with a .csv suffix, leading to files in the formal “htf_data.tsv.csv”. Using a .tsv for the upload seems to add quotation marks around the data content (On a Linux machine, windows might handle this differently), this introduces errors when using the data as hyperlinks. 
