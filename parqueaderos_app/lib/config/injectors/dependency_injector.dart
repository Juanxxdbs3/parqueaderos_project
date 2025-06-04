import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
// No necesitas importar GeolocatorService aquí si está anotado con @lazySingleton y tiene un constructor por defecto.
// Injectable se encargará de encontrarlo y registrarlo.

// Importa el archivo generado por injectable (tendrá el mismo nombre con .config.dart)
// Este import dará error hasta que ejecutes build_runner por primera vez.
import 'dependency_injector.config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // nombre de la función generada
  preferRelativeImports:
      true, // usa importaciones relativas en el archivo generado
  asExtension: false, // genera una función top-level en lugar de una extensión
)
void configureDependencies() =>
    init(getIt); // Llama a la función generada `init`

// Módulo para registrar dependencias de terceros o clases que necesitan configuración especial.
@module
abstract class RegisterModule {
  // Registra http.Client para que pueda ser inyectado donde se necesite.
  // Es un singleton diferido, se crea solo cuando se solicita por primera vez.
  @lazySingleton
  http.Client get httpClient => http.Client();

  @lazySingleton // Registra Connectivity como un singleton diferido.
  Connectivity get connectivity => Connectivity();
  // GeolocatorService ahora está anotado con @lazySingleton,
  // por lo que injectable lo encontrará y registrará automáticamente.
  // No necesitas registrarlo explícitamente aquí si tiene un constructor por defecto
  // y está anotado.
  // Si tuviera dependencias en su constructor que no son inyectables,
  // o si no pudieras anotarlo directamente, lo registrarías aquí:
  // @lazySingleton
  // GeolocatorService get geolocatorService => GeolocatorService();
}
