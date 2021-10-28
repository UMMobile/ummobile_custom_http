import 'package:get/get_connect.dart';
import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';
import 'package:ummobile_custom_http/ummobile_custom_http.dart';

/// The Exception that is thrown if a server error ocurrs.
class ServerErrorException implements HttpCallException {
  /// The type of Exception.
  ///
  /// Can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ServerError`            | When the status code is between 500 and 599            |
  @override
  HttpExceptions type;

  /// The information useful to manage exception.
  @override
  Map<String, dynamic> extras;

  /// The response from the call.
  @override
  String message;

  /// The response from the call.
  @override
  Response? response;

  /// The constructor for the server error general exception.
  ///
  /// Can receive the [response] of the HTTP call, a [message], and [extras] values that can be used to manage the exception.
  ServerErrorException(
    this.response, {
    this.message: '',
    this.extras: const {},
  }) : this.type = HttpExceptions.ServerError;
}
