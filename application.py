from flask import Flask, render_template, g
import os

def create_app(test_config=None):
    # create and configure the app
    application = Flask(__name__, instance_relative_config=True)
    application.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(application.instance_path, 'htf.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        application.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        application.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(application.instance_path)
    except OSError:
        pass


    @application.route("/")
    def hello_world():
        return render_template("index.html")


    @application.route("/htf")
    def htf():
        return render_template("htf.html")


    @application.route("/drug")
    def drug():
        return render_template("drug.html")


    @application.route("/genexp")
    def genexp():
        return render_template("genexp.html")


    from . import db
    db.init_app(application)

    return application








