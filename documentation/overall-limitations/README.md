# 3. Overall Limitations

HTFome is limited mostly by the database. Firstly, we’re not fully utilising the relational nature of the data and SQL’s handling of these relationships due to only relating the data in the webpage views/ HTML. While this works well for the design of our data input, future developers would require lots more instruction regarding the correct file format for the uploading of new data to the database. 

Secondly, the database upload method isn’t as straight-forward as desired, although it functions, uploading requires the correct file manipulation process and is somewhat arbitrary, requiring lots of steps to instantiate a new database correctly. 

Thirdly, the SQLite database hasn’t been stress tested, either for many users, or for lots more data. It works well in development, but if the database or users grow there may be issues with speed of access.
 
