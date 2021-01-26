# bioinfo-group-project


Little Flask Blog, called flaskr

Installation

Download the flaskr.zip

Extract to somewhere memorable, make a directory/venv for flaskr, if anything goes wrong can delete and try again.

In terminal, cd to flaskr/

$ ls

Should show: 

documentation.txt  instance     __pycache__  tutorial_full.txt
flaskr             manifest.in  setup.py     venv


Then:

$ pip install -e
If you don't have pip installed, then install pip, the -e tells it to install the setup.py file, should install in dev mode, but not sure, the . means current directory.

flaskr should install the required dependancies


Then: 
$ export FLASK_APP=flaskr
$ export FLASK_ENV=development
$ flask run

Should see this:

 * Serving Flask app "flaskr" (lazy loading)
 * Environment: development
 * Debug mode: on
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with inotify reloader
 * Debugger is active!
 * Debugger PIN: 106-787-297


Now if you open http://localhost:5000/ in your browser of choice, you should see a little flask website

