from flask import *
from flask_sqlalchemy import SQLAlchemy
from flask_api import status
import os
import hashlib
from zipcode_distance import *
from werkzeug.utils import secure_filename
from datetime import datetime

UPLOAD_FOLDER = '/home/smparkin/NiTheCodersSay/flaskServer/static/images'

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://'+os.getenv('MYSQL_USER')+':'+os.getenv('MYSQL_PASS')+'@localhost/jammies'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
db = SQLAlchemy(app)

class Matchings(db.Model):
    matcherId = db.Column(db.Integer, primary_key=True)
    matcheeId = db.Column(db.Integer, primary_key=True)

    def __init__(self, matcher, matchee):
        self.matcherId = matcher
        self.matcheeId = matchee

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

class Posts(db.Model):
    postId = db.Column(db.Integer, primary_key=True)
    profileId = db.Column(db.Integer, db.ForeignKey('profiles.id'), nullable=False)
    postDateTime = db.Column(db.DateTime, nullable=False)
    postTitle = db.Column(db.String(50), nullable=False)
    postBody = db.Column(db.Text, nullable=True)

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



@app.route('/match', methods=["POST"])
def match():
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
        matcher = data['matcher']
        matchee = data['matchee']
    except:
        return Response("{'error':'Not all fields provided'}", status=400, mimetype='application/json')

    match = Matchings.query.filter_by(matcherId=matcher).filter_by(matcheeId=matchee).first()
    if match == None:
        newMatch = Matchings(matcher, matchee)
        db.session.add(newMatch)
        db.session.commit()
        return Response("{'status':'Added to db'}", status=200, mimetype='application/json')
    else:
        return Response("{'error':'Match already in db'}", status=418, mimetype='application/json')


@app.route('/getMatches', methods=["GET"])
def getMatches():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)

    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')

    matchedWithUser = Matchings.query.filter_by(matcheeId=user.id).all()

    matchList = []
    for i in matchedWithUser:
        userMatched = Matchings.query.filter_by(matcherId=user.id).filter_by(matcheeId=i.matcherId).first()
        if userMatched != None:
            matchList.append(i.matcherId)

    return jsonify(matchList)


@app.route('/makePost', methods=["POST"])
def makePost():
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
        postTitle = data['title']
        postBody = data['body']
    except:
        return Response("{'error':'Not all fields provided'}", status=400, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')

    newPost = Posts(profileId=user.id, postDateTime=datetime.now(), postTitle=postTitle, postBody=postBody)
    db.session.add(newPost)
    db.session.commit()
    return Response("{'status':'Added to db'}", status=200, mimetype='application/json')


@app.route('/getPost', methods=["GET"])
def getPost():
    email = request.headers['email']
    password = request.headers['password']
    try:
        startid = request.headers['startid']
    except:
        startid = 0

    valid = verify(email, password)

    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')


    jsonResponse = '{ "posts": [ '
    postList = list(reversed(Posts.query.all()))
    for i in range(startid, startid+9):
        if i == len(postList):
            listJson = list(jsonResponse)
            print(listJson)
            listJson[-2] = ''
            jsonResponse = "".join(listJson)
            break
        jsonResponse += '{ "postid": "' + str(postList[i].postId) + '", "title": "' + postList[i].postTitle + '", "authorid": "' + str(postList[i].profileId) + '", "time": "' + str(postList[i].postDateTime) + '", "content": "' + postList[i].postBody + '" }'
        if i != startid+8:
            jsonResponse += ', '
    jsonResponse += '] }'
    return Response(jsonResponse, status=200, mimetype='application/json')


@app.route('/', methods=["GET", "POST"])
def home():
    message = "Hello there"
    return render_template('index.html', message=message)


@app.route('/upload', methods=["POST"])
def upload():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)

    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    try:
        image = request.files['file']
        filename = secure_filename(str(user.id))
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

    user = Users.query.filter_by(email=email).first()
    try:
        filename = os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(str(user.id)))
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
        return Response("{'error':'not all data provided'}", status=400, mimetype='application/json')

    exists = db.session.query(db.exists().where(Users.email == email)).scalar()
    if exists:
        return Response("{'error':'User exists'}", status=422, mimetype='application/json')

    newuser = Users(email, username, password, zipcode, dob, name)
    newprofile = Profiles()
    db.session.add(newprofile)
    db.session.commit()
    db.session.add(newuser)
    db.session.commit()
    user = Users.query.filter_by(email=email).first()
    return Response("{'userid':'"+str(user.id)+"'}", status=200, mimetype='application/json')


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

    user = Users.query.filter_by(email=email).first()

    if (valid):
        return Response("{'userid':'"+str(user.id)+"'}", status=200, mimetype='application/json')
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
        bio = data['bio']
        pic_path = data['pic_path']
        about_me = data['about_me']
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
    try:
        userid = request.headers['userid']
    except:
        userid = None

    valid = verify(email, password)
    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    if userid == None:
        user = Users.query.filter_by(email=email).first()
    else:
        user = Users.query.filter_by(id=userid).first()

    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')

    profile = Profiles.query.filter_by(id=user.id).first()
    if profile == None:
        return Response("{'error':'No such profile'}", status=422, mimetype='application/json')

    name = user.name
    about_me = profile.about_me
    bio = profile.bio
    return jsonify(name=name, about_me=about_me, bio=bio)

    def distance(zip1, zip2):
        z1 = select_zipcode(zip1)
        z2 = select_zipcode(zip2)
        if not (z1) or not (z2):
            return None
        return haversine(z1['lat'], z1['long'], z2['lat'], z2['long'])

@app.route('/getNearby', methods=["GET"])
def getNearby():
    email = request.headers['email']
    password = request.headers['password']

    valid = verify(email, password)
    if not valid:
        return Response("{'error':'Incorrect email or password'}", status=401, mimetype='application/json')

    user = Users.query.filter_by(email=email).first()
    if user == None:
        return Response("{'error':'No such user'}", status=422, mimetype='application/json')

    userZipcode = user.zipcode

    #Var to control how many people are shown to the user
    nearbyLimit = 50

    #Get people in the same zipcode as user first in a list
    sameZipcode = Users.query.filter(Users.zipcode.like(userZipcode), Users.id != user.id).all()

    #Get same zipcode people's id in result list
    res = []
    count = 0
    for person in sameZipcode:
        if count < nearbyLimit:
            res.append(person.id)
            count+=1
        else:
            break

    #Look at other zipcodes if limit not reached
    if count != nearbyLimit:

        #Filter people already in res
        #Can also filter_by zipcode!=userZipcode instead
        otherZipcode = Users.query.filter(Users.id.notin_(res), Users.id != user.id).limit(nearbyLimit-count).all()

        #Array of tuples: (id, distance)
        temp = []
        for person in otherZipcode:
            #Stephen's distance function goes below with args: user.zipcode and person.zipcode
            dist = distance(userZipcode, person.zipcode)
            if dist != None:
                temp.append((person.id, dist))

        #Sort based on distance and add to result list
        temp.sort(key=lambda x: x[1])
        res+= [i[0] for i in temp]

    return jsonify(res)



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
