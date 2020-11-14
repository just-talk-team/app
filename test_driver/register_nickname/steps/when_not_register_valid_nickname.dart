import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenNotRegisterValidNickname() {
  return when<FlutterWorld>(
    'enter an invalid or empty nickname',
    (context) async {
      final nicknameFinder = find.byValueKey('Nickname input');
      await FlutterDriverUtils.tap(context.world.driver, nicknameFinder);
      await FlutterDriverUtils.tap(context.world.driver, find.byValueKey('Accept nickname'));
    },
  );
}
