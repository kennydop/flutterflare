class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred'])
      : super(message, code: 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException([String message = 'Authentication error occurred'])
      : super(message, code: 'AUTH_ERROR');
}

class ValidationException extends AppException {
  ValidationException([String message = 'Validation error occurred'])
      : super(message, code: 'VALIDATION_ERROR');
}

class ServerException extends AppException {
  ServerException([String message = 'Server error occurred'])
      : super(message, code: 'SERVER_ERROR');
}

class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred'])
      : super(message, code: 'CACHE_ERROR');
}

class UnknownException extends AppException {
  UnknownException([String message = 'An unknown error occurred'])
      : super(message, code: 'UNKNOWN_ERROR');
}
