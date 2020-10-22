import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:mockito/mockito.dart';

StepDefinitionGeneric thenRegisterUser() {
  return then1<String, FlutterWorld>(
    'sera añadido y llevado a la pantalla {string}',
    (preference, context) async {
      final preferenceFinder = find.byType(preference);
      await FlutterDriverUtils.isPresent(
          context.world.driver, preferenceFinder);
    },
  );
}
