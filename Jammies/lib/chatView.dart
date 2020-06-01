import 'package:Jammies/profileChatView.dart';
import 'package:Jammies/profileJamView.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'globals.dart';

class chatView extends StatefulWidget {
  @override
  _ChatView createState() => _ChatView();
}

class _ChatView extends State<chatView> {
  Future<List<Widget>> futureNames;

  List<Widget> names;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureNames = _getMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: <Widget>[
          IconButton(
            icon: globals.profilePhoto == null
                ? FadeInImage(
                image: NetworkImage(
                    globals.server + '/static/images/' + globals.id),
                placeholder: AssetImage("assets/icon/icon.png"))
                : Image.file(globals.profilePhoto),
            iconSize: 50,
            onPressed: () {
              Navigator.pushNamed(context, '/myProfileView');
            },
          ),
        ],
      ),
      body: Center(
          child: FutureBuilder<List<Widget>>(
              future: futureNames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  names = snapshot.data;
                  return ListView(
                      children: names
                  );
                }
                return Center(child: CircularProgressIndicator());
              })),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail_outline,
              color: Colors.purpleAccent,
            ),
            title: Text(
              'Chat',
              style: TextStyle(color: Colors.purpleAccent),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.music_note,
              color: Colors.indigo,
            ),
            title: Text(
              'Jam',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.indigo,
            ),
            title: Text(
              'Discover',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/chat', (_) => false);
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/jam', (_) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/discover', (_) => false);
    }
  }

  Future<List<Widget>> _getMatches() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String password = prefs.getString('password');
    List<String> matchedNames = new List<String>();
    List<Widget> cardList = List<Widget>();

    Map<String, String> header = {'email': email, 'password': password};
    final response = await http.get(
      globals.server + '/getMatches',
      headers: header,
    );

    var idList = (jsonDecode(response.body) as List);

    for (int i = 0; i < idList.length; i++) {
      Map<String, String> header = {
        'email': email,
        'password': password,
        'userid': idList[i].toString()
      };

      var response = await http.get(globals.server + '/getProfile', headers: header);

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      matchedNames.add(jsonResponse['name']);
      print(jsonResponse['name']);
      cardList.add(
        Card(
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: FadeInImage(
                      image: NetworkImage(
                          globals.server + '/static/images/' + idList[i].toString()),
                      placeholder: AssetImage("assets/icon/icon.png")),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return profileChatView(jsonResponse['name'], jsonResponse['bio'],
                              idList[i],jsonResponse['about_me']);
                        },
                        fullscreenDialog: true
                    ));
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(
                  jsonResponse['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                    Text(
                      'No conversation yet',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return cardList;
  }
}


