class ServerException implements Exception {
  final String? message;
  final String? code;
  
  const ServerException({
    this.message,
    this.code,
  });
  
  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String? message;
  final String? code;
  
  const NetworkException({
    this.message,
    this.code,
  });
  
  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String? message;
  final String? code;
  
  const ValidationException({
    this.message,
    this.code,
  });
  
  @override
  String toString() => 'ValidationException: $message';
}

class CacheException implements Exception {
  final String? message;
  final String? code;
  
  const CacheException({
    this.message,
    this.code,
  });
  
  @override
  String toString() => 'CacheException: $message';
}