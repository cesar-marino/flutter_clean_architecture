abstract class LoginPresenter {
  Stream<String> emailErrorStream;
  Stream<String> passwordErrorStream;
  Stream<bool> isFormValidStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
