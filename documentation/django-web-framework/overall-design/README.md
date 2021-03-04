# 2.2.1. Overall design

The general software structure is represented below, the initial idea was to have a home page that users would “land” on, a search page specifically for HTF’s, a search page specifically for drugs, and access to an analysis page for GDS data. 

Some slight modifications were included during development. We originally just wanted the user to be able to click on an HTF/ drug and receive more details, specifically those of biological significance, but during development we decided to also link the HTF/ drug to the original database for even more information, for example the details page for each HTF contains a link to the page for that HTF on Ensemble (for gene data) and Uniprot (for protein product data).

![HTF-web-project-Site-map](https://user-images.githubusercontent.com/60273209/109991030-db24e680-7d01-11eb-8b78-b8ef60b14cdf.png)

Figure 2: Site map.

We also decided to include a data upload page, accessible by an administrator only, this page allows the admin/  superuser to upload a new database to the website remotely and securely. 

We determined that use of a web-hosting platform such as AWS EB would be beneficial, and we connected our Github repo to the EB environment using AWS CodePipeline, automatically deploying/ redeploying our web app when the “Main” branch of the repo was updated via a pull request/ merge. This allowed backend and frontend changes to be viewed live in mere minutes, and encouraged many small updates to the “Main” branch, rather than fewer, larger updates. Although not necessarily the best practice professionally, this helped tremendously with troubleshooting, as any changes that introduced bugs were limited in their size and scope, allowing more rapid fixes. 

With the added benefit of hindsight, having a main production branch and a separate testing branch, each hosted on their own servers would have been good practice, however the limited time and experience only made this apparent late in development. 

AWS EB requires users to set up an environment relevant to their webapp, for example, Django apps have their own package requirements, as do Flask apps. The user determines the server they require, typically Linux, and what language they require, in this instance Python. The user then uploads their initial app along with a requirements.txt containing the packages required. This is then deployed to the AWS cloud, and can be accessed through the browser with the designated URL. 
