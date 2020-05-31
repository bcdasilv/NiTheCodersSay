import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:password/password.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LoginValidation extends GivenWithWorld<FlutterWorld> {

  @override
  Future<void> executeStep() async {
    String input1 = "test123@test.com";
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('login'));
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('email'));
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey('email'), input1);
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
    await FlutterDriverUtils.waitForFlutter(world.driver);
    await FlutterDriverUtils.isPresent(world.driver, find.byValueKey('submit'));
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the user should see an error message");

}

class LoginSuccessValidation extends GivenWithWorld<FlutterWorld> {

  @override
  Future<void> executeStep() async {
    String input1 = "smparkin@calpoly.edu";
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('login'));
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('email'));
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey('email'), input1);
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"Given the user enters a valid email");
}

class PasswordSuccessValidation extends AndWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final hash = sha512.convert(utf8.encode('test'));

    String hashString = "$hash";

    await FlutterDriverUtils.tap(world.driver, find.byValueKey('password'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('password'), hashString);

  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the user enters their password");

}

class Jam_Validation extends ThenWithWorld<FlutterWorld> {

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.waitForFlutter(world.driver);
    await FlutterDriverUtils.isPresent(world.driver, find.byValueKey('submit'));
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the user should land on the jam screen");

}

class Register extends GivenWithWorld<FlutterWorld> {

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('reg'));
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('emailRegister'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('emailRegister'),
          'smparkin@calpoly.edu');
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('passwordRegister'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('passwordRegister'), 'test');
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('passRegister'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('passRegister'), 'test');
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('zip'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('zip'), '93401');
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('date'));
    await FlutterDriverUtils.enterText(world.driver, find.byValueKey('date'), '5/31/20');
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('passRegister'));
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the User’s email is not unique");
}

class RegisterButton extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('register'));
  }

  @override
  // TODO: implement pattern
  RegExp get pattern => RegExp(r"the User tries to register");

}