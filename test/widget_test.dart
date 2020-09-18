import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/app.dart';
import 'package:just_talk/layouts/home.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Login", () {
    MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildMainPage(WidgetTester tester) async {
      await tester.pumpWidget(App(
        authenticationService: AuthenticationService(),
        userService: UserService(),
      ));

      verify(mockObserver.didPush(any, any));
    }

    Future<void> _navigateToHome(WidgetTester tester) async {
      expect(find.byKey(Key("login_username")), findsOneWidget);
      expect(find.byKey(Key("login_password")), findsOneWidget);
      expect(find.byKey(Key("login_submit")), findsOneWidget);

      await tester.enterText(find.byKey(Key("login_username")), 'josered');
      await tester.enterText(find.byKey(Key("login_password")), '123');
      await tester.pump();

      await tester.tap(find.byKey(Key("Login buttom")));
      await tester.pumpAndSettle();
    }

    testWidgets('Login test', (WidgetTester tester) async {
      await _buildMainPage(tester);


    
      await _navigateToHome(tester);

      verify(mockObserver.didPush(any, any));
      tester.state(find.byType(Home));
    });
  });
}
