import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric thenRegisterUser() {
  return then1<String, FlutterWorld>(
    'it will be added and taken to the {string} screen.',
    (preference, context) async {
      final preferenceFinder = find.byType(preference);
      await FlutterDriverUtils.isPresent(
          context.world.driver, preferenceFinder);
    },
  );
}
