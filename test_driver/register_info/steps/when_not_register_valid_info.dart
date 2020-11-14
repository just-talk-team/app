import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenNotRegisterValidInfo() {
  return when<FlutterWorld>(
    'he dont select a gender or his date of birth',
    (context) async {
      final dateFinder = find.byValueKey('DatePicker');
      await FlutterDriverUtils.tap(context.world.driver, dateFinder);
      await FlutterDriverUtils.tap(context.world.driver, find.text('13'));
      await FlutterDriverUtils.tap(context.world.driver, find.text('OK'));
      
    },
  );
}
