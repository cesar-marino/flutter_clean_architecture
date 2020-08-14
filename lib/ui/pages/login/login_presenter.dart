abstract class LoginPresenter {
  Stream<String> emailErrorStream;
  Stream<String> passwordErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
