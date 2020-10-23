import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';


import '../register_info/steps/then_not_register_nickname.dart';
import 'steps/given_register_nickname.dart';
import 'steps/then_not_register_avatar.dart';
import 'steps/then_register_avatar.dart';
import 'steps/when_not_register_valid_nickname.dart';
import 'steps/when_register_valid_nickname.dart';


Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/register_nickname.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [
      givenUserInRegisterNickname(),
      whenRegisterValidNickname(),
      thenRegisterAvatar(),
      whenNotRegisterValidNickname(),
      thenNotRegisterAvatar()
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/register_nickname.dart"
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
