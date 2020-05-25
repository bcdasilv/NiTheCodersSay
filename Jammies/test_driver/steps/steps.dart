import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

class LoginSuccess extends AndWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    String password = "test1234";

    await FlutterDriverUtils.tap(world.driver, find.byValueKey('passKeyString'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('passKeyString'), password);

  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"I expect the user enters password");

}