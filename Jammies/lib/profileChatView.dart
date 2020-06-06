import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';

class profileChatView extends StatelessWidget {
  var name = '';
  var bio = '';
  var about = '';
  var id = 0;

  var client = http.Client();

  profileChatView(this.name, this.bio, this.id, this.about);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(name + "'s Profile"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigo,
                      backgroundImage: NetworkImage(
                          globals.server + '/static/images/' +
                              id.toString()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("About Me\n",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      about,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nBio\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
