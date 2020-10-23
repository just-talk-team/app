import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenRegisterValidSegment() {
  return when1<String,FlutterWorld>(
    'escriba un correo valido {string} y presione el boton de agregar',
    (email,context) async {
      final segmentFinder = find.byValueKey('Segment input');
      await FlutterDriverUtils.tap(context.world.driver, segmentFinder);
      await FlutterDriverUtils.enterText(
          context.world.driver, segmentFinder, email);
      await FlutterDriverUtils.tap(
          context.world.driver, find.byValueKey('Add segment'));
    },
  );
}
