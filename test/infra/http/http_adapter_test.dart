import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';

import 'package:curso/data/http/http.dart';

import 'package:curso/infra/http/http.dart';

class ClientMock extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientMock client;
  String url;

  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(
      int statusCode, {
      String body = '{"any_key":"any_value"}',
    }) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Shuld call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      verify(client.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Shuld call post without body', () async {
      await sut.request(url: url, method: 'post');
      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Shuld return data if post returns 200', () async {
      var response = await sut.request(url: url, method: 'post');
      expect(response, {'any_key': 'any_value'});
    });

    test('Shuld return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      var response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Shuld return null if post returns 204', () async {
      mockResponse(204, body: '');
      var response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Shuld return null if post returns 204 with data', () async {
      mockResponse(204);
      var response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Shuld return BadRequestError if post returns 400', () async {
      mockResponse(400, body: '');
      var future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Shuld return BadRequestError if post returns 400', () async {
      mockResponse(400);
      var future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Shuld return UnAuthorizedError if post returns 401', () async {
      mockResponse(401);
      var future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Shuld return ForbiddenError if post returns 403', () async {
      mockResponse(403);
      var future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Shuld return NotFoundError if post returns 404', () async {
      mockResponse(404);
      var future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Shuld return ServerError if post returns 500', () async {
      mockResponse(500);
      var future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
