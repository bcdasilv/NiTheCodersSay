from flask import *
from flask_sqlalchemy import SQLAlchemy
from flask_api import status
import os
import hashlib

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://'+os.getenv('MYSQL_USER')+':'+os.getenv('MYSQL_PASS')+'@localhost/jammies'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Profiles(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    about_me = db.Column(db.String(140))
    bio = db.Column(db.String(1000))
    pic_path = db.Column(db.String(1000))
    spotify_key = db.Column(db.Integer)
    soundcloud_key = db.Column(db.Integer)

    def __init__(self):
        self.about_me = None
        self.bio = None
        self.pic_path = None
        self.spotify_key = None
        self.soundcloud_key = None

class Users(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(30), unique=True)
    username = db.Column(db.String(20))
    password = db.Column(db.String(128))
    zipcode = db.Column(db.String(5))
    dob = db.Column(db.Date)
    name = db.Column(db.String(100))

    def __init__(self, email, username, password, zipcode, dob, name):
        self.email = email
        self.username = username
        self.password = password
        self.zipcode = zipcode
        self.dob = dob
        self.name = name

    def __repr__(self):
        return '<User %r>' % self.id

@app.route('/register', methods=["POST"])
def register():
    if request.json != None:
        data = request.json
    else:
        data = request.form
    try:
        email = data['email']
        username = data['username']
        password = data['password']
        zipcode = data['zipcode']
        dob = data['dob']
        name = data['name']
    except:
        return Response("{'error':'Not all fields provided'}", status=400, mimetype='application/json')

    exists = db.session.query(db.exists().where(Users.email == email)).scalar()
    if exists:
        return Response("{'error':'User exists'}", status=422, mimetype='application/json')

    newuser = Users(email, username, password, zipcode, dob, name)
    newprofile = Profiles()
    db.session.add(newprofile)
    db.session.commit()
    db.session.add(newuser)
    db.session.commit()
    return Response("{'status':'User added to db'}", status=200, mimetype='application/json')

@app.route('/login', methods=["POST"])
def login():
    if request.json != None:
        data = request.json
    else:
        data = request.form
    try:
        email = data['email']
        password = data['password']
    except:
        return Response("{'error':'Not all fields provided'}", status=400, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')
    if (password == user.password):
        return Response("{'status':'Valid email and password'}", status=200, mimetype='application/json')
    return Response("{'error':'Not valid password'}", status=401, mimetype='application/json')

if __name__ == '__main__':
    app.run()
