import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenRegisterValidNickname() {
  return when<FlutterWorld>(
    'ingrese un nickname valido',
    (context) async {
      final nicknameFinder = find.byValueKey('Nickname input');
      await FlutterDriverUtils.tap(context.world.driver, nicknameFinder);
      await FlutterDriverUtils.enterText(
          context.world.driver, nicknameFinder, 'Josered30');
      await FlutterDriverUtils.tap(context.world.driver, find.byValueKey('Accept nickname'));
      
    },
  );
}
