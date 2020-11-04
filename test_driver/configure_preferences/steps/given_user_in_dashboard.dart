import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric givenUserInDashboard() {
  return given<FlutterWorld>(
      'a free user logged user who enters the "Just Talk" view',
      (context) async {
    final dashboard = find.byType('Home');
    await FlutterDriverUtils.isPresent(context.world.driver, dashboard);
  });
}
