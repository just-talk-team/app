import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric thenNotRegisterNickname() {
  return then<FlutterWorld>(
    'it will not go to the nickname registration section',
    (context) async {
      final nicknameFinder = find.text('Nickname');
        //expect(nicknameFinder, findsOneWidget);
        await FlutterDriverUtils.isAbsent(context.world.driver, nicknameFinder);
    },
  );
}
