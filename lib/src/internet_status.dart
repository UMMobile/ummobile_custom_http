import 'dart:io';

import 'package:ummobile_custom_http/ummobile_custom_http.dart';

/// Check the error type with the internet connection.
///
/// Returns the exception that occurs which can be `HttpExceptions.ServerDown`, `HttpExceptions.ClientOffline`, or `HttpExceptions.ConnectionError` by default.
///
/// If cannot connect to the backend specified with the [checkUrl] try to connect to `yahoo.com` to see if the cellphone have internet connection.
///
/// Also, a custom [timeout] for the internet connection tests can be set (default `5 seconds`).
Future<HttpExceptions> checkInternetConnection(
  String checkUrl, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  HttpExceptions? status;

  final umEndpoint =
      await InternetAddress.lookup(checkUrl).timeout(timeout).onError(
    (error, stackTrace) {
      status = HttpExceptions.ServerDown;
      return [];
    },
  );

  if (umEndpoint.isEmpty || umEndpoint[0].rawAddress.isEmpty) {
    await InternetAddress.lookup('yahoo.com').timeout(timeout).onError(
      (error, stackTrace) {
        status = HttpExceptions.ClientOffline;
        return [];
      },
    );
  }

  return status ?? HttpExceptions.ConnectionError;
}
