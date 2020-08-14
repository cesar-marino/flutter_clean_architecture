import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso/ui/pages/pages.dart';

void main() {
  testWidgets(
    'Shold load with correct initial state',
    (WidgetTester tester) async {
      final loginPage = MaterialApp(home: LoginPage());
      await tester.pumpWidget(loginPage);

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

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);
    },
  );
}
