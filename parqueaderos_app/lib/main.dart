import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:parqueaderos_app/features/parking/presentation/pages/home_page.dart';
import 'package:parqueaderos_app/features/parking/presentation/pages/login_page.dart';
import 'package:parqueaderos_app/core/services/geolocator_service.dart';
import 'package:parqueaderos_app/core/services/location_service_result.dart';
import 'package:parqueaderos_app/config/injectors/dependency_injector.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  configureDependencies();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}, StackTrace: ${record.stackTrace}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GeolocatorService geolocatorService = getIt<GeolocatorService>();

    return FutureProvider<LocationServiceResult?>(
      create: (context) => geolocatorService.getCurrentLocation(),
      initialData: null,
      catchError: (context, error) {
        Logger('MyApp').severe('Error en FutureProvider create: $error');
        return LocationFailure(LocationFailureReason.unknownError,
            "Error inicializando el servicio de ubicación.");
      },
      child: MaterialApp(
        title: 'ParkItNow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(), // <-- Cambia aquí a LoginPage
      ),
    );
  }
}
