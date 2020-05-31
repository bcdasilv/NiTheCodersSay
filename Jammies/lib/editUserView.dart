import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Jammies/globals.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:crypto/crypto.dart';

class User {
  String name = '';
  String email = '';
  String username = '';
  String zipcode = '';
  String dob = '';
  User(this.name, this.email, this.username, this.zipcode, this.dob);
}

class editUserView extends StatefulWidget {
  @override
  _EditUserView createState() => _EditUserView();
  }

class _EditUserView extends State<editUserView> {

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  var emailController = TextEditingController();
  var zcController = TextEditingController();
  var nameController = TextEditingController();
  var userNameController = TextEditingController();
  var dateController = TextEditingController(text: 'No date selected');
  Future<User> user;

  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    user = _getUserInfo();
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal Info"),
          actions: <Widget>[
            IconButton(
              icon: globals.profilePhoto == null
                  ? FadeInImage(
                  image: NetworkImage(globals.server + '/static/images/' + globals.id), placeholder: AssetImage("assets/icon/icon.png")
              )
                  : Image.file(globals.profilePhoto),
              iconSize: 50,
            ),
          ],
        ),
        body: SafeArea(
          child: FutureBuilder<User>(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
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
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0, top: 50.0),
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
                              child: TextFormField(
                                validator: (value) {
                                  if(selectedDate == null) {
                                    return 'Please select a date';
                                  }
                                  return null;
                                },
                                controller: dateController,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Date of birth',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: RaisedButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                color: Colors.teal[300],
                                child: Text('Select Date',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: RaisedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            content: Stack(
                                                overflow: Overflow.visible,
                                                children: <Widget>[
                                                  Positioned(
                                                      right: -40.0,
                                                      top: -40.0,
                                                      child: InkResponse(
                                                          onTap: () {
                                                            passwordController.text = '';
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: CircleAvatar(
                                                            child: Icon(Icons.close),
                                                            backgroundColor: Colors.red,
                                                          )
                                                      )
                                                  ),
                                                  Form(
                                                      key: _formKey1,
                                                      child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Padding(
                                                                padding: EdgeInsets.all(4.0),
                                                                child: Text( "Change Your Password",
                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                                                )
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets.all(4.0),
                                                                child: TextFormField(
                                                                  decoration: const InputDecoration(
                                                                    icon: Icon(Icons.vpn_key),
                                                                    hintText: 'Password',
                                                                    labelText: 'Password',
                                                                  ),
                                                                  onSaved: (String value) {
                                                                    // This optional block of code can be used to run
                                                                    // code when the user saves the form.
                                                                  },
                                                                  obscureText: true,
                                                                  maxLines: 1,
                                                                  validator: (String value) {
                                                                    return value.isEmpty ? 'A password is required' : null;
                                                                  },
                                                                  textCapitalization: TextCapitalization.sentences,
                                                                  controller: passwordController,
                                                                )
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.all(4.0),
                                                              child: TextFormField(
                                                                decoration: const InputDecoration(
                                                                  icon: Icon(Icons.vpn_key),
                                                                  hintText: 'Confirm Password',
                                                                  labelText: 'Confirm Password',
                                                                ),
                                                                obscureText: true,
                                                                onSaved: (String value) {
                                                                  // This optional block of code can be used to run
                                                                  // code when the user saves the form.
                                                                },
                                                                validator: (String value) {
                                                                  if(value.compareTo(passwordController.text) != 0) {
                                                                    return "The passwords do not match";
                                                                  }
                                                                  return null;
                                                                },
                                                                textCapitalization: TextCapitalization.sentences,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RaisedButton(
                                                                  child: Text("Submit"),
                                                                  color: Colors.deepPurple,
                                                                  textColor: Colors.white,
                                                                  onPressed: () {
                                                                    if (_formKey1.currentState.validate()) {
                                                                      _changePassword(context, passwordController.text);
                                                                      Alert(
                                                                        context: context,
                                                                        title: 'Password Changed Sucessfully',
                                                                        buttons: [
                                                                          DialogButton(
                                                                            color: Colors.deepPurple,
                                                                            child: Text(
                                                                              "OK",
                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                            ),
                                                                            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/editUser')),
                                                                          )
                                                                        ],
                                                                      ).show();
                                                                    }
                                                                  },
                                                                )
                                                            )
                                                          ]
                                                      )
                                                  )
                                                ]
                                            )
                                        );
                                      }
                                    );
                                  },
                                color: Colors.deepPurpleAccent,
                                child: Text('Change Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: RaisedButton(
                                key: Key('register'),
                                color: Colors.indigo,
                                child: Text("Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    key: Key('registerText')),
                                onPressed: () {
                                  _submitForm(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            return Center(child: CircularProgressIndicator());
      })),
    ));
  }

  Future<User> _getUserInfo() async {

    var prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    Map<String, String> header = {'email': email, 'password': password };

    var response = await http.get(globals.server + '/getUser', headers: header);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    globals.email = jsonResponse['name'];
    globals.username = jsonResponse['username'];
    globals.zipcode = jsonResponse['zipcode'];
    globals.dob = jsonResponse['dob'];
    globals.name = jsonResponse['name'];

    await prefs.setString('email', emailController.text);

    emailController.text = globals.email;
    zcController.text = globals.zipcode;
    nameController.text = globals.name;
    userNameController.text = globals.username;
    dateController.text = globals.dob;

    User u = new User(globals.name, globals.email, globals.username, globals.zipcode, globals.dob);;

    return u;
  }

  _submitForm(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> header = {'email': globals.email, 'password': prefs.getString('password')};

    final response = await http.post('http://159.89.150.59:8080/updateUser', headers: header, body:
    { 'email': emailController.text, 'name': nameController.text,
      'zipcode': zcController.text, 'dob': dateController.text, 'username': userNameController.text} );

    if(response.statusCode == 200) {
      return Alert(context: context, title: 'Information successfully changed').show();
    } else if (response.statusCode == 409) {
      return Alert(context: context, title: 'Email already taken', desc: 'No data was changed').show();
    } else if (response.statusCode == 423) {
      return Alert(context: context, title: 'Zipcode is not valid', desc: 'No data was changed').show();
    } else {
      return Alert(context: context, title: response.body).show();
    }
  }

   _changePassword(BuildContext context, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final hash = sha512.convert(utf8.encode(newPassword));
    String hashString = "$hash";
    Map<String, String> header = {'email': globals.email, 'password': prefs.getString('password')};

    final response = await http.post('http://159.89.150.59:8080/updateUser',
        headers: header, body:
    { 'email': globals.email, 'password': hashString, 'name': globals.name,
      'zipcode': globals.zipcode, 'dob': '2019-07-19', 'username': globals.username} );

    if(response.statusCode == 200) {
      await prefs.setString('password', hashString);
    }
    else {
      return Alert(context: context, title: response.body).show();
    }
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate == null ? DateTime.now(): selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

}