import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso/domain/usecases/usecases.dart';

import 'package:curso/data/http/http.dart';
import 'package:curso/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  AddAccount sut;
  HttpClient client;
  String url;
  AddAccountParams params;

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
}
