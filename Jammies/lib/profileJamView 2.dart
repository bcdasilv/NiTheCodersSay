import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class profileJamView extends StatelessWidget {

  var name="";
  var bio="";
  var id;

  var client = http.Client();

  profileJamView(this.name,this.bio);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
              child: Center(
                  child: new Container(
                      width: 190.0,
                      height: 190.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg")
                          )
                      )),
                  )
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                    name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)
                ),
              )
            ),
            Divider(

            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Bio\n",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio ?? '',
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

}


