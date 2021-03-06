import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
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
      expect(
          () => UMMobileCustomHttp(
                baseUrl: 'https://wso2am.um.edu.mx/ummobile/v1/academic',
                auth: Auth(token: () => 'this_is_not_a_json_web_token'),
              ),
          throwsA(isA<FormatException>()));
    });

    test('ServerError', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');
      bool shouldBeTrue = true;
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
        // If reach this point the exception wasn't throw.
        shouldBeTrue = false;
      } catch (e) {
        expect(e, isA<ServerErrorException>());
        if (e is ServerErrorException) {
          expect(e.type, HttpExceptions.ServerError);
        }
      }
      expect(shouldBeTrue, isTrue);
    });

    test('ClientError', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');
      bool shouldBeTrue = true;
      try {
        await http.customGet<PostTest>(path: '/wrong_path');
        // If reach this point the exception wasn't throw.
        shouldBeTrue = false;
      } catch (e) {
        expect(e, isA<ClientErrorException>());
        if (e is ClientErrorException) {
          expect(e.type, HttpExceptions.ClientError);
        }
      }
      expect(shouldBeTrue, isTrue);
    });

    test('ExpiredToken', () async {
      final http = UMMobileCustomHttp(
        baseUrl: 'https://wso2am.um.edu.mx/ummobile/v1/academic',
        auth: Auth(token: () => testToken),
      );
      bool shouldBeTrue = true;
      try {
        await http.customGet(path: '/documents');
        // If reach this point the exception wasn't throw.
        shouldBeTrue = false;
      } catch (e) {
        expect(e, isA<ClientErrorException>());
        if (e is ClientErrorException) {
          expect(e.type, HttpExceptions.ExpiredToken);
          expect(e.extras['expiresIn'], isNotNull);
          expect(
              DateTime.parse(e.extras['expiresIn'])
                  .add(Duration(days: 2))
                  .isBefore(DateTime.now()),
              isTrue);
        }
      }
      expect(shouldBeTrue, isTrue);
    });

    test('Unauthorized', () async {
      final http = UMMobileCustomHttp(
        baseUrl: 'https://wso2am.um.edu.mx/ummobile/v1/academic',
      );
      bool shouldBeTrue = true;
      try {
        await http.customGet(path: '/documents');
        // If reach this point the exception wasn't throw.
        shouldBeTrue = false;
      } catch (e) {
        expect(e, isA<ClientErrorException>());
        if (e is ClientErrorException) {
          expect(e.type, HttpExceptions.Unauthorized);
        }
      }
      expect(shouldBeTrue, isTrue);
    });
  });
}
