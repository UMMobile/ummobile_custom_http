import 'package:flutter_test/flutter_test.dart';
import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';
import 'package:ummobile_custom_http/src/exceptions/on_call_exception.dart';
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
  group('GET>>', () {
    test('Make a call', () async {
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

    test('Client error: wrong path', () async {
      final http =
          UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');
      try {
        await http.customGet<PostTest>(path: '/wonrg_path');
      } catch (e) {
        expect(e, isA<OnCallException>());
        if (e is OnCallException) {
          expect(e.type, HttpExceptions.ClientError);
        }
      }
    });
  });

  group('POST>>', () {
    test('Server error: wrong body', () async {
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
        expect(e, isA<OnCallException>());
        if (e is OnCallException) {
          expect(e.type, HttpExceptions.ServerError);
        }
      }
    });
  });
}
