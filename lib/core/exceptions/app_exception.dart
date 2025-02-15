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
  NetworkException([super.message = 'Network error occurred'])
      : super(code: 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException([super.message = 'Authentication error occurred'])
      : super(code: 'AUTH_ERROR');
}

class ValidationException extends AppException {
  ValidationException([super.message = 'Validation error occurred'])
      : super(code: 'VALIDATION_ERROR');
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred'])
      : super(code: 'SERVER_ERROR');
}

class CacheException extends AppException {
  CacheException([super.message = 'Cache error occurred'])
      : super(code: 'CACHE_ERROR');
}

class UnknownException extends AppException {
  UnknownException([super.message = 'An unknown error occurred'])
      : super(code: 'UNKNOWN_ERROR');
}
