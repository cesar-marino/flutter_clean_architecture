import '../entities/entities.dart';

abstract class SaveCurrentAccount {
  Future save(AccountEntity account);
}
