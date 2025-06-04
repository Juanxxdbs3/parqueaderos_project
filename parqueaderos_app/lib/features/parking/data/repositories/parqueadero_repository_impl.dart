import 'package:parqueaderos_app/features/parking/data/datasources/parking_remote_datasource.dart';
import 'package:parqueaderos_app/features/parking/domain/entities/parqueadero_entity.dart';
import 'package:parqueaderos_app/core/error/failures.dart';
import 'package:parqueaderos_app/features/parking/domain/repositories/parqueadero_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:parqueaderos_app/core/error/exceptions.dart';
import 'package:parqueaderos_app/core/platform/network_info.dart'; // Para verificar conexión
import 'package:injectable/injectable.dart';

@LazySingleton(as: ParqueaderoRepository) // Registra esta implementación
class ParqueaderoRepositoryImpl implements ParqueaderoRepository {
  final ParkingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ParqueaderoRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ParqueaderoEntity>>> getParqueaderosCercanos(
    double lat,
    double lon, {
    int radio = 5000, // Valor por defecto si no se provee
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteParkings = await remoteDataSource.getParqueaderosCercanos(lat, lon, radio: radio);
        // ParqueaderoModel hereda de ParqueaderoEntity, así que la conversión es directa.
        return Right(remoteParkings);
      } on ServerException catch (e) {
        return Left(ServerFailure('Error del servidor: ${e.message} (Código: ${e.statusCode})'));
      } on NetworkException catch (e) { // Captura NetworkException del datasource
        return Left(NetworkFailure(e.message));
      }
       catch (e) { // Captura cualquier otra excepción inesperada del datasource
        return Left(ServerFailure('Error inesperado al procesar la solicitud: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure("No hay conexión a internet. Por favor, verifica tu conexión."));
    }
  }

  // @override
  // Future<Either<Failure, List<ParqueaderoEntity>>> buscarParqueaderos(String termino) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       // final remoteParkings = await remoteDataSource.buscarParqueaderosPorTermino(termino);
  //       // return Right(remoteParkings);
  //       throw UnimplementedError("buscarParqueaderos no implementado en el datasource");
  //     } on ServerException catch (e) {
  //       return Left(ServerFailure(e.message));
  //     }
  //   } else {
  //     return Left(NetworkFailure("No hay conexión a internet."));
  //   }
  // }
}
