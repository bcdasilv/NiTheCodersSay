import 'package:flutter/cupertino.dart';
import 'styles.dart';
import 'ChatView.dart';
import 'JamView.dart';
import 'DiscoverView.dart';

class JamFinderApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return CupertinoApp(
            home: JamFinderHome(),
        );
    }
}

class JamFinderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.conversation_bubble),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_note),
            title: Text('Jam'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location),
            title: Text('Discover'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ChatView(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: JamView(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: DiscoverView(),
              );
            });
        }
      },
    );
  }
}
