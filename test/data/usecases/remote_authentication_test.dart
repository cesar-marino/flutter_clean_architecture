import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({@required String url, @required String method});
}

class HttpCLientMock extends Mock implements HttpClient {}

void main() {
  HttpCLientMock httpClient;
  String url;
  RemoteAuthentication sut;

  setUp(() {
    httpClient = HttpCLientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Shold call HttClient with correct URL', () async {
    await sut.auth();

    verify(httpClient.request(url: url, method: 'post'));
  });
}
