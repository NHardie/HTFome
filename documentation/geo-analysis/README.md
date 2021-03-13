# 2.5. GEO Analysis

The specifications for the application to fulfil were (QMUL, 2021): 

Build a web application that can be used to explore background information about human transcription factors and the genes they regulate.
Provide the user with background information about all known human transcription factors.
Provide the user with information about drugs that target human transcription factors.
Allow the user to upload gene expression data extracted from the (Gene Expression Omnibus) GEO database in (GEO DataSet) GDS format.

These specifications were met through the creation of a Shiny dashboard app, where the user can upload a GDS file of their choice, explore and interact with their data with various user parameters, and visualise their results graphically.

R Shiny apps have two main components: a user interface (UI) - that contains the elements that will be displayed to the user; and a server function - that contains the back-end code to process user requests (e.g. analysis, or instructions for when a user selects a UI parameter). Shiny apps also use reactive expressions that express server logic - its function is to specify instructions on what the app should do when an input changes (i.e. all related outputs are automatically updated). An in-depth guide to Shiny and its reactive expressions can be found here: https://mastering-shiny.org/. 

