/// The possible exceptions types
enum HttpExceptions {
  // Client errors
  ClientError,
  ExpiredToken,
  Unauthorized,
  // Server errors
  ServerError,
  // Connection errors
  ConnectionError,
  ServerDown,
  ClientOffline,
  // Others
  Other,
}
