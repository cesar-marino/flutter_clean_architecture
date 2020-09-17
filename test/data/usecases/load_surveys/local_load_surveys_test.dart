import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso/data/cache/cache.dart';
import 'package:curso/data/usecases/usecases.dart';

import 'package:curso/domain/entities/entities.dart';
import 'package:curso/domain/helpers/helpers.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  group('Load', () {
    LocalLoadSurveys sut;
    FetchCacheStorageSpy fetchCacheStorage;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2020-07-20T00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-02-02T00:00:00Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() => when(fetchCacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      fetchCacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            date: DateTime.utc(2020, 7, 20),
            didAnswer: false),
        SurveyEntity(
            id: data[1]['id'],
            question: data[1]['question'],
            date: DateTime.utc(2019, 2, 2),
            didAnswer: true),
      ]);
    });

    test('Should throw UnexpectedErro if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedErro if cache is null', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedErro if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'ivalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedErro if cache is incomplete', () async {
      mockFetch([
        {'date': '2020-07-20T00:00:00Z', 'didAnswer': 'false'}
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedErro if cache is incomplete', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}