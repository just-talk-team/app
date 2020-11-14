import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';


StepDefinitionGeneric thenRegisterAvatar() {
  return then<FlutterWorld>(
    'he will be directed to the avatar registration section',
    (context) async {
      final avatarFinder = find.byType('AvatarPage');
      await FlutterDriverUtils.isPresent(context.world.driver, avatarFinder);
    },
  );
}