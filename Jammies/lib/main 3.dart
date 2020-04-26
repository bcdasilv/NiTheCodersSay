import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'app.dart';

void main() {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    debugPaintSizeEnabled = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return runApp(JamFinderApp());
}
