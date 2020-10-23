import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric givenUserInRegisterNickname() {
  return given<FlutterWorld>(
    'un usuario que se encuentra en la seccion de registro de nickname',
    (context) async {
      final loginFinder = find.byType('NicknamePage');
      await FlutterDriverUtils.isPresent(context.world.driver, loginFinder);
    },
  );
}
