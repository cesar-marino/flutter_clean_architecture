import 'package:test/test.dart';

import 'package:curso/presentation/protocols/validation.dart';

import 'package:curso/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      valueToCompare: 'any_value',
    );
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}
