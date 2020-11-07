import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';


StepDefinitionGeneric thenNotRegisterUser() {
  return then1<String, FlutterWorld>(
    'no sera añadido y dirigido a la pantalla {string}',
    (preference, context) async {
      final preferenceFinder = find.byType(preference);

      await FlutterDriverUtils.isAbsent(
          context.world.driver, preferenceFinder);
    },
  );
}
