import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:curso/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({@required this.httpClient, @required this.url});

  Future<void> load() async =>
      await httpClient.request(url: url, method: 'get');
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClient httpClient;
  RemoteLoadSurveys sut;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
