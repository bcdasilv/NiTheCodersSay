import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  String bio;
  String name;
  String profilePath;
  Profile(this.name, this.bio, this.profilePath);
}

class myProfileView extends StatelessWidget {

  Future<Profile> profile;

  var name = "";
  var bio = "";
  var profilePath = "";

  var client = http.Client();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

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
              name = snapshot.data.name;
              bio = snapshot.data.bio;
              profilePath = snapshot.data.profilePath;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: CircleAvatar(
                    backgroundImage: FileImage(File(profilePath)),
                      radius: 50,
                      backgroundColor: Colors.indigo,
                      //backgroundImage: AssetImage(''),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold)
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
                      bio,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text("Edit"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/editProfileView');
                      },
                    ),
                  ),
                ],
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

    var response = await http.get('http://jam.smpark.in/getProfile', headers: header);

    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    String path = prefs.get('profile_image');

    if(path == null) {
      print("Path is null");
      path = "";
    }

    Profile p = new Profile(jsonResponse['name'], jsonResponse['bio'], path);

    print(jsonResponse['bio']);

    return p;

  }

}


