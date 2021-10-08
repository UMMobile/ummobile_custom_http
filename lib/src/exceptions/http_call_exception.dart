import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';

// The Exception that is thrown if an error ocurrs
class HttpCallException implements Exception {
  /// The type of Exception.
  ///
  /// Can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499            |
  /// | `ServerError`            | When the status code is between 500 and 599            |
  /// | `ConnectionError`        | When a connection error occurs and cannot be specified |
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  /// | `Other`                  | When any other `Exception` occurs                      |
  HttpExceptions type;

  /// The constructor for the exception.
  ///
  /// Receive the [type] of the exception.
  HttpCallException(HttpExceptions? type)
      : this.type = type ?? HttpExceptions.Other;

  @override
  String toString() {
    switch (this.type) {
      case HttpExceptions.ClientError:
        return 'clientError';
      case HttpExceptions.ServerError:
        return 'serverError';
      case HttpExceptions.ConnectionError:
        return 'connectionError';
      case HttpExceptions.ServerDown:
        return 'serverDown';
      case HttpExceptions.ClientOffline:
        return 'clientOffline';
      case HttpExceptions.Other:
        return 'other';
    }
  }
}
