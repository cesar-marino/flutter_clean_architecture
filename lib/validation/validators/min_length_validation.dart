import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  @override
  List<Object> get props => [field, size];

  @override
  ValidationError validate(String value) {
    return value != null && value.length >= 5
        ? null
        : ValidationError.invalidField;
  }
}
