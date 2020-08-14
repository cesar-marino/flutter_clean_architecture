abstract class LoginPresenter {
  Stream<String> emailErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
