import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:curso/ui/pages/pages.dart';

void main() {
  Future loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage()),
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

  testWidgets(
    'Shold load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'),
        matching: find.byType(Text),
      );

      expect(nameTextChildren, findsOneWidget);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(emailTextChildren, findsOneWidget);

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordTextChildren, findsOneWidget);

      final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text),
      );

      expect(passwordConfirmationTextChildren, findsOneWidget);

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}
