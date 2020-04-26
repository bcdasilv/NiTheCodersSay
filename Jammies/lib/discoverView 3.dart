import 'package:flutter/material.dart';

class discoverView extends StatefulWidget {
  @override
  _DiscoverView createState() => _DiscoverView();
}

class _DiscoverView extends State<discoverView>{

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Discover"),
                actions: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/icon/icon.png'),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.pushNamed(context, '/myProfileView');
                    },
                  ),
                ]
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
}
