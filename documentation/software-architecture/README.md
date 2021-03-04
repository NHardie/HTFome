# 2. Software Architecture 

HTFome was developed using the Django framework, and R Shiny, hosted on an Amazon Web Services (AWS) Elastic Beanstalk (EB) server. 
The data used in the app was gathered through Application Programming Interface (API) calls to several large, established data repositories, 
and is stored locally via a SQLite3 database. An app user can access this data via the browser and view one of several web pages, 
displaying the data as a list, or click-through to see more specific detail about an individual HTF or drug of choice.


![HTF-web-project-Updated Software Architecture](https://user-images.githubusercontent.com/60273209/109990466-52a64600-7d01-11eb-84f6-7a6354a68996.png)
