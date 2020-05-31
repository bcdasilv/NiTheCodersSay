import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/steps.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
Future<void> main() {
  /*
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
  */

  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [ProgressReporter()]
    ..stepDefinitions = [LoginValidation(), PasswordValidation(), LoginButton(), Nav_Validation(),
                          LoginSuccessValidation(), PasswordSuccessValidation(), Jam_Validation(),
                          ]
    ..reporters = [ProgressReporter(), TestRunSummaryReporter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart"
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}