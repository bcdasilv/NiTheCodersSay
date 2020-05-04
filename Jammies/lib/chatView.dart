import 'package:Jammies/profileJamView.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class chatView extends StatefulWidget {
    @override
    _ChatView createState() => _ChatView();
}

class _ChatView extends State<chatView>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Chat"),
                actions: <Widget>[
                    IconButton(
                        icon: Image.asset('assets/icon/icon.png'),
                        iconSize: 50,
                        onPressed: () {
                            Navigator.pushNamed(context, '/myProfileView');
                        },
                    ),
                ],
            ),
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
}
