import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parqueaderos_app/features/parking/data/models/parqueadero_model.dart'; // Crea este modelo
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ParkingApiService {
  // Carga la URL base de tu API desde .env o una constante
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api'; // Ejemplo

  Future<List<ParqueaderoModel>> getParqueaderosCercanos(double lat, double lon, {int radio = 5000}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/parqueaderos/cercanos?lat=$lat&lon=$lon&radio=$radio'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ParqueaderoModel> parqueaderos = body.map((dynamic item) => ParqueaderoModel.fromJson(item)).toList();
      return parqueaderos;
    } else {
      throw Exception('Fallo al cargar parqueaderos: ${response.body}');
    }
  }

  // Implementa aquí la llamada a Nominatim si decides hacerlo desde el cliente
  // Future<LatLng?> getCoordsFromAddress(String address) async { ... }
}