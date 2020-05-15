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
  var postid, title, author, authorid, time, content;
  Post(
      {this.postid,
      this.title,
      this.author,
      this.authorid,
      this.time,
      this.content});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postid: json['postid'],
        title: json['title'],
        author: json['author'],
        authorid: json['authorid'],
        time: json['time'],
        content: json['content']);
  }
}

class _DiscoverView extends State<discoverView> {
  var client = http.Client();

  Future<List<Post>> futurePosts;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  //List<Post> posts;

  //List<Widget> postList = makePostList();
/*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePosts = populatePosts();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discover'), actions: <Widget>[
        IconButton(
          icon: globals.profilePhoto == null
              ? Image.asset('assets/icon/icon.png')
              : Image.file(globals.profilePhoto),
          iconSize: 50,
          onPressed: () {
            Navigator.pushNamed(context, '/myProfileView');
          },
        ),
      ]),
      body: Center(
        child: ListView(children: makePostList()),
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
                            padding: EdgeInsets.all(8.0),
                            child: Text( "Make a Post",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
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
                            padding: EdgeInsets.all(8.0),
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
                              minLines: 2,
                              maxLines: null,
                              controller: bodyController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Submit"),
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

    var uri = Uri.parse('http://jam.smpark.in/makePost');

    Map<String, String> header = {'email': email, 'password': password};



    final response = await http.post('http://jam.smpark.in/login',
        headers: header,
        body: { 'title': titleController.text, 'body': bodyController.text } );
    print(response.statusCode);
  }

  List<Post> populatePosts() {
    List<Post> posts = [];
    //example json placeholder
    var response = """
        {"posts":[
           {
              "postid":1,
              "title":"Title",
              "author":"A person",
              "authorid":1,
              "time":"2012-04-23 18:25:43",
              "content":"Here is some sample text for the post with multiple lines so you see more when expanding"
           },
           {
              "postid":2,
              "title":"Title 2",
              "author":"A person 2",
              "authorid":2,
              "time":"2012-04-23 18:25:43",
              "content":"Here is some moresample text for the post with multiple lines so you see more when expanding"         
          }      
      ]
    }
""";

    //final response = await http.get('http://jam.smpark.in/getPosts');
    //var postList = (jsonDecode(response.body) as List);
//
    Map<String, dynamic> postListResponse = json.decode(response);
    var postList =
        postListResponse['posts'].map((value) => Post.fromJson(value)).toList();
    print(postList);
    for (var i = 0; i < postList.length; i++) {
      var currPost = postList[i];
      print(currPost);
      posts.add(currPost);
    }

    return posts;
  }

  List<Widget> makePostList() {
    List<Post> posts = populatePosts();
    List<Widget> postList = List();

    for (var i = 0; i < posts.length; i++) {
      var currPost = posts[i];
      postList.add(
        Card(
          child: ExpandableNotifier(
            child: ScrollOnExpand(
              child: ExpandablePanel(
                header: Text(
                  currPost.title,
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
        ),
      );
    }

    return postList;
  }
}
