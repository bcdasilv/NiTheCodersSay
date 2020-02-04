import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DiscoverView extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: const Text('Discover'),
            ),
            child: Container(),
        );
    }
}
