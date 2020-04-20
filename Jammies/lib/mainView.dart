import 'package:flutter/material.dart';
import 'chatView.dart';
import 'jamView.dart';
import 'discoverView.dart';

class mainView extends StatefulWidget {
  mainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<mainView> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/chat');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/jam');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/discover');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jammies'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

    );
  }
}