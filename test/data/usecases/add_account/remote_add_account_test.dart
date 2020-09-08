import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso/domain/helpers/helpers.dart';
import 'package:curso/domain/usecases/usecases.dart';

import 'package:curso/data/http/http.dart';
import 'package:curso/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  AddAccount sut;
  HttpClient client;
  String url;
  AddAccountParams params;

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(client.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    client = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(client: client, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(client.request(
      url: url,
      method: 'post',
      body: {
        'name': params.name,
        'email': params.email,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation,
      },
    ));
  });

  test('Shoul throw Unexpected error if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw InvalidCredentialsError if HttpClient return 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Shold return Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.add(params);

    expect(account.token, validData['accessToken']);
  });

  test(
    'Shold throw UnexpectedError if HttpClient return 200 with invalid data',
    () async {
      mockHttpData({'invalid_key': 'invalid_value'});

      final future = sut.add(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
