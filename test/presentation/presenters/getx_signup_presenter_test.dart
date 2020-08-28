import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso/presentation/presenters/presenters.dart';
import 'package:curso/presentation/protocols/protocols.dart';

import 'package:curso/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  String email;
  String name;
  String password;
  String passwordConfirmation;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(validation: validation);
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    mockValidation();
  });

  group('Email', () {
    test('Shold call Validation with correct email', () {
      sut.validateEmail(email);
      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Shold emit invalidFieldError if email is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.invalidField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Shold emit requiredFieldError if email is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.requiredField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Shold emit null if validation succeeds', () {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });

  group('name', () {
    test('Shold call Validation with correct name', () {
      sut.validateName(name);
      verify(validation.validate(field: 'name', value: name)).called(1);
    });

    test('Shold emit invalidFieldError if name is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.nameErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.invalidField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Shold emit requiredFieldError if name is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.nameErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.requiredField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Shold emit null if validation succeeds', () {
      sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateName(name);
      sut.validateName(name);
    });
  });

  group('password', () {
    test('Shold call Validation with correct password', () {
      sut.validatePassword(password);

      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Shold emit invalidFieldError if password is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.passwordErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.invalidField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Shold emit requiredFieldError if password is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.passwordErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.requiredField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Shold emit null if validation succeeds', () {
      sut.passwordErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });

  group('password confirmation', () {
    test('Shold call Validation with correct password confirmation', () {
      sut.validatePasswordConfirmation(passwordConfirmation);

      verify(validation.validate(
        field: 'passwordConfirmation',
        value: passwordConfirmation,
      )).called(1);
    });

    test('Shold emit invalidFieldError if password confirmation is invalid',
        () {
      mockValidation(value: ValidationError.invalidField);

      sut.passwordConfirmationErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.invalidField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Shold emit requiredFieldError if password confirmation is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.passwordConfirmationErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.requiredField)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Shold emit null if validation succeeds', () {
      sut.passwordConfirmationErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });
  });

  test('Shold enabled form button if all field are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });
}
