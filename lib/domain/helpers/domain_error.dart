enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.unexpected:
        return 'Algo de errado não esta certo';
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
      default:
        return 'Algo de errado não esta certo';
    }
  }
}
