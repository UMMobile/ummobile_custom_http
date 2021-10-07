/// Auth configuration
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

  Auth({
    required this.token,
    this.tokenType: 'Bearer',
    this.headerName: 'Authorization',
  });
}
