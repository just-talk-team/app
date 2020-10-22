import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenConfirmed() {
  return when1<String,FlutterWorld>(
    'da click en el boton de {string}',
    (button,context) async {
      final finishFinder = find.byValueKey('Finish register');
      await FlutterDriverUtils.tap(context.world.driver, finishFinder);  
    },
  );
}
