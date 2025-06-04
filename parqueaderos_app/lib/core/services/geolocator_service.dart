// parqueaderos_app/lib/core/services/geolocator_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'location_service_result.dart'; // Importar los nuevos tipos de resultado

final Logger _logger = Logger('GeolocatorService');

@lazySingleton
class GeolocatorService {
  GeolocatorService() {
    _logger.info("GeolocatorService inicializado");
  }

  /// Determina la posición actual del dispositivo.
  /// Devuelve un [LocationServiceResult] que puede ser [LocationSuccess] o [LocationFailure].
  Future<LocationServiceResult> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verifica si los servicios de ubicación están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.warning('Los servicios de ubicación están deshabilitados.');
      return LocationFailure(
        LocationFailureReason.serviceDisabled,
        'Los servicios de ubicación (GPS) están desactivados. Por favor, actívalos para continuar.',
      );
    }

    // 2. Verifica y solicita permisos de ubicación.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      _logger.info('Permiso de ubicación denegado, solicitando...');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _logger.warning('El usuario denegó el permiso de ubicación.');
        return LocationFailure(
          LocationFailureReason.permissionDenied,
          'Se necesita permiso de ubicación para encontrar parqueaderos cercanos. Por favor, concede el permiso.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _logger
          .severe('El usuario denegó permanentemente el permiso de ubicación.');
      return LocationFailure(
        LocationFailureReason.permissionDeniedForever,
        'El permiso de ubicación fue denegado permanentemente. Debes habilitarlo desde la configuración de la aplicación.',
      );
    }

    // Si llegamos aquí, los permisos son whileInUse o always.
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _logger.info('Permisos concedidos, obteniendo ubicación actual...');
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return LocationSuccess(position);
      } catch (e) {
        _logger.severe('Error al obtener la ubicación: $e');
        return LocationFailure(
          LocationFailureReason.unknownError,
          'No se pudo obtener la ubicación: ${e.toString()}',
        );
      }
    }

    // Caso inesperado si el permiso no es ninguno de los anteriores (aunque no debería ocurrir con la lógica actual)
    _logger.warning('Estado de permiso de ubicación inesperado: $permission');
    return LocationFailure(
      LocationFailureReason.unknownError,
      'Ocurrió un error inesperado con los permisos de ubicación.',
    );
  }

  /// Abre la configuración de ubicación del sistema.
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Abre la configuración de la aplicación.
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
// Este servicio ahora maneja los permisos y errores de ubicación de manera más robusta,
// proporcionando un resultado claro que puede ser manejado por la UI o el controlador de estado.
