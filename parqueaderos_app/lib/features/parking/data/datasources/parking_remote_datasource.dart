import 'dart:convert';
import 'dart:io'; // Para SocketException
import 'package:http/http.dart' as http;
import 'package:parqueaderos_app/features/parking/data/models/parqueadero_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parqueaderos_app/core/error/exceptions.dart';
import 'package:injectable/injectable.dart';

abstract class ParkingRemoteDataSource {
  /// Llama al endpoint GET /parqueaderos/cercanos.
  ///
  /// Lanza una [ServerException] para todos los códigos de error.
  /// Lanza una [NetworkException] si hay problemas de red.
  Future<List<ParqueaderoModel>> getParqueaderosCercanos(double lat, double lon, {int radio});
  
  /// Llama al endpoint GET /parqueaderos/buscar?termino=xxx (Ejemplo para Nominatim/búsqueda por texto)
  ///
  /// Lanza una [ServerException] para todos los códigos de error.
  /// Lanza una [NetworkException] si hay problemas de red.
  // Future<List<ParqueaderoModel>> buscarParqueaderosPorTermino(String termino);
}

@LazySingleton(as: ParkingRemoteDataSource) // Registra esta implementación para la inyección
class ParkingRemoteDataSourceImpl implements ParkingRemoteDataSource {
  final http.Client client;
  late final String _baseUrl;

  ParkingRemoteDataSourceImpl({required this.client}) {
    _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
    if (_baseUrl.isEmpty) {
        throw Exception("API_BASE_URL no está configurada en el archivo .env");
    }
  }

  @override
  Future<List<ParqueaderoModel>> getParqueaderosCercanos(double lat, double lon, {int radio = 5000}) async {
    final uri = Uri.parse('$_baseUrl/parking/cercanos?lat=$lat&lon=$lon&radio=$radio');
    try {
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 15)); // Timeout para la petición

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes)); // Decodificar como UTF-8
        return jsonData.map((item) => ParqueaderoModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(
          message: 'Error del servidor al obtener parqueaderos: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Error de red: No se pudo conectar al servidor. Verifica tu conexión a internet y la URL base de la API: $uri');
    } on http.ClientException catch (e) { // Captura otros errores de HTTP
      throw NetworkException(message: 'Error de cliente HTTP: ${e.message}. URI: $uri');
    } on ServerException { // Relanzar ServerException si ya fue capturada
      rethrow;
    }
     catch (e) { // Captura cualquier otra excepción inesperada
      throw ServerException(message: 'Error inesperado al obtener parqueaderos: ${e.toString()}. URI: $uri');
    }
  }

  // @override
  // Future<List<ParqueaderoModel>> buscarParqueaderosPorTermino(String termino) async {
  //   // Implementación similar para búsqueda por término si tu API lo soporta
  //   // o si llamas a Nominatim directamente (aunque es mejor desde el backend).
  //   final uri = Uri.parse('$_baseUrl/parking/buscar?q=${Uri.encodeComponent(termino)}');
  //   // ... lógica de petición y manejo de errores ...
  //   throw UnimplementedError();
  // }
}
