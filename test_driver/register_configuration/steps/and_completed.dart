import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric andCompleted() {
  return and<FlutterWorld>(
    'has completed all the registration data',
    (context) async {
      final dateFinder = find.byValueKey('DatePicker');
      await FlutterDriverUtils.tap(context.world.driver, dateFinder);
      await FlutterDriverUtils.tap(context.world.driver, find.text('30'));
      await FlutterDriverUtils.tap(context.world.driver, find.text('OK'));
      await FlutterDriverUtils.tap(
          context.world.driver, find.text('Masculino'));

      final nicknameFinder = find.byValueKey('Nickname input');
      await FlutterDriverUtils.tap(context.world.driver, nicknameFinder);
      await FlutterDriverUtils.enterText(
          context.world.driver, nicknameFinder, 'xmaple');
      await FlutterDriverUtils.tap(
          context.world.driver, find.byValueKey('Accept nickname'));

      final SerializableFinder pv = find.byValueKey('pageview');
      await context.world.driver.waitFor(pv);
      await context.world.driver.scroll(pv, -400, 0, Duration(milliseconds: 500));
      final segmentFinder = find.byValueKey('Segment input');
      await FlutterDriverUtils.tap(context.world.driver, segmentFinder);
      await FlutterDriverUtils.enterText(
          context.world.driver, segmentFinder, 'xmaple@hotmail.com');
      await FlutterDriverUtils.tap(
          context.world.driver, find.byValueKey('Add segment'));
    },
  );
}
