import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:curso/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );

    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);

    return isValid ? null : 'Campo inválido';
  }
}

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Shold return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Shold return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Shold return null if email is valid', () {
    expect(sut.validate(faker.internet.email()), null);
  });

  test('Shold return error if email is invalid', () {
    expect(sut.validate('cesar.marino'), 'Campo inválido');
  });
}
