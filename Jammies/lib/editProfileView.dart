import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class editProfileView extends StatefulWidget {
  @override
  editProfileState createState() => editProfileState();
}
class editProfileState extends State<editProfileView> {
  File file;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _upload() async {
    print("uploading: ");
    if (file == null) {
      print("Null file");
      return;
    }

    print(file.path
        .split("/")
        .last);

    String fileName = file.path
        .split("/")
        .last;

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');


    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var uri = Uri.parse('http://jam.smpark.in/upload');

    var request = new http.MultipartRequest("POST", uri);

    Map<String, String> header = {'email': email, 'password': password};

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));

    print("File size: " + length.toString());

    request.files.add(multipartFile);
    request.headers.addAll(header);
    var response = await request.send();
    print(response.statusCode);

  }

  var bio = "";
  final _formKey = GlobalKey<FormState>();
  final bioController = new TextEditingController();
/*
  void initState() {
    bioController.text = bio;
    return super.initState();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: Column(
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
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _choose,
                      child: Text('Choose Image'),
                    ),
                  ],
                ),
                file == file
                    ? Text('No Image Selected')
                    : Image.file(file) // This doesn't work
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "\nBio\n",
                  style: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                //inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(100)],
                  validator: (value) {
                    if(value.length == 0) {
                      return "Please enter a bio";
                    }
                    return null;
                  },
                  controller: bioController,
                  obscureText: false,
              ),
            ),
      Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          child: Text("Submit"),
          color: Colors.teal[300],
          onPressed: () {
            _submitForm(context);
            Navigator.pushNamed(context, '/myProfileView');
          },
        ),
      ),
          ],
        ),
      ),
    );
  }

  _submitForm(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    final response = await http.post('http://jam.smpark.in/updateProfile', headers: { 'email': email, 'password': password },
        body: { 'bio': bioController.text, 'about_me': "", 'pic_path': "" } );

    print(response.body + " " + response.statusCode.toString());

    Navigator.pushNamed(context, '/myProfileView');

    _upload();

  }

  _getProfileInfo() async {

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    Map<String, String> header = {'email': email, 'password': password };

    //var response = await http.get('http://jam.smpark.in/getProfile', headers: header);

    //print(response.body);

    var test = '{"bio": "Test bio","name": "Test Testington"}';
    Map<String, dynamic> jsonResponse = jsonDecode(test);

    bioController.text = jsonResponse['bio'];

    print(jsonResponse['bio']);

  }

}


_getName()  {
  return 'Chloe';
}

_getBio()  {
  return 'bio here';
}



