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
        ButtonTheme(
          minWidth: 75.0,
          height: 0.0,
          child: RaisedButton(
            onPressed: () {},
            color: Colors.teal[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
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
