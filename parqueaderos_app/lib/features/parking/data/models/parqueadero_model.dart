import 'package:latlong2/latlong.dart' as latlng;
import 'package:parqueaderos_app/features/parking/domain/entities/parqueadero_entity.dart';
//import 'package:injectable/injectable.dart'; // Si necesitas inyectar algo aquí

// No es necesario anotar modelos con @injectable a menos que tengan dependencias inyectables
// o sean ellos mismos inyectados, lo cual es menos común para modelos puros.

class ParqueaderoModel extends ParqueaderoEntity {
  const ParqueaderoModel({
    required super.id,
    required super.nombre,
    required super.direccion,
    required super.ubicacion,
    required super.disponibles,
    required super.capacidadTotal,
    super.horario,
    super.tarifaPorHora,
  });

  factory ParqueaderoModel.fromJson(Map<String, dynamic> json) {
    // Valida y extrae las coordenadas de forma segura
    final List<dynamic> coordinates = json['location']?['coordinates'] ?? [0.0, 0.0];
    double longitude = 0.0;
    double latitude = 0.0;
    if (coordinates.length == 2) {
      longitude = (coordinates[0] as num?)?.toDouble() ?? 0.0;
      latitude = (coordinates[1] as num?)?.toDouble() ?? 0.0;
    }

    return ParqueaderoModel(
      id: json['_id'] as String? ?? '', // MongoDB usa _id
      nombre: json['nombre'] as String? ?? 'Nombre no disponible',
      direccion: json['direccion'] as String? ?? 'Dirección no disponible',
      ubicacion: latlng.LatLng(latitude, longitude), // Latitud, Longitud
      disponibles: (json['disponibles'] as num?)?.toInt() ?? 0,
      capacidadTotal: (json['capacidadTotal'] as num?)?.toInt() ?? (json['capacidad'] as num?)?.toInt() ?? 0, // Incluye 'capacidad' como fallback
      horario: json['horario'] as String?,
      tarifaPorHora: (json['tarifaPorHora'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'direccion': direccion,
      'location': {
        'type': 'Point', // GeoJSON format
        'coordinates': [ubicacion.longitude, ubicacion.latitude], // Longitud, Latitud
      },
      'disponibles': disponibles,
      'capacidadTotal': capacidadTotal,
      'horario': horario,
      'tarifaPorHora': tarifaPorHora,
    };
  }
}
