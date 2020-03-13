import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class myProfileView extends StatelessWidget {

  var name = "";
  var bio = "";

  var client = http.Client();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    _getProfileInfo();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SafeArea(

      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
         Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: CircleAvatar(
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
            ),
      ),
    );
  }

  _getProfileInfo() async {

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    Map<String, String> header = {'email': email, 'password': password };

    var response = await http.get('http://jam.smpark.in/getProfile', headers: header);

    print(response.body);

    //var test = '{"bio": "Test bio","name": "Test Testington"}';
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    name = jsonResponse['name'];
    bio = jsonResponse['bio'];

    print(jsonResponse['bio']);

  }

}


