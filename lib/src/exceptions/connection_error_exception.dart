import 'package:get/get_connect.dart';
import 'package:ummobile_custom_http/src/enums/http_exceptions.dart';
import 'package:ummobile_custom_http/ummobile_custom_http.dart';

/// The Exception that is thrown if a connection error ocurrs.
class ConnectionErrorException implements HttpCallException {
  /// The type of Exception.
  ///
  /// Can be as shown in the table below:
  ///
  /// |Type                      | Case                                                   |
  /// |--------------------------|--------------------------------------------------------|
  /// | `ServerDown`             | When cannot connect to the backend                     |
  /// | `ClientOffline`          | When cannot connect to `yahoo.com`                     |
  @override
  HttpExceptions type;

  /// The information useful to manage exception.
  @override
  Map<String, dynamic> extras;

  /// The response from the call.
  @override
  String message;

  /// The response from the call.
  ///
  /// **It is not used for this exception.**
  @override
  Response? response;

  /// The constructor for the connection error general exception.
  ///
  /// Can receive a [message] and [extras] values that can be used to manage the exception.
  ConnectionErrorException({
    this.message: '',
    this.extras: const {},
  }) : this.type = HttpExceptions.ConnectionError;

  /// The constructor for the server down exception.
  ///
  /// Can receive a [message] and [extras] values that can be used to manage the exception.
  ConnectionErrorException.serverDown({
    this.message: '',
    this.extras: const {},
  }) : this.type = HttpExceptions.ServerDown;

  /// The constructor for the client offline exception.
  ///
  /// Can receive a [message] and [extras] values that can be used to manage the exception.
  ConnectionErrorException.clientOffline({
    this.message: '',
    this.extras: const {},
  }) : this.type = HttpExceptions.ClientOffline;
}
