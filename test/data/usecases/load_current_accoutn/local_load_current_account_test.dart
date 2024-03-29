import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso/domain/entities/entities.dart';
import 'package:curso/domain/helpers/helpers.dart';

import 'package:curso/data/cache/cache.dart';
import 'package:curso/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  String token;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() =>
      mockFetchSecureCall().thenAnswer((_) async => token);

  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception);

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test(
    'Should throw UnexpetedError if FetchSecureCacheStorage throws',
    () async {
      mockFetchSecureError();
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
