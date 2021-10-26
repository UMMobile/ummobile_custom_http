import 'package:jwt_decode/jwt_decode.dart';

/// Auth configuration.
///
/// Rigth now only support JWT authorization.
class Auth {
  /// Function to get the token.
  ///
  /// The token can be processed as long as it is synchronous to avoid errors.
  String Function() token;

  /// The type of token (default "Bearer").
  ///
  /// This attribute will be concatenated in the header value. To avoid the concatenation (for example with an API key) set the field to empty string: `''`
  ///
  /// Example:
  /// If the [tokenType] is "Bearer" the the header value will be something like: `"Bearer the_token_defined"`.
  String tokenType;

  /// The name that will have in the header (default "Authorization").
  ///
  /// Example:
  /// If the [headerName] is set to "apiKey" the token type and the token will be set to the headers with the key `"apiKey"`.
  String headerName;

  /// The Auth constructor.
  ///
  /// Require a [token] that is a function that returns a String that will be the value of the authorization header.
  ///
  /// Also can receive a [tokenType] that will be used in the value of the authorization header. And the [headerName] that will be the key in the header.
  Auth({
    required this.token,
    this.tokenType: 'Bearer',
    this.headerName: 'Authorization',
  }) {
    // Test if is a valid token.
    Jwt.parseJwt(this.token());
  }

  /// Returns the header value formmated mixing [this.tokenType] and the returned value of [this.token()].
  ///
  /// If [this.tokenType] is empty then only return the returned value of [this.token()].
  String get format =>
      this.tokenType.isNotEmpty ? '$this.tokenType $token()' : this.token();
}
