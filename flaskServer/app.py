from flask import *
from flask_sqlalchemy import SQLAlchemy
from flask_api import status
import os
import hashlib
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = '/home/smparkin/uploads/'

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://'+os.getenv('MYSQL_USER')+':'+os.getenv('MYSQL_PASS')+'@localhost/jammies'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
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

@app.route('/upload', methods=["POST"])
def upload():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)

    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    try:
        image = request.files['file']
        filename = secure_filename(email)
        image.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return Response("{'status':'Saved image'}", status=200, mimetype='application/json')
    except:
        return Response("{'error':'Unable to save image'}", status=420, mimetype='application/json')


@app.route('/download', methods=["GET"])
def download():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)

    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    try:
        filename = os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(email))
        return send_file(filename, mimetype='image/jpg')
    except:
        return Response("{'error':'Unable to retrieve image'}", status=420, mimetype='application/json')


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

    valid = verify(email, password)

    if (valid):
        return Response("{'status':'Valid email and password'}", status=200, mimetype='application/json')
    return Response("{'error':'Not valid email or password'}", status=401, mimetype='application/json')


def verify(email, password):
    user = Users.query.filter_by(email=email).first()
    if user == None:
        return False
    if (password == user.password):
        return True
    return False


@app.route('/updateProfile', methods=["POST"])
def updateProfile():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)
    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    if request.json != None:
        data = request.json
    else:
        data = request.form

    try:
        about_me = data['about_me']
        bio = data['bio']
        pic_path = data['pic_path']
        #spotify_key = data['spotify_key']
        #soundcloud_key = data['soundcloud_key']
    except:
        return Response("{'error':'Not all Profile fields provided'}", status=400, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')

    profile = Profiles.query.filter_by(id=user.id).first()
    if profile == None:
        return Response("{'error':'No such profile'}", status=422, mimetype='application/json')

    profile.about_me = about_me
    profile.bio = bio
    profile.pic_path = pic_path
    #profile.spotify_key = spotify_key
    #profile.soundcloud_key = soundcloud_key

    db.session.commit()
    return Response("{'status':'Profile updated in db'}", status=200, mimetype='application/json')


@app.route('/getProfile', methods=["GET"])
def getProfile():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)
    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')

    profile = Profiles.query.filter_by(id=user.id).first()
    if profile == None:
        return Response("{'error':'No such profile'}", status=422, mimetype='application/json')

    name = user.name
    #about_me = profile.about_me
    bio = profile.bio
    return jsonify(name=name, bio=bio)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)


def helloPeril():
    return True