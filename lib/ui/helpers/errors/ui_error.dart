import 'package:curso/ui/helpers/helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpeted,
  invalidCredentials,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.invalidField:
        return 'Campo inválido';
      case UIError.invalidCredentials:
        return 'Credenciais inválidas';
      case UIError.unexpeted:
      default:
        return 'Algo de errado não esta certo';
    }
  }
}
