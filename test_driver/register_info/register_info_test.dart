import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/given_register_info.dart';
import 'steps/then_not_register_nickname.dart';
import 'steps/then_register_nickname.dart';
import 'steps/when_not_register_valid_info.dart';
import 'steps/when_register_valid_info.dart';


Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/register_info.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json'),
      StdoutReporter()
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
     ..stepDefinitions = [
       givenUserInRegisterInfo(),
        whenRegisterValidInfo(),
        thenRegisterNickname(),
        whenNotRegisterValidInfo(), 
        thenNotRegisterNickname()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/register_info.dart"
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}