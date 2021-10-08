Custom HTTP client for the UMMobile app

# Getting Started
## Initialization
A base URL and a static authorization can be defined in the initialization.
```dart
// Simple initalization
final http = UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');

// Initialiation with authentication
final http = UMMobileCustomHttp(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  auth: Auth(
    token: () => 'YOUR_TOKEN',
    tokenType: 'Bearer',
    headername: 'Authorization',
  ),
);
```

## HTTP Calls
To make a call you need to use the function that start with `custom`.
```dart
final http = UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');\

await http.customGet(path: '/posts/1');
await http.customPost(path: '/posts/1', body: {});
await http.customDelete(path: '/posts/1');
```

You can also pass a mapper function to format the response body and return a specific type.
```dart
final http = UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');

// Return a Post instance
await http.customGet<Post>(
  path: '/posts/1',
  mapper: (json) => Post(
    userId: json['userId'],
    id: json['id'],
    title: json['title'],
    body: json['body'],
  ),
);
```

## Exceptions
Throws an `HttpCallException` if an error occurs. The `HttpCallException` contains a `type` attribute that can be as shown in the list below:

- `ClientError`: when the status code is between 300 and 499.
- `ServerError`: when the status code is between 500 and 599.
- `ConnectionError`: when a connection error occurs and cannot be specified.
- `ServerDown`: when cannot connect to the backend.
- `ClientOffline`: when cannot connect to `yahoo.com`.
- `Other`: when any other `Exception` occurs.

You can use the Exception like:
```dart
final http = UMMobileCustomHttp(baseUrl: 'https://jsonplaceholder.typicode.com');
try {
  await http.customGet(path: '/posts/1');
} on HttpCallException catch(e) {
  if(e.type === HttpException.ClientOffline) {
    // display that the client have no connection
  }
}
```
