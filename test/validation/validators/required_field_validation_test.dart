import 'package:test/test.dart';

import 'package:curso/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Shuld return null if values is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Shuld return error if values is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });

  test('Shuld return error if values is null', () {
    expect(sut.validate(null), 'Campo obrigatório');
  });
}
