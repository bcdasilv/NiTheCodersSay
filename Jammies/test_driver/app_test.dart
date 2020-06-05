import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/steps.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [ProgressReporter()]
    ..stepDefinitions = [LoginValidation(), PasswordValidation(), LoginButton(), Nav_Validation(),
      LoginSuccessValidation(), PasswordSuccessValidation(), Jam_Validation(),
      RegisterUnique(), Register(), RegisterFailed(), RegisterStatus(), RegisterButton(),
      CanEdit(), SelectEdit(), SelectProfile(), SwipeLeft(), SwipeRight(), ShowLeft(),
      ShowRight(), Jam(), ViewPost(), DiscoverNav()]
    ..targetAppPath = "test_driver/app.dart"
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}