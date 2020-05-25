// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:async';
import 'package:glob/glob.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'steps/steps.dart';

void main() {
  group('Jammies App', () {
    final textFinder = find.byValueKey('registerText');
    final buttonFinder = find.byValueKey('register');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('User registers new account with non-unique email', () async {
      await driver.tap(buttonFinder);
      // Use the `driver.getText` method to verify the user is still on the register page
      expect(await driver.getText(textFinder), "Register new account");
    });

  });
}
