import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:curso/presentation/protocols/validation.dart';

import 'package:curso/validation/validators/validators.dart';

void main() {
  MinLengthValidation sut;

  setUp(() => sut = MinLengthValidation(field: 'any_field', size: 5));

  test('Should return error if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({'any_field': null}), ValidationError.invalidField);
  });

  test('Should return error if value less than min size', () {
    expect(
      sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}),
      ValidationError.invalidField,
    );
  });

  test('Should return null if value is equals than min size', () {
    expect(
      sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}),
      null,
    );
  });

  test('Should return null if value is bigger than min size', () {
    expect(
      sut.validate({'any_field': faker.randomGenerator.string(10, min: 6)}),
      null,
    );
  });
}
