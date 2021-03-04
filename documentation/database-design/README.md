# 2.4. Database design

Our webapp required some method of storing data for the user to access through query requests. The data contained within are also relational, i.e. HTF targets and the drugs that target them, therefore a database written in SQL (Structured Query Language) seemed most appropriate for our needs. Although there are many SQL databases to choose from, we selected SQLite3. 

Python version 3 comes with SQLite built-in, and this database is used in many webapps written in Django or Flask. Typically SQLite will be used in development, then in production a database such as mySQL will be hosted on it’s own server for use. SQLite databases are seen as light-weight and less scalable, however their relatively small size allows them to be easily copied as a single file, useful for producing a webapp without a dedicated database server. 

Although SQLite is less secure, it’s easy to set up and perfect for our current needs as a small webapp/ prototype, however future development might see an increased requirement for database size and security, and so a separate SQL database hosted on it’s own server should be considered, a process often integrated with popular web-hosting services, such as AWS.
