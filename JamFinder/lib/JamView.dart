import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class JamView extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: const Text('Jam'),
            ),
            child: Container(),
        );
    }
}
