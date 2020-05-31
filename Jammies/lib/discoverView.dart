import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'package:expandable/expandable.dart';

class discoverView extends StatefulWidget {
  @override
  _DiscoverView createState() => _DiscoverView();
}

class Post {
  var postid, title, authorid, time, content, author;
  Post(
      {this.postid,
      this.title,
      this.authorid,
      this.time,
      this.content,
      this.author});


  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postid: json['postid'],
        title: json['title'],
        authorid: json['authorid'],
        time: json['time'].split(' ')[0],
        content: json['content'],
        author: 'author');
  }
}

class _DiscoverView extends State<discoverView> {
  var client = http.Client();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discover'), actions: <Widget>[
        IconButton(
          icon: globals.profilePhoto == null
              ? FadeInImage(
                image: NetworkImage(globals.server + '/static/images/' + globals.id), placeholder: AssetImage("assets/icon/icon.png")
              )
              : Image.file(globals.profilePhoto),
          iconSize: 50,
          onPressed: () {
            Navigator.pushNamed(context, '/myProfileView');
          },
        ),
      ]),
      body: Center(
        child: FutureBuilder<List<Post>>(
      future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            posts = snapshot.data;
            postList = makePostList();
            return ListView(children: postList);
          }
          return CircularProgressIndicator();
        },
      ),
      ),
      floatingActionButton: FloatingActionButton(
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
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        )
                      )
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text( "Make a Post",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.title),
                                hintText: 'Title',
                                labelText: 'Title',
                              ),
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                              validator: (String value) {
                                return value.isEmpty ? 'Post must have a title' : null;
                              },
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              controller: titleController,
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.text_fields),
                                hintText: 'Body',
                                labelText: 'Body',
                              ),
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                              validator: (String value) {
                                return null;
                              },
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              controller: bodyController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Submit"),
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  post();
                                  Navigator.of(context).pop();
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
        child: Icon(Icons.mail),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail_outline,
              color: Colors.indigo,
            ),
            title: Text(
              'Chat',
              style: TextStyle(color: Colors.indigo),
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
              color: Colors.purpleAccent,
            ),
            title: Text(
              'Discover',
              style: TextStyle(color: Colors.purpleAccent),
            ),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    print(index);
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/chat', (_) => false);
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/jam', (_) => false);
    } else if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/discover', (_) => false);
    }
  }

  void post() async {
    print("Title: " + titleController.text);
    print("Body: " + bodyController.text);

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    var uri = Uri.parse(globals.server + '/makePost');

    Map<String, String> header = {'email': email, 'password': password};



    final response = await http.post(globals.server + '/makePost',
        headers: header,
        body: { 'title': titleController.text, 'body': bodyController.text } );
    print(response.statusCode);
    print(response.body);
  }

  Future<List<Post>> populatePosts() async{
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');
    Map<String, String> header = {'email': email, 'password': password};
    List<Post> posts = [];

    final response = await http.get(globals.server + '/getPost', headers: header);
    Map<String, dynamic> postListResponse = json.decode(response.body);
    var postList = postListResponse['posts'].map((value) => Post.fromJson(value)).toList();

    for (var i = 0; i < postList.length; i++) {
      Post currPost = postList[i];
      Map<String, String> header = {
        'email': email,
        'password': password,
        'userid': currPost.authorid.toString()
      };
      var response = await http.get(globals.server + '/getProfile', headers: header);

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      currPost.author = jsonResponse['name'];

      posts.add(currPost);
    }

    return posts;
  }

  List<Widget> makePostList() {
    List<Widget> postList = List();
    for (var i = 0; i < posts.length; i++) {
      var currPost = posts[i];
      postList.add(
        Card(
          child: Column(
            children: <Widget>[
          Container(
            height: 100,
            width: 150,
            child: FadeInImage(
              image: NetworkImage(globals.server + '/static/images/' + currPost.authorid.toString()), placeholder: AssetImage("assets/icon/icon.png"),
              fit: BoxFit.scaleDown,
            ),
          ),
          ExpandableNotifier(
            child: ScrollOnExpand(
              child: ExpandablePanel(
                header:
                Text(
                  currPost.title+'\n'+ currPost.author +
                      ', ' +
                      currPost.time,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                collapsed: Text(
                  currPost.content,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Text(
                  currPost.content,
                  softWrap: true,
                ),
              ),
            ),
          ),

          ],
        ),

        ),
      );
    }
    return postList;
  }
}
