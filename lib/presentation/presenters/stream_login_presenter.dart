import 'dart:async';

import 'package:curso/ui/helpers/errors/errors.dart';
import 'package:meta/meta.dart';

import '../../ui/pages/pages.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../protocols/protocols.dart';

class LoginState {
  String email;
  String password;
  UIError emailError;
  UIError passwordError;
  UIError mainError;
  String navigateTo;
  bool isLoading = false;

  bool get isFormValid =>
      email != null &&
      password != null &&
      emailError == null &&
      passwordError == null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Authentication authentication;
  final Validation validation;
  var _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<UIError> get emailErrorStream =>
      _controller?.stream?.map((state) => state.emailError)?.distinct();

  Stream<UIError> get passwordErrorStream =>
      _controller?.stream?.map((state) => state.passwordError)?.distinct();

  Stream<UIError> get mainErrorStream =>
      _controller?.stream?.map((state) => state.mainError)?.distinct();

  Stream<String> get navigateToStream =>
      _controller?.stream?.map((state) => state.navigateTo)?.distinct();

  Stream<bool> get isFormValidStream =>
      _controller?.stream?.map((state) => state.isFormValid)?.distinct();

  Stream<bool> get isLoadingStream =>
      _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  void _update() => _controller?.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateField(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateField(
      field: 'password',
      value: password,
    );
    _update();
  }

  UIError _validateField({String field, String value}) {
    final formData = {'email': _state.email, 'password': _state.password};
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.requiredField:
        return UIError.requiredField;
      case ValidationError.invalidField:
        return UIError.invalidField;
      default:
        return null;
    }
  }

  Future auth() async {
    try {
      _state.isLoading = true;
      _update();

      await authentication.auth(AuthenticationParams(
        email: _state.email,
        password: _state.password,
      ));
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UIError.invalidCredentials;
          break;
        default:
          _state.mainError = UIError.unexpeted;
          break;
      }
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  void goToSignUp() {}

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}
