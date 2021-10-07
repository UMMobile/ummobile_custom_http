import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';

// The Exception that is thrown if an error ocurrs
class HttpCallException implements Exception {
  /// The type of Exception.
  ///
  /// Can be: `ClientError`, `ServerError`, `ClientConnectionError` or `RequestTimeout` as shown in the table below:
  ///
  /// |Type                      | Case                                        |
  /// |--------------------------|---------------------------------------------|
  /// | `ClientError`            | When the status code is between 300 and 499 |
  /// | `ServerError`            | When the status code is between 500 and 599 |
  /// | `ClientConnectionError`  | When the status code is null                |
  /// | `RequestTimeout`         | When a request timeout occurs               |
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
      case HttpExceptions.ClientConnectionError:
        return 'clientConnectionError';
      case HttpExceptions.ServerError:
        return 'serverError';
      case HttpExceptions.RequestTimeout:
        return 'requestTimeout';
      case HttpExceptions.Other:
        return 'other';
    }
  }
}
