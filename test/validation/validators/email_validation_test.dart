import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:curso/presentation/protocols/protocols.dart';
import 'package:curso/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Shold return null if email is empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Shold return null if email is null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Shold return null if email is valid', () {
    expect(sut.validate({'any_field': faker.internet.email()}), null);
  });

  test('Shold return error if email is invalid', () {
    expect(
      sut.validate({'any_field': 'cesar.marino'}),
      ValidationError.invalidField,
    );
  });
}
