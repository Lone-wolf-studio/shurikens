from flask import Flask, request, jsonify
import json


app = Flask(__name__)

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





