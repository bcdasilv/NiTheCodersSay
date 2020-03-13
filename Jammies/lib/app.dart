import 'package:Jammies/editProfileView.dart';
import 'package:flutter/material.dart';
import 'chatView.dart';
import 'jamView.dart';
import 'loginView.dart';
import 'registerView.dart';
import 'discoverView.dart';
import 'initialView.dart';
import 'myProfileView.dart';

class JamFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JamFinder',
      theme: ThemeData(
//        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => initialView(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/discover': (context) => discoverView(),
        '/login': (context) => loginField(),
        '/register': (context) => registerField(),
        '/jam': (context) => jamView(),
        '/chat': (context) => chatView(),
        '/myProfileView': (context) => myProfileView(),
        '/editProfileView': (context) => editProfileView(),
      },
    );
  }
}

class JamFinderTabView extends StatefulWidget {
  JamFinderTabView({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _JamFinderTabViewState createState() => _JamFinderTabViewState();
}

class _JamFinderTabViewState extends State<JamFinderTabView> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    chatView(),
    jamView(),
    discoverView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JamFinder'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text('Jam'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Discover'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
