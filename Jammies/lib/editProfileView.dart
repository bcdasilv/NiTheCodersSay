import 'package:Jammies/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';

class editProfileView extends StatefulWidget {
  @override
  editProfileState createState() => editProfileState();
}
class editProfileState extends State<editProfileView> {
  File file;

  void _choose() async {
    File f = await ImagePickerSaver.pickImage(source: ImageSource.gallery);
    setState(() {
      file = f;
      globals.profilePhoto = f;
      print(globals.profilePhoto);
    });
  }

  void _upload() async {

    // getting a directory path for saving
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print(path);
    // copy the file to a new path
    File newFile = await file.copy('$path/profile.png');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('profile_image', newFile.path);

    print("uploading to " + newFile.path);
    if (file == null) {
      print("Null file");
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');


    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var uri = Uri.parse('https://jam.smpark.in/upload');

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
  final bioController = new TextEditingController(text: globals.bio);
  final aboutController = new TextEditingController(text: globals.about);
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo,
                  backgroundImage: globals.profilePhoto == null
                      ? AssetImage( "assets/icon/icon.png")
                      : FileImage(globals.profilePhoto),
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _choose,
                        child: Text('Choose Profile Image'),
                      ),
                    ],
                  ),
                  globals.profilePhoto == null
                      ? Text('No Image Selected')
                      : Text('This is your choice')
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    child: Text(
                      "\n About Me\n",
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextFormField(
                  //inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(100)],
                  validator: (value) {
                    if(value.length == 0) {
                      return "Please enter an about me";
                    }
                    return null;
                  },
                  controller: aboutController,
                  obscureText: false,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Text(
                    "\nBio\n",
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                    Navigator.popUntil(context, ModalRoute.withName('/myProfileView'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitForm(BuildContext context) async {

    setState(() {
      globals.bio = bioController.text;
      globals.about = aboutController.text;
    });

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    final response = await http.post('https://jam.smpark.in/updateProfile', headers: { 'email': email, 'password': password },
        body: { 'bio': bioController.text, 'about_me': aboutController.text, 'pic_path': "" } );

    print(response.body + " " + response.statusCode.toString());

    await _upload();
  }
}



