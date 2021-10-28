import 'dart:io';

import 'package:ummobile_custom_http/src/exceptions/connection_error_exception.dart';

/// Throw a internet connection exception.
///
/// The type of the exception can be `HttpExceptions.ServerDown`, `HttpExceptions.ClientOffline`, or `HttpExceptions.ConnectionError` by default.
///
/// If cannot connect to the backend specified with the [checkUrl] try to connect to `yahoo.com` to see if the cellphone have internet connection.
///
/// Also, a custom [timeout] for the internet connection tests can be set (default `5 seconds`).
Future<void> throwConnectionException(
  String checkUrl, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final umEndpoint =
      await InternetAddress.lookup(checkUrl).timeout(timeout).onError(
    (error, stackTrace) {
      throw ConnectionErrorException.serverDown();
    },
  );

  if (umEndpoint.isEmpty || umEndpoint[0].rawAddress.isEmpty) {
    await InternetAddress.lookup('yahoo.com').timeout(timeout).onError(
      (error, stackTrace) {
        throw ConnectionErrorException.clientOffline();
      },
    );
  }

  throw ConnectionErrorException();
}
