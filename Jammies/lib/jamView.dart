import 'package:Jammies/profileJamView.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//reference for swipe cards https://mightytechno.com/flutter-tinder-swipe-cards/

class ProfileCard {
  var name = '';
  var bio = '';
  File file;
  var marginTop;
  var id;

  ProfileCard(var Name, var Bio, File pic, var MarginTop, var Id) {
    name = Name;
    bio = Bio;
    file = pic;
    marginTop = MarginTop;
    id = Id;
  }

}

class jamView extends StatefulWidget {
  @override
  _JamView createState() => _JamView();
}

class _JamView extends State<jamView>  {
  List<Widget> cardList;
  var client = http.Client();


  Future<List<ProfileCard>> futureCards;
  List<ProfileCard> cards;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureCards = populateProfileCards();

  }

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
        body:
        Center(
          child: FutureBuilder<List<ProfileCard>>(
            future: futureCards,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cards = snapshot.data;
                cardList = tempMakeCardList();
                return Stack(alignment: Alignment.center, children: cardList);
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            }
        )
      )
    );
  }

  //populate cards with ProfileCards with data from server
  Future<List<ProfileCard>>populateProfileCards() async {

    List<ProfileCard> cards = new List<ProfileCard>();

    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    Map<String, String> header = {'email': email, 'password': password};

    var response = await http.get('http://jam.smpark.in/getNearby', headers: header);

    var idList = (jsonDecode(response.body) as List);

    print(response.body);
    print(idList);

    var name;
    var bio;

    for(int i = 0; i < idList.length; i++) {
      Map<String, String> header = {'email': email, 'password': password, 'userid':idList[i].toString()};

      var response = await http.get('http://jam.smpark.in/getProfile', headers: header);

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      name = jsonResponse['name'];
      bio = jsonResponse['bio'];

      print("User: " + name);
      print("email: " + email);
      print("id: " + idList[i].toString());

      cards.add(ProfileCard(name, bio, null, 30.0, idList[i]));

    }

    return cards;

  }

  //method to make ProfileCards then populate cardlist with ProfileCard objects
  List<Widget> tempMakeCardList() {

    List<Widget> cardList = new List();

    cardList.add(lastCard());


    for (int i = 0; i < cards.length; i++) {

      cardList.add(Positioned(
        top: cards[i].marginTop,

        child: Dismissible(
          key: Key(cards[i].name),
          background: slideRightBackground(cards[i].id),
          secondaryBackground: slideLeftBackground(),
          onDismissed: (direction) {
            if(direction == DismissDirection.endToStart) { //left
              print("left");
            } else if (direction == DismissDirection.startToEnd) { //right
              print("right");
              _sendMatch(cards[i].id);
            }
            cardList.removeLast();
          },
          child: Card(
            elevation: 12,
            color: Colors.lightBlue[50],
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(width: 300, height: 600, child: profileJamView(cards[i].name, cards[i].bio)),
          ),
        )
      ),
      );
    }

    return cardList;
  }

  Widget slideRightBackground(var id) {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.white,
                size: 300
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  _sendMatch(var id) async {
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email');
    String password = prefs.getString('password');

    Map<String, String> header = {'email': email, 'password': password};


    final response = await http.post('http://jam.smpark.in/match', headers: header, body: { 'matcher_email': email, 'matchee_id': id.toString() } );
    if(response.statusCode != 200) {
      return   Alert(context: context,
        type: AlertType.error,
        title: "Something went wrong :(",
        desc: "Try again later",
        buttons: [
        DialogButton(
        child: Text(
        "Ok",
        style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
        )
        ],
        ).show();
    }
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
                size: 300
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget lastCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.not_listed_location,
              color: Colors.indigo,
              size: 300
            ),
            Text(
              "There are no more people in your area."
                  "\nTry checking back later!",
                   textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],

    );
  }

}