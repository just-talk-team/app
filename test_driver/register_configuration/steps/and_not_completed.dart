import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric andNotCompleted() {
  return and<FlutterWorld>(
    'has not completed any of the registration data',
    (context) async {
      final SerializableFinder pv = find.byValueKey('pageview');
      await context.world.driver.waitFor(pv);

      //Info
      await context.world.driver
          .scroll(pv, -400, 0, Duration(milliseconds: 500));
      //Register
      await context.world.driver
          .scroll(pv, -400, 0, Duration(milliseconds: 500));
      //Avatar
      await context.world.driver
          .scroll(pv, -400, 0, Duration(milliseconds: 500));
      //Segment
    },
  );
}
