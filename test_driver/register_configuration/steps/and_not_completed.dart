import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric andNotCompleted() {
  return and<FlutterWorld>(
    'no ha completado alguno de los datos del registro',
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
