import 'package:parqueaderos_app/features/parking/domain/entities/parqueadero_entity.dart';
import 'package:parqueaderos_app/features/parking/domain/repositories/parqueadero_repository.dart';
import 'package:parqueaderos_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Interfaz base para casos de uso (opcional, pero buena práctica)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

@lazySingleton // Registra el caso de uso para inyección
class GetParqueaderosCercanosUseCase implements UseCase<List<ParqueaderoEntity>, GetParqueaderosParams> {
  final ParqueaderoRepository repository;

  GetParqueaderosCercanosUseCase(this.repository);

  @override
  Future<Either<Failure, List<ParqueaderoEntity>>> call(GetParqueaderosParams params) async {
    return await repository.getParqueaderosCercanos(
      params.lat,
      params.lon,
      radio: params.radio,
    );
  }
}

class GetParqueaderosParams extends Equatable {
  final double lat;
  final double lon;
  final int radio; // en metros

  const GetParqueaderosParams({
    required this.lat,
    required this.lon,
    this.radio = 5000, // Valor por defecto
  });

  @override
  List<Object?> get props => [lat, lon, radio];
}
