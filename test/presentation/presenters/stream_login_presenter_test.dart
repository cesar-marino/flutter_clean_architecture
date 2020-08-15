import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

class ValidationMock extends Mock implements Validation {}

void main() {
  test('Shold call Validation with correct email', () {
    final validation = ValidationMock();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
