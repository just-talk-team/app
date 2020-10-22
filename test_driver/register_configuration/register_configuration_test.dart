import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/and_completed.dart';
import 'steps/and_not_completed.dart';
import 'steps/given_register_segment.dart';
import 'steps/then_added_user.dart';
import 'steps/then_not_added_user.dart';
import 'steps/when_confirmed.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/register_configuration.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [
      givenUserInRegisterSegment(),
      andCompleted(),
      whenConfirmed(),
      thenRegisterUser(),
      andNotCompleted(),
      thenNotRegisterUser()
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/register_configuration.dart"
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
