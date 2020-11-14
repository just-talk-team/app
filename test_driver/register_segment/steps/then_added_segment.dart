import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric thenRegisterSegment() {
  return then1<String, FlutterWorld>(
    'the segment {string} will be added to the list',
    (email,context) async {
      final segmentFinder = find.text(email);
      await FlutterDriverUtils.isPresent(
          context.world.driver, segmentFinder);
    },
  );
}
