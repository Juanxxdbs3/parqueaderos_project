// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart'; // Agrega este import
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/platform/network_info.dart' as _i50;
import '../../core/services/geolocator_service.dart' as _i744;
import '../../features/parking/data/datasources/parking_remote_datasource.dart'
    as _i828;
import '../../features/parking/data/repositories/parqueadero_repository_impl.dart'
    as _i655;
import '../../features/parking/domain/repositories/parqueadero_repository.dart'
    as _i57;
import '../../features/parking/domain/usecases/get_parqueaderos_cercanos_usecase.dart'
    as _i356;
import 'dependency_injector.dart' as _i93;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
  gh.lazySingleton<_i744.GeolocatorService>(() => _i744.GeolocatorService());
  gh.lazySingleton<Connectivity>(
      () => Connectivity()); // Añade esta línea antes de NetworkInfoImpl
  gh.lazySingleton<_i50.NetworkInfo>(
    () => _i50.NetworkInfoImpl(
        gh<Connectivity>()), // Pasa la instancia de Connectivity
  );
  gh.lazySingleton<_i828.ParkingRemoteDataSource>(
      () => _i828.ParkingRemoteDataSourceImpl(client: gh<_i519.Client>()));
  gh.lazySingleton<_i57.ParqueaderoRepository>(
      () => _i655.ParqueaderoRepositoryImpl(
            remoteDataSource: gh<_i828.ParkingRemoteDataSource>(),
            networkInfo: gh<_i50.NetworkInfo>(),
          ));
  gh.lazySingleton<_i356.GetParqueaderosCercanosUseCase>(() =>
      _i356.GetParqueaderosCercanosUseCase(gh<_i57.ParqueaderoRepository>()));
  return getIt;
}

class _$RegisterModule extends _i93.RegisterModule {}
