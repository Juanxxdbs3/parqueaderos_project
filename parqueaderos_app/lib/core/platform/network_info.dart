// parqueaderos_app/lib/core/platform/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart'; // Importar connectivity_plus
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  // Inyecta Connectivity o créalo aquí
  NetworkInfoImpl(this._connectivity);
  // O si no quieres inyectar Connectivity:
  // NetworkInfoImpl() : _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    // Verifica si la lista de resultados contiene alguna conexión activa (móvil, wifi, ethernet)
    // Se excluye 'none' y 'bluetooth' como conexiones de red principales para API calls.
    // 'other' es un caso ambiguo, podría o no tener internet.
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }
}
