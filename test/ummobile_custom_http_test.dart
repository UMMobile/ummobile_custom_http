import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';
import 'package:ummobile_custom_http/src/exceptions/http_call_exception.dart';
import 'package:ummobile_custom_http/ummobile_custom_http.dart';

class PostTest {
  int userId;
  int id;
  String title;
  String body;

  PostTest({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
}

void main() {
  String testToken = Platform.environment['TOKEN'] ?? '';
  String execEnv = env['EXEC_ENV'] ?? Platform.environment['EXEC_ENV'] ?? '';

  if (execEnv != 'github_actions') {
    setUpAll(() async {
      load();
      testToken = env['TOKEN'] ?? testToken;
    });

    tearDownAll(() {
      clean();
    });
  }

  group('[Initialization]', () {
    test('Create a new UMMobileCustomHttp instance', () {
      UMMobileCustomHttp http = UMMobileCustomHttp(
        baseUrl: 'https://wso2am.um.edu.mx/ummobile/v1/academic',
        auth: Auth(token: () => testToken),
      );

      expect(http, isNotNull);
    });
  });

  group('[GET]', () {
    test('Make a call: with mapper', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');

      PostTest todo = await http.customGet<PostTest>(
        path: '/posts/1',
        mapper: (json) => PostTest(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
          body: json['body'],
        ),
      );

      expect(todo, isNotNull);
      expect(todo.id, 1);
    });

    test('Make a call: with queries', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');

      List<dynamic> comments = await http.customGet<List<dynamic>>(
        path: '/comments',
        queries: {
          'postId': 1,
        },
      );

      expect(comments, hasLength(5));
    });
  });

  group('[Exceptions]', () {
    test('Invalid JWT', () {
      try {
        UMMobileCustomHttp(
          baseUrl: 'https://wso2am.um.edu.mx/ummobile/v1/academic',
          auth: Auth(token: () => 'this_is_not_a_json_web_token'),
        );
      } catch (e) {
        expect(e, isA<FormatException>());
        expect(e.toString(), 'FormatException: Invalid token.');
      }
    });

    test('ServerError', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');
      try {
        await http.customPost<PostTest>(
          path: '/posts',
          body: 'wrong_body',
          mapper: (json) => PostTest(
            userId: json['userId'],
            id: json['id'],
            title: json['title'],
            body: json['body'],
          ),
        );
      } catch (e) {
        expect(e, isA<HttpCallException>());
        if (e is HttpCallException) {
          expect(e.type, HttpExceptions.ServerError);
        }
      }
    });

    test('ClientError', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');
      try {
        await http.customGet<PostTest>(path: '/wonrg_path');
      } catch (e) {
        expect(e, isA<HttpCallException>());
        if (e is HttpCallException) {
          expect(e.type, HttpExceptions.ClientError);
        }
      }
    });

    test('ExpiredToken', () async {
      final http = UMMobileCustomHttp(
        baseUrl: 'https://wso2am.um.edu.mx/ummobile/v1/academic',
        auth: Auth(token: () => testToken),
      );
      bool shouldBeTrue = true;
      try {
        await http.customGet(path: '/documents');
        shouldBeTrue = false;
      } catch (e) {
        expect(e, isA<HttpCallException>());
        if (e is HttpCallException) {
          expect(e.type, HttpExceptions.ExpiredToken);
        }
      }
      expect(shouldBeTrue, isTrue);
    });
  });
}
