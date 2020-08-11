# A models file with all fields to write models without much hassle
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test.db'
db = SQLAlchemy(app)

class MyTable(db.Model):
	id_field = db.Column(db.Integer, primary_key=True)
	string_field = db.Column(db.String(80), unique=True, nullable=False)
	date_field = db.Column(db.DateTime, nullable=False,default=datetime.utcnow)
	time_field = db.Column(db.Time, nullable=False,default=datetime.utcnow)
	date_time_field = db.Column(db.DateTime, nullable=False,default=datetime.utcnow)
	integer_field = db.Column(db.Integer)
	small_integer_field = db.Column(db.SmallInteger)
	boolean_field = db.Column(db.Boolean)
	unicode_field = db.Column(db.Unicode)
	pickletype_field = db.Column(db.PickleType)


