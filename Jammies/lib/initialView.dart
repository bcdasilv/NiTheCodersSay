import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;


class initialView extends StatefulWidget {

  @override
  State createState() => new initialViewState();
}

class initialViewState extends State<initialView> {
  var prefs;

  @override
  void initState() {
    SharedPreferences.getInstance().then((result) {
      print("email" + result.getString('email'));
      String email = result.getString('email');
      String password = result.getString('password');
      if (email != null && password != null) {
        http.post('http://jam.smpark.in/login', body: { 'email': email, 'password': password } ).then((response) {

          if(response.statusCode == 200) {
            Navigator.pushNamedAndRemoveUntil(context, '/jam', (_) => false);
          }

        });
      }
    });
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