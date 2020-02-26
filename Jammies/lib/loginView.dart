import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password/password.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
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
                            child: const FlutterLogo(),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: TextFormField(
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
                    RaisedButton(
                      child: Text("Login"),
                      onPressed: _submitForm,
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

      final response = await http.post('http://jam.smpark.in/login', body: { 'email': emailController.text, 'password': "$hash" } );

      if(response.statusCode == 200) {
        Scaffold
            .of(context)
            .showSnackBar(SnackBar(content: Text('Login successful')));
      }
      else {
        Scaffold
            .of(context)
            .showSnackBar(SnackBar(content:
              Text('Incorrect email or password')));
      }
    }
    else {
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('fill out fields properly')));
    }
  }

}
