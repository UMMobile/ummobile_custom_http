/// The custom HTTP client with GetConnect used in the UMMobile App.
///
/// To see code examples you can go to https://pub.dev/packages/ummobile_custom_http/example.
library ummobile_custom_http;

import 'dart:async';
import 'dart:convert';

import 'package:get/get_connect.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';
import 'package:ummobile_custom_http/src/enums/http_methods.dart';
import 'package:ummobile_custom_http/src/exceptions/http_call_exception.dart';
import 'package:ummobile_custom_http/src/internet_status.dart';
import 'package:ummobile_custom_http/src/models/auth.dart';

// Export components
export 'package:ummobile_custom_http/src/enums/http_exceptions.dart';
export 'package:ummobile_custom_http/src/exceptions/http_call_exception.dart';
export 'package:ummobile_custom_http/src/models/auth.dart';

/// A Custom HTTP client
class UMMobileCustomHttp extends GetConnect {
  /// The the authorization requests.
  Auth? auth;

  /// Main constructor of the Custom HTTP client
  ///
  /// Require the [baseUrl] where the calls will be sent. Example of a [baseUrl]: `https://jsonplaceholder.typicode.com`. Each request (`get`, `post`, etc.) can receive it's own path that is concatenated with the [baseUrl].
  ///
  /// Also can receive a [timeout] (default `10` seconds) and an optional [auth] configuration.
  UMMobileCustomHttp({
    required String baseUrl,
    Duration timeout: const Duration(seconds: 10),
    this.auth,
  }) {
    // Set the base url
    httpClient.baseUrl = baseUrl;
    // Set the timeout
    httpClient.timeout = timeout;
    // Set the auth
    if (this.auth != null) {
      httpClient.addAuthenticator<dynamic>((request) {
        request.headers[this.auth!.headerName] = this.auth!.format;
        return request;
      });
    }
  }

  /// Make a GET call.
  ///
  /// Can receive a [path] but is not mandatory because can be a call to base URL. Also can receive [queries], extra [headers], a [mapper], a [customTimeout] and if the response should be [utf8Decode].
  ///
  /// The [queries] values are transformed to string.
  ///
  /// The [mapper] function receive the response body (usually JSON) as the only parameter and return the type defined by the function with `T`. If no [mapper] function is declared then the returned data is the response body. Before pass the response body to the [mapper] can be decoded to utf8 if [utf8Decode] is set to `true` (default `false`: use response `Content-Type` to know how to decode).
  ///
  /// Throws an [HttpCallException] if an error occurs. The [HttpCallException] type can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `ExpiredToken`           | When access token is expired & need to be refresh      |
  /// | `Other`                  | When any other `Exception` occurs                      |
  Future<T> customGet<T>({
    String path: '',
    Map<String, dynamic> queries: const {},
    Map<String, String> headers: const {},
    T Function(dynamic)? mapper,
    Duration? customTimeout,
    bool? utf8Decode,
  }) async =>
      await _baseCall<T>(
          method: HttpMethods.GET,
          path: path,
          queries: queries,
          headers: headers,
          mapper: mapper,
          customTimeout: customTimeout,
          utf8Decode: utf8Decode);

  /// Make a PATH call.
  ///
  /// Can receive a [path] but is not mandatory because can be a call to base URL. Also can receive [queries], extra [headers], the [body] of the request, a [mapper], a [customTimeout] and if the response should be [utf8Decode].
  ///
  /// The [queries] values are transformed to string.
  ///
  /// The [mapper] funtion receive the response body (usually JSON) as the only parameter and return the type defined by the function with `T`. If no [mapper] function is declared then the returned data is the response body. Before pass the response body to the [mapper] function can be decoded to utf8 if [utf8Decode] is set to `true` (default `false`: use response `Content-Type` to know how to decode).
  ///
  /// Throws an [HttpCallException] if an error occurs. The [HttpCallException] type can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `ExpiredToken`           | When access token is expired & need to be refresh      |
  /// | `Other`                  | When any other `Exception` occurs                      |
  Future<T> customPatch<T>({
    String path: '',
    Map<String, dynamic> queries: const {},
    dynamic body,
    Map<String, String> headers: const {},
    T Function(dynamic)? mapper,
    Duration? customTimeout,
    bool? utf8Decode,
  }) async =>
      await _baseCall<T>(
          method: HttpMethods.PATCH,
          path: path,
          queries: queries,
          body: body,
          mapper: mapper,
          headers: headers,
          customTimeout: customTimeout,
          utf8Decode: utf8Decode);

  /// Make a PUT call.
  ///
  /// Can receive a [path] but is not mandatory because can be a call to base URL. Also can receive [queries], extra [headers], the [body] of the request, a [mapper], a [customTimeout] and if the response should be [utf8Decode].
  ///
  /// The [queries] values are transformed to string.
  ///
  /// The [mapper] funtion receive the response body (usually JSON) as the only parameter and return the type defined by the function with `T`. If no [mapper] function is declared then the returned data is the response body. Before pass the response body to the [mapper] function can be decoded to utf8 if [utf8Decode] is set to `true` (default `false`: use response `Content-Type` to know how to decode).
  ///
  /// Throws an [HttpCallException] if an error occurs. The [HttpCallException] type can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `ExpiredToken`           | When access token is expired & need to be refresh      |
  /// | `Other`                  | When any other `Exception` occurs                      |
  Future<T> customPut<T>({
    String path: '',
    Map<String, dynamic> queries: const {},
    dynamic body,
    Map<String, String> headers: const {},
    T Function(dynamic)? mapper,
    Duration? customTimeout,
    bool? utf8Decode,
  }) async =>
      await _baseCall<T>(
          method: HttpMethods.PUT,
          path: path,
          queries: queries,
          body: body,
          mapper: mapper,
          headers: headers,
          customTimeout: customTimeout,
          utf8Decode: utf8Decode);

  /// Make a POST call.
  ///
  /// Can receive a [path] but is not mandatory because can be a call to base URL. Also can receive [queries], extra [headers], the [body] of the request, a [mapper], a [customTimeout] and if the response should be [utf8Decode].
  ///
  /// The [queries] values are transformed to string.
  ///
  /// The [mapper] funtion receive the response body (usually JSON) as the only parameter and return the type defined by the function with `T`. If no [mapper] function is declared then the returned data is the response body. Before pass the response body to the [mapper] function can be decoded to utf8 if [utf8Decode] is set to `true` (default `false`: use response `Content-Type` to know how to decode).
  ///
  /// Throws an [HttpCallException] if an error occurs. The [HttpCallException] type can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `ExpiredToken`           | When access token is expired & need to be refresh      |
  /// | `Other`                  | When any other `Exception` occurs                      |
  Future<T> customPost<T>({
    String path: '',
    Map<String, dynamic> queries: const {},
    dynamic body,
    Map<String, String> headers: const {},
    T Function(dynamic)? mapper,
    Duration? customTimeout,
    bool? utf8Decode,
  }) async =>
      await _baseCall<T>(
          method: HttpMethods.POST,
          path: path,
          queries: queries,
          body: body,
          mapper: mapper,
          headers: headers,
          customTimeout: customTimeout,
          utf8Decode: utf8Decode);

  /// Make a DELETE call.
  ///
  /// Can receive a [path] but is not mandatory because can be a call to base URL. Also can receive [queries], extra [headers], a [mapper], a [customTimeout] and if the response should be [utf8Decode].
  ///
  /// The [queries] values are transformed to string.
  ///
  /// The [mapper] funtion receive the response body (usually JSON) as the only parameter and return the type defined by the function with `T`. If no [mapper] function is declared then the returned data is the response body. Before pass the response body to the [mapper] function can be decoded to utf8 if [utf8Decode] is set to `true` (default `false`: use response `Content-Type` to know how to decode).
  ///
  /// Throws an [HttpCallException] if an error occurs. The [HttpCallException] type can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `ExpiredToken`           | When access token is expired & need to be refresh      |
  /// | `Other`                  | When any other `Exception` occurs                      |
  Future<T> customDelete<T>({
    String path: '',
    Map<String, dynamic> queries: const {},
    Map<String, String> headers: const {},
    T Function(dynamic)? mapper,
    Duration? customTimeout,
    bool? utf8Decode,
  }) async =>
      await _baseCall<T>(
          method: HttpMethods.DELETE,
          path: path,
          queries: queries,
          headers: headers,
          mapper: mapper,
          customTimeout: customTimeout,
          utf8Decode: utf8Decode);

  Future<T> _baseCall<T>({
    required HttpMethods method,
    String path: '',
    Map<String, dynamic> queries: const {},
    dynamic body,
    Map<String, String> headers: const {},
    Duration? customTimeout,
    T Function(dynamic)? mapper,
    bool? utf8Decode,
  }) async {
    bool _utf8Decode = utf8Decode ?? false;
    late T data;
    try {
      String _queries = _formatQueries(queries);

      Response response = await _call(method,
          path: '$path$_queries',
          body: body,
          headers: headers,
          customTimeout: customTimeout);

      if (response.status.isOk) {
        data = mapper != null
            ? mapper(_utf8Decode
                ? jsonDecode(utf8.decode(
                    response.bodyString!.runes.toList(),
                    allowMalformed: true,
                  ))
                : response.body)
            : response.body;
      } else if (response.status.between(300, 499)) {
        if (this.auth != null && response.status.isUnauthorized) {
          bool isExpired = Jwt.isExpired(this.auth!.token());
          if (isExpired) {
            throw HttpCallException(HttpExceptions.ExpiredToken);
          }
        }
        throw HttpCallException(HttpExceptions.ClientError);
      } else if (response.status.isServerError) {
        throw HttpCallException(HttpExceptions.ServerError);
      } else if (response.status.connectionError) {
        throw HttpCallException(
            await checkInternetConnection('${this.httpClient.baseUrl}$path'));
      }
    } on TimeoutException catch (_) {
      throw HttpCallException(
          await checkInternetConnection('${this.httpClient.baseUrl}$path'));
    }
    return data;
  }

  _call(
    HttpMethods method, {
    required String path,
    Map<String, String> headers: const {},
    dynamic body,
    Map<String, dynamic>? query,
    Duration? customTimeout,
  }) async {
    Duration durationTimeout = customTimeout ?? const Duration(seconds: 10);
    switch (method) {
      case HttpMethods.GET:
        return await httpClient
            .get(path,
                headers: headers, query: query, contentType: 'application/json')
            .timeout(durationTimeout);
      case HttpMethods.PUT:
        return await httpClient
            .put(path,
                body: body,
                headers: headers,
                query: query,
                contentType: 'application/json')
            .timeout(durationTimeout);
      case HttpMethods.POST:
        return await httpClient
            .post(path,
                body: body,
                headers: headers,
                query: query,
                contentType: 'application/json')
            .timeout(durationTimeout);
      case HttpMethods.PATCH:
        return await httpClient
            .patch(path,
                body: body,
                headers: headers,
                query: query,
                contentType: 'application/json')
            .timeout(durationTimeout);
      case HttpMethods.DELETE:
        return await httpClient
            .delete(path,
                headers: headers, query: query, contentType: 'application/json')
            .timeout(durationTimeout);
    }
  }

  String _formatQueries(Map<String, dynamic> queries) {
    String _queries =
        queries.entries.map((e) => '${e.key}=${e.value}').toList().join('&');
    return _queries.isNotEmpty ? '?$_queries' : '';
  }
}
