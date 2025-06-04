/// Representa excepciones que ocurren durante llamadas al servidor.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() {
    return 'ServerException: $message (Status Code: ${statusCode ?? 'N/A'})';
  }
}

/// Representa excepciones relacionadas con la caché local (si la implementas).
class CacheException implements Exception {
   final String message;
   CacheException({required this.message});
    @override
  String toString() {
    return 'CacheException: $message';
  }
}

/// Excepción para cuando no hay conexión a internet.
class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = "No hay conexión a internet. Por favor, verifica tu conexión."});
   @override
  String toString() {
    return 'NetworkException: $message';
  }
}
