import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'package:curso/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsonBody);
    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}

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
  });
}
