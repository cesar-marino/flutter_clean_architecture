import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:curso/ui/helpers/errors/errors.dart';
import 'package:curso/ui/pages/pages.dart';

class LoginPresenterMock extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );

    when(presenter.passwordErrorStream).thenAnswer(
      (_) => passwordErrorController.stream,
    );

    when(presenter.mainErrorStream).thenAnswer(
      (_) => mainErrorController.stream,
    );

    when(presenter.navigateToStream).thenAnswer(
      (_) => navigateToController.stream,
    );

    when(presenter.isFormValidStream).thenAnswer(
      (_) => isFormValidController.stream,
    );

    when(presenter.isLoadingStream).thenAnswer(
      (_) => isLoadingController.stream,
    );
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();
    initStreams();
    mockStreams();
    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
        GetPage(
          name: '/any_route',
          page: () => Scaffold(body: Text('fake page')),
        ),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets(
    'Shold load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

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
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Shold call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Shold presenter error is email invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text('Campo inválido'), findsOneWidget);
    },
  );

  testWidgets(
    'Shold presenter error is email empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatório'), findsOneWidget);
    },
  );

  testWidgets(
    'Shold presenter no error is email valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Shold presenter error is password empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatório'), findsOneWidget);
    },
  );

  testWidgets(
    'Shold presenter no error is password valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Shold enabled button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Shold disabled button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'Shold call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      var button = find.byType(RaisedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      verify(presenter.auth()).called(1);
    },
  );

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
    'Shold present error message if authentication fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.invalidCredentials);
      await tester.pump();

      expect(find.text('Credenciais inválidas'), findsOneWidget);
    },
  );

  testWidgets(
    'Shold present error message if authentication throws',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.unexpeted);
      await tester.pump();

      expect(find.text('Algo de errado não está certo'), findsOneWidget);
    },
  );

  testWidgets('Shold change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, 'any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/login');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/login');
  });

  testWidgets('Should call gotoSignUp on link click',
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSignUp()).called(1);
  });
}
