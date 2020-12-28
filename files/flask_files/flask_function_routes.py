from flask import Flask, request, jsonify
import json


app = Flask(__name__)

# fetching configuration based on FLASK_ENV environment
'''
Exporting FLASK_ENV option
export FLASK_ENV=development
export FLASK_ENV=production
'''
if app.config["ENV"] == "production":
    app.config.from_object("config.ProductionConfig")
else:
    app.config.from_object("config.DevelopmentConfig")

@app.route("/")
def change_this(methods=["GET"]):
    return "get call"

@app.route("/")
def change_this_too(methods=["POST"]):
    return "post call"

@app.route("/")
def change_this_one_too(methods=["PUT"]):
    return "put call"

@app.route("/")
def change_this_as_well(methods=["DELETE"]):
    return "delete call"


if __name__ == "__-main__":
    app.run(debug=True, host='0.0.0.0', port=8000)





