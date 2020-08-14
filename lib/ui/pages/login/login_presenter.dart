abstract class LoginPresenter {
  Stream<String> emailErrorStream;
  Stream<String> passwordErrorStream;
  Stream<bool> isFormValidStream;
  Stream<bool> isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
}
