import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'globals.dart';

class Profile {
  String bio = "";
  String name = "";
  String about = "";
  Profile(this.name, this.bio, this.about);
}

class myProfileView extends StatefulWidget {
  @override
  _MyProfileView createState() => _MyProfileView();
}

class _MyProfileView extends State<myProfileView> {

  Future<Profile> profile;

  var client = http.Client();

  @override
  Widget build(BuildContext context) {
    profile = _getProfileInfo();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SafeArea(

      child: FutureBuilder<Profile>(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              globals.name = snapshot.data.name;
              if (snapshot.data.bio != null) {
                globals.bio = snapshot.data.bio;
              }
              if (snapshot.data.about != null) {
                globals.about = snapshot.data.about;
              }
              return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.indigo,
                          backgroundImage: globals.profilePhoto == null
                            ? AssetImage( "assets/icon/icon.png")
                            : FileImage(globals.profilePhoto),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                            globals.name,
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "About Me\n",
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          globals.about,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Bio\n",
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          globals.bio,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          key: Key('editProfile'),
                          color: Colors.indigo,
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfileView').then((value) {
                              setState(() {
                                globals.bio = globals.bio;
                                globals.about = globals.about;
                              });
                            });;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          color: Colors.teal,
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _logout();
                          },
                        ),
                      ),
                    ],
                  ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }))
    );
  }

  Future<Profile> _getProfileInfo() async {

    var prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    Map<String, String> header = {'email': email, 'password': password };

    print('sending get profile request');
    var response = await http.get(globals.server + '/getProfile', headers: header);

    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    Profile p = new Profile(jsonResponse['name'], jsonResponse['bio'], jsonResponse['about_me']);

    return p;

  }

  void _logout() async {
    globals.profilePhoto = null;
    globals.bio = '';
    globals.name= '';
    globals.about= '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }
}


