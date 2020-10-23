import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/given_register_segment.dart';
import 'steps/then_added_segment.dart';
import 'steps/then_not_added_segment.dart';
import 'steps/when_not_register_valid_segment.dart';
import 'steps/when_register_valid_segmentt.dart';


Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/register_segments.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [ 
        givenUserInRegisterSegment(),
        whenNotRegisterValidSegment(),
        whenRegisterValidSegment(),
        thenNotRegisterSegment(),
        thenRegisterSegment()
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/register_segments.dart"
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
