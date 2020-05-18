import 'package:Jammies/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class registerField extends StatefulWidget {
  @override
  registerFieldState createState() => registerFieldState();
  registerField({Key key, this.title}) : super(key: key);

  final String title;
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
  final userNameController = TextEditingController();
  final dateController = TextEditingController(text: 'No date selected');

  DateTime selectedDate;

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

  _saveCredentials() async {
    final hash = sha512.convert(utf8.encode(passwordController.text));
    String hashString = "$hash";
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('email', emailController.text);

    prefs.setString('password', hashString);

    print('saved email and password: ' + hashString);
  }

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
                          key: Key('register'),
                          color: Colors.indigo,
                        child: Text("Register new account",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            key: Key('registerText')),
                        onPressed: () {
                            _saveCredentials();
                            _submitForm(context);
                        },
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
  _submitForm(BuildContext context) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      //final hash = Password.hash(passwordController.text, new PBKDF2());
      final hash = sha512.convert(utf8.encode(passwordController.text));

      print("${selectedDate.toString()}".split(' ')[0]);
      final response = await http.post('http://jam.smpark.in/register', body:
      { 'email': emailController.text, 'password': "$hash", 'name': nameController.text,
      'zipcode': zcController.text, 'dob': "${selectedDate.toString()}".split(' ')[0], 'username': userNameController.text} );

      if(response.statusCode == 200) {
        _runPrompts(context);
      }
      else {
        return Alert(context: context, title: response.body).show();
      }
    }
    else {
      return Alert(context: context, title: "Please fill out the fields properly").show();
    }
  }

  void _runPrompts(BuildContext context) {
    Navigator.pushAndRemoveUntil (
      context,
      MaterialPageRoute(
        builder: (context) => aboutMePrompt(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}

class aboutMePrompt extends StatelessWidget {
  final aboutController = new TextEditingController(text: 'This is a quick description of myself');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell us a little about yourself'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: RaisedButton(
                child: Text('Skip'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => bioPrompt(),
                      // Pass the arguments as part of the RouteSettings. The
                    ),
                  );
                },
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text(
                "\nAbout Me\n",
                style: TextStyle(fontWeight: FontWeight.bold)
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
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              child: Text("Submit",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.indigo,
              onPressed: () {
                globals.about = aboutController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => bioPrompt(),
                    // Pass the arguments as part of the RouteSettings. The
                  ),
                );
              },
            ),
          ),
        ]
       )
    );
  }
}

class bioPrompt extends StatelessWidget {
  final bioController = new TextEditingController(text: 'This is a long description of myself');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tell us about yourself'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: RaisedButton(
                      child: Text('Skip'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => photoPrompt(),
                            // Pass the arguments as part of the RouteSettings. The
                          ),
                        );
                      },
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: Text(
                    "\nBio\n",
                    style: TextStyle(fontWeight: FontWeight.bold)
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
                  child: Text("Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.indigo,
                  onPressed: () {
                    globals.bio = bioController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => photoPrompt(),
                        // Pass the arguments as part of the RouteSettings. The
                      ),
                    );
                  },
                ),
              ),
            ]
        )
    );
  }
}

class photoPrompt extends StatefulWidget {
  @override
  photoPromptState createState() => photoPromptState();
}
class photoPromptState extends State<photoPrompt> {

  File file;

  void _choose() async {
    File f = await ImagePickerSaver.pickImage(source: ImageSource.gallery);
    setState(() {
      file = f;
      globals.profilePhoto = f;
      print(globals.profilePhoto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tell us about yourself'),
        ),
        body: Column(
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
                        : Text('This is your choice') // This doesn't work
                  ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  child: Text("Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.indigo,
                  onPressed: () {
                    _submitProfileData(context);
                    Navigator.pushNamedAndRemoveUntil(context, '/jam', (_) => false);
                  },
                ),
              ),
            ]
        )
    );
  }

  _submitProfileData(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    final response = await http.post('http://jam.smpark.in/updateProfile', headers: { 'email': email, 'password': password },
        body: { 'bio': globals.bio, 'about_me': globals.about, 'pic_path': "" } );

    print(response.body + " " + response.statusCode.toString());

    await _upload(context);
  }

  void _upload(BuildContext context) async {

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
}
