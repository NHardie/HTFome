from flask import Flask

application = Flask(__name__)

@application.route("/")
def hello_world():
    return "Hello World, this URL is complicated, but can be changed"
