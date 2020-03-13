import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'discoverView.dart';

class registerField extends StatefulWidget {
  @override
  registerFieldState createState() => registerFieldState();
}
//postLogin
/*
class loginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: loginFieldState()),
    );
  }
}
 */

class registerFieldState extends State<registerField> {

  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final zcController = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final userNameController = TextEditingController();

  DateTime date1;

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register"),
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
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(100)],
                        validator: (value) {
                          if(value.length == 0) {
                            return "Please enter a name";
                          }
                          return null;
                        },
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(20)],
                        validator: (value) {
                          if(value.length == 0) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                        controller: userNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(30)],
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if(value.compareTo(passwordController.text) != 0) {
                            return "The passwords do not match";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Re-enter password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if(value.length != 5) {
                            return "Zipcode is incorrect length";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5)],
                        obscureText: false,
                        controller: zcController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Zip Code',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: DateTimePickerFormField(
                        controller: dateController,
                        inputType: InputType.date,
                        format: DateFormat("yyy-MM-dd"),
                        editable: false,
                        decoration: InputDecoration(
                            labelText: 'Date of birth',
                            hasFloatingPlaceholder: false
                        ),
                        onChanged: (dt) {
                          setState(() => date1 = dt);
                          print('Selected date: $date1');
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: RaisedButton(
                        child: Text("Register new account"),
                        onPressed: _submitForm,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Already have an account?',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: RaisedButton(
                        child: Text("Login"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
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

  // email<30 password zipcode(5) dob("yyyy-mm-dd") name(string)<100
  _submitForm() async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      //final hash = Password.hash(passwordController.text, new PBKDF2());
      final hash = sha512.convert(utf8.encode(passwordController.text));

      final response = await http.post('http://jam.smpark.in/register', body:
      { 'email': emailController.text, 'password': "$hash", 'name': nameController.text,
      'zipcode': zcController.text, 'dob': dateController.text, 'username': userNameController.text} );

      if(response.statusCode == 200) {
        Navigator.pushNamed(context, '/discover');
      }
      else {
        return Alert(context: context, title: response.body).show();
      }
    }
    else {
      return Alert(context: context, title: "Please fill out the fields properly").show();
    }
  }

}
