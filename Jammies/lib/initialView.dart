import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class initialView extends StatefulWidget {

  @override
  State createState() => new initialViewState();
}

class initialViewState extends State<initialView> {
  var prefs;

  @override
  void initState() {
    SharedPreferences.getInstance().then((result) {
      String email = result.getString('email');
      String password = result.getString('password');
      if (email != null && password != null) {
        http.post(globals.server + '/login', body: { 'email': email, 'password': password } ).then((response) {

          if(response.statusCode == 200) {
            globals.id = json.decode(response.body.replaceAll("'", '"'))['userid'];
            _getPhoto(globals.id);
            Navigator.pushNamedAndRemoveUntil(context, '/jam', (_) => false);
          }

        });
      }
    });
  }

  void _getPhoto(String id) async {
    var response = await http.get(globals.server + '/static/images/' + id);
    if (response.statusCode != 200) {
      return;
    }
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/profile.jpg';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    globals.profilePhoto = file2;
  }

//  String email = prefs.getString('email');
//  String password = prefs.getString('password');
//  print('saved email and password: ' + password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 800,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: FittedBox(
                    fit: BoxFit.fill, // otherwise the logo will be tiny
                    child: Image.asset(
                      "assets/icon/icon.png",
                      height: 400,
                      width: 400,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
              )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  key: Key('login'),
                  child: Text("Login"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  child: Text("Register"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    )
    );
  }
}