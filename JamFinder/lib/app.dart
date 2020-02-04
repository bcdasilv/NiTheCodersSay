import 'package:flutter/material.dart';
import 'chatView.dart';
import 'jamView.dart';
import 'discoverView.dart';

class JamFinderApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'JamFinder',
            theme: ThemeData(
                primarySwatch: Colors.indigo,
            ),
            home: JamFinderTabView(title: 'JamFinder'),
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
    static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    static const List<Widget> _widgetOptions = <Widget>[
        Text(
            'Index 0: Chat',
            style: optionStyle,
        ),
        Text(
            'Index 1: Jam',
            style: optionStyle,
        ),
        Text(
            'Index 2: Discover',
            style: optionStyle,
        ),
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
