from flask import jsonify
'''
Note:
import app instance 
'''

@app.errorhandler(STATUS_CODE)
def function_name(error):
    context = something()
    return jsonify(context), STATUS_CODE

