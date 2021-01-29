from flask import Flask, render_template, g

application = Flask(__name__)


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


if __name__ == "__main__":
    application.run()