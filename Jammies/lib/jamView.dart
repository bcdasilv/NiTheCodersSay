import 'package:flutter/material.dart';

class jamView extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Jam"),
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
        );
    }
}
