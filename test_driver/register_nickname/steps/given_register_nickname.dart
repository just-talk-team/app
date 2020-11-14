import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric givenUserInRegisterNickname() {
  return given<FlutterWorld>(
    'a user who is in the nickname registration section',
    (context) async {
      final loginFinder = find.byType('NicknamePage');
      await FlutterDriverUtils.isPresent(context.world.driver, loginFinder);
    },
  );
}
