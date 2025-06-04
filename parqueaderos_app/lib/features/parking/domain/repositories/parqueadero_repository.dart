import 'package:parqueaderos_app/features/parking/domain/entities/parqueadero_entity.dart';
import 'package:parqueaderos_app/core/error/failures.dart';
import 'package:dartz/dartz.dart'; // Para el manejo funcional de errores (Either)

abstract class ParqueaderoRepository {
  /// Obtiene una lista de [ParqueaderoEntity] cercanos a la [lat] y [lon] dadas,
  /// dentro de un [radio] en metros.
  /// Devuelve [ServerFailure] o [NetworkFailure] en caso de error.
  Future<Either<Failure, List<ParqueaderoEntity>>> getParqueaderosCercanos(
    double lat,
    double lon, {
    int radio,
  });

  /// Busca parqueaderos basado en un [termino] de búsqueda (ej. nombre, dirección).
  /// Podría interactuar con Nominatim a través del backend o directamente.
  /// Devuelve [ServerFailure] o [NetworkFailure] en caso de error.
  // Future<Either<Failure, List<ParqueaderoEntity>>> buscarParqueaderos(String termino);
}
