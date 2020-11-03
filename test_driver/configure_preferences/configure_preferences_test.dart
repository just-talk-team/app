import 'dart:async';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/given_user_in_dashboard.dart';

Future<void> main() {
  enableFlutterDriverExtension();
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/configure_preferences.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json'),
      StdoutReporter()
    ]
    ..stepDefinitions = [givenUserInDashboard()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/configure_preferences.dart"
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}
