// parqueaderos_app/lib/core/services/location_service_result.dart
import 'package:geolocator/geolocator.dart'; // Para el tipo Position

// Enum para los diferentes estados de fallo de ubicación
enum LocationFailureReason {
  serviceDisabled, // Los servicios de ubicación (GPS) están desactivados
  permissionDenied, // El usuario denegó el permiso una vez
  permissionDeniedForever, // El usuario denegó el permiso permanentemente
  unknownError, // Otro error
}

// Clase base sellada para los resultados del servicio de ubicación
abstract class LocationServiceResult {}

// Representa un resultado exitoso con la posición
class LocationSuccess extends LocationServiceResult {
  final Position position;
  LocationSuccess(this.position);
}

// Representa un fallo al obtener la ubicación
class LocationFailure extends LocationServiceResult {
  final LocationFailureReason reason;
  final String message; // Mensaje descriptivo del error o guía para el usuario

  LocationFailure(this.reason, this.message);
}
