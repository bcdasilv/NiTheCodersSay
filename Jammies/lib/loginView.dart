import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password/password.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class loginField extends StatefulWidget {
  @override
  loginFieldState createState() => loginFieldState();
}
//postLogin
/*
class loginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: loginFieldState()),
    );
  }
}
 */

class loginFieldState extends State<loginField> {

  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  String hashString = '';

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              width: 200,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 200,
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
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: TextFormField(
                        key: Key('email'),
                        validator: (value) {
                          if(value.length == 0) {
                            return "Please enter an email";
                          }
                          return null;
                        },
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    TextFormField(
                      key: Key('password'),
                      validator: (value) {
                        if(value.length == 0) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: RaisedButton(
                          key: Key('loginButton'),
                          child: Text("Login"),
                          onPressed: _submitForm,
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Need an account?',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );
  }

  _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      //final hash = Password.hash(passwordController.text, new PBKDF2());
      final hash = sha512.convert(utf8.encode(passwordController.text));

      hashString = "$hash";

      final response = await http.post(globals.server + '/login', body: { 'email': emailController.text, 'password': "$hash" } );

      if(response.statusCode == 200) {
        globals.id = await json.decode(response.body.replaceAll("'", '"'))['userid'];
        _getPhoto(globals.id);
        _saveCredentials();
        Navigator.pushNamedAndRemoveUntil(context, '/jam', (_) => false);
      }
      else {
        return Alert(context: context, title: "Login Unsuccessful").show();
      }
    }
    else {
      return Alert(context: context, title: "Please fill out the fields properly").show();
    }
  }

  _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('email', emailController.text);

    prefs.setString('password', hashString);

    print('saved email and password: ' + hashString);
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
}
