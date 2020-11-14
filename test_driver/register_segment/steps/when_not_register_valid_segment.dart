import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenNotRegisterValidSegment() {
  return when1<String, FlutterWorld>(
    'he write an invalid email {string} or already selected and press the add button',
    (email, context) async {
      final segmentFinder = find.byValueKey('Segment input');
      await FlutterDriverUtils.tap(context.world.driver, segmentFinder);
      await FlutterDriverUtils.enterText(
          context.world.driver, segmentFinder, email);
      await FlutterDriverUtils.tap(
          context.world.driver, find.byValueKey('Add segment'));
    },
  );
}
