import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric thenRegisterNickname() {
  return then<FlutterWorld>(
    'sera dirigido a la seccion de registro de nickname',
    (context) async {
      final nicknameFinder = find.text('Nickname');
      await FlutterDriverUtils.isPresent(context.world.driver, nicknameFinder);
    },
  );
}