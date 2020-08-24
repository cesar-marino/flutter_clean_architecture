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
        return R.strings.msgInvalidField;
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      case UIError.unexpeted:
      default:
        return R.strings.msgUnexpetedError;
    }
  }
}
