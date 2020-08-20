import 'package:curso/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:curso/domain/entities/account_entity.dart';
import 'package:curso/domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  @override
  Future save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
        key: 'token',
        value: account.token,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future saveSecure({@required String key, @required String value});
}

class SaveSecureCacheStorageMock extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageMock saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    account = AccountEntity(faker.guid.guid());
    saveSecureCacheStorage = SaveSecureCacheStorageMock();
    sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test(
    'Should throw UnexpectedError if SaveSecureCacheStorage throws',
    () async {
      mockError();

      final future = sut.save(account);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
