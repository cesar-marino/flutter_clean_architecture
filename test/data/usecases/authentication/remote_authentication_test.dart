import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso/domain/helpers/helpers.dart';
import 'package:curso/domain/usecases/usecases.dart';

import 'package:curso/data/usecases/usecases.dart';
import 'package:curso/data/http/http.dart';

class HttpCLientMock extends Mock implements HttpClient {}

void main() {
  HttpCLientMock httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpCLientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    mockHttpData(mockValidData());
  });

  test('Shold call HttClient with correct URL', () async {
    await sut.auth(params);
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    ));
  });

  test('Shold throw UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw InvalidCredentialsError if HttpClient return 401',
      () async {
    mockHttpError(HttpError.unauthorized);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Shold return Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);
    final account = await sut.auth(params);
    expect(account.token, validData['accessToken']);
  });

  test(
    'Shold throw UnexpectedError if HttpClient return 200 with invalid data',
    () async {
      mockHttpData({'invalid_key': 'invalid_value'});
      final future = sut.auth(params);
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
