import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';
/*
class CheckGivenWidgets extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
// TODO: implement executeStep
    //await FlutterDriverUtils.isPresent(find.byValueKey('loginButton'), world.driver);
  }
  @override
// TODO: implement pattern
  RegExp get pattern => RegExp(r"I have {string}");
}
*/
class LoginValidation extends GivenWithWorld<FlutterWorld> {

  @override
  Future<void> executeStep() async {
    String input1 = "test123@test.com";
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('login'));
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('email'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('email'), input1);
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"Given the user enters an invalid email");

}

class PasswordValidation extends AndWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    String password = "test1234";

    await FlutterDriverUtils.tap(world.driver, find.byValueKey('password'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('password'), password);

  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the user enters their password");

}

class LoginButton extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('loginButton'));
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the user hits the login button");

}

class Nav_Validation extends ThenWithWorld<FlutterWorld> {

  @override
  Future<void> executeStep() async {
    //await FlutterDriverUtils.waitForFlutter(world.driver);
    //await FlutterDriverUtils.isPresent(find.byValueKey('nextScreenKey'), world.driver);
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the user should see an error message");

}