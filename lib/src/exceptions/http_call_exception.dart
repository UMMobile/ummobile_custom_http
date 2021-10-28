import 'package:get/get_connect.dart';
import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';

export 'client_error_exception.dart';
export 'connection_error_exception.dart';
export 'server_error_exception.dart';

// The Exception that is thrown if an error ocurrs.
class HttpCallException implements Exception {
  /// The type of Exception.
  ///
  /// Can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ExpiredToken`           | When access token is expired & need to be refresh      |
  /// | `Unauthorized`           | When an error occurred with the authorization          |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `Other`                  | When any other `Exception` occurs                      |
  HttpExceptions type;

  /// The information useful to manage exception.
  Map<String, dynamic> extras;

  /// The response from the call.
  String message;

  /// The response from the call.
  Response? response;

  /// The constructor for the exception.
  ///
  /// Receive the [type] of the exception and [extras] values that can be used to manage the exception.
  HttpCallException(
    HttpExceptions? type, {
    this.message: '',
    this.response,
    Map<String, dynamic>? extras,
  })  : this.type = type ?? HttpExceptions.Other,
        this.extras = extras ?? const {};

  @override
  String toString() {
    switch (this.type) {
      case HttpExceptions.ClientError:
        return 'ClientError';
      case HttpExceptions.ServerError:
        return 'ServerError';
      case HttpExceptions.ConnectionError:
        return 'ConnectionError';
      case HttpExceptions.ServerDown:
        return 'ServerDown';
      case HttpExceptions.ClientOffline:
        return 'ClientOffline';
      case HttpExceptions.ExpiredToken:
        return 'ExpiredToken';
      case HttpExceptions.Unauthorized:
        return 'Unauthorized';
      case HttpExceptions.Other:
        return 'Other';
    }
  }
}
