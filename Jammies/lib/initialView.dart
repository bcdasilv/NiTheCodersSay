import 'package:flutter/material.dart';

class initialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 800,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: FittedBox(
                    fit: BoxFit.fill, // otherwise the logo will be tiny
                    child: Image.asset(
                      "assets/icon/icon.png",
                      height: 400,
                      width: 400,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
              )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  child: Text("Login"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  child: Text("Register"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    )
    );
  }
}