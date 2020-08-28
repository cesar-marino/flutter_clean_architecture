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

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();

    sut = GetxSignUpPresenter(
      validation: validation,
    );

    email = faker.internet.email();
    mockValidation();
  });

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
}
