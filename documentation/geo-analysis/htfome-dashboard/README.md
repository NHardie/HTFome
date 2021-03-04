# 2.5.1. HTFome Dashboard

The code for the HTFome dashboard app can be found here: https://github.com/NHardie/HTFome/tree/gds-r-dev. It can be accessed and run from the app.R file. However, as this file is quite large, the app.R file can be further split into its components: server.R, ui.R and global.R - where code for the server functions, UI and global scripts are stored, respectively. If all three R files (server, ui and global) are installed, the app can be run from any of these files.

The HTFome Dashboard is split up into several tab items:
Upload GDS File
Summary Statistics
Hierarchical Clustering Analysis
Principal Component Analysis
Differential Gene Expression Analysis
Estimate of HTF activity

Each of these tabs contain a sidebar panel, which provides the user various parameters to further explore their data; a main panel where visual outputs are presented once the data has been processed, and in some cases tab items (where visual outputs can be split up and viewed in a more orderly way).

Other UI elements include: a loading spinner (to indicate to the user that their data is being processed), validation controls (to let the user know what to do, e.g. upload a file or select certain parameters).

