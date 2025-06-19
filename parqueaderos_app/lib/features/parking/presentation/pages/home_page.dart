import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:parqueaderos_app/config/injectors/dependency_injector.dart';
import 'package:parqueaderos_app/core/services/geolocator_service.dart';
import 'package:parqueaderos_app/core/services/location_service_result.dart';
import 'package:parqueaderos_app/features/parking/domain/entities/parqueadero_entity.dart';
import 'package:parqueaderos_app/features/parking/domain/usecases/get_parqueaderos_cercanos_usecase.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:parqueaderos_app/features/parking/presentation/pages/search_parkinglot.dart';

final Logger _logger = Logger('HomePage');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  List<ParqueaderoEntity> _parqueaderosCercanos = [];
  bool _isLoadingParkings = false;
  String? _apiErrorMessage;
  ParqueaderoEntity? _selectedParking;

  late final GetParqueaderosCercanosUseCase _getParqueaderosCercanosUseCase;
  late final GeolocatorService _geolocatorService;

  latlng.LatLng? _currentMapCenter;

  // Controla el estado del panel de detalles
  final ValueNotifier<double> _panelExtent = ValueNotifier(0.08);

  @override
  void initState() {
    super.initState();
    _getParqueaderosCercanosUseCase = getIt<GetParqueaderosCercanosUseCase>();
    _geolocatorService = getIt<GeolocatorService>();
  }

  Future<void> _fetchNearbyParkings(double lat, double lon) async {
    if (!mounted) return;
    setState(() {
      _isLoadingParkings = true;
      _apiErrorMessage = null;
    });
    _logger.info('Buscando parqueaderos cercanos a Lat: $lat, Lon: $lon');

    final result = await _getParqueaderosCercanosUseCase(
      GetParqueaderosParams(lat: lat, lon: lon, radio: 5000),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        _logger.severe(
            'Error al obtener parqueaderos de la API: ${failure.message}');
        setState(() {
          _apiErrorMessage = failure.message;
          _parqueaderosCercanos = [];
          _isLoadingParkings = false;
        });
      },
      (parqueaderos) {
        _logger.info('${parqueaderos.length} parqueaderos encontrados.');
        setState(() {
          _parqueaderosCercanos = parqueaderos;
          _isLoadingParkings = false;
        });
      },
    );
  }

  void _updateMapCenterAndFetchParkings(latlng.LatLng newCenter) {
    if (_currentMapCenter != newCenter) {
      _currentMapCenter = newCenter;
      _logger.info(
          'Actualizando centro del mapa y buscando parqueaderos: Lat: ${newCenter.latitude}, Lon: ${newCenter.longitude}');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            _mapController.move(newCenter, 15.0);
          } catch (e) {
            _logger.warning("MapController no estaba listo para mover: $e");
          }
        }
      });
      _fetchNearbyParkings(newCenter.latitude, newCenter.longitude);
    }
  }

  // Abre el Drawer de perfil (derecha)
  void _openProfileDrawer() {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final locationResult = Provider.of<LocationServiceResult?>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Opciones', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de Pagos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Comprar plan'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.local_parking),
              title: const Text('Ver historial de parqueos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      endDrawer: _buildProfileDrawer(context),
      appBar: AppBar(
        title: const Text('ParkItNow'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(child: Icon(Icons.person)),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Caja de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchParkingLotPage(),
                  ),
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar parqueadero...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  enabled: false, // Para que solo funcione el onTap
                ),
              ),
            ),
          ),
          // El resto del body original
          Expanded(child: _buildBody(locationResult)),
        ],
      ),
      floatingActionButton:
          (locationResult is LocationSuccess && _currentMapCenter != null)
              ? FloatingActionButton(
                  onPressed: () {
                    try {
                      _mapController.move(
                        latlng.LatLng(locationResult.position.latitude,
                            locationResult.position.longitude),
                        15.0,
                      );
                    } catch (e) {
                      _logger.warning(
                          "MapController no estaba listo para mover en FAB: $e");
                    }
                  },
                  tooltip: 'Centrar en mi ubicación actual',
                  child: const Icon(Icons.my_location),
                )
              : null,
    );
  }

  Widget _buildBody(LocationServiceResult? locationResult) {
    if (locationResult == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Obteniendo tu ubicación inicial...'),
          ],
        ),
      );
    }

    if (locationResult is LocationSuccess) {
      final currentPosition = locationResult.position;
      final newCenterForMap =
          latlng.LatLng(currentPosition.latitude, currentPosition.longitude);

      if (_currentMapCenter == null ||
          _currentMapCenter!.latitude != newCenterForMap.latitude ||
          _currentMapCenter!.longitude != newCenterForMap.longitude) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateMapCenterAndFetchParkings(newCenterForMap);
          }
        });
      }

      final screenHeight = MediaQuery.of(context).size.height;

      return Stack(
        children: [
          // Mapa (2/3 superior)
          SizedBox(
            height: screenHeight,
            width: double.infinity,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentMapCenter ?? newCenterForMap,
                initialZoom: 15.0,
                // Habilita gestos de usuario
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedParking = null;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.parqueaderos_app',
                ),
                MarkerLayer(
                  markers: _buildMarkers(currentPosition),
                ),
              ],
            ),
          ),
          // Panel deslizable de detalles (ANCLADO ABAJO)
          DraggableScrollableSheet(
            initialChildSize: 0.12, // Más visible
            minChildSize: 0.12,
            maxChildSize: 0.66,
            expand: false,
            builder: (context, scrollController) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.08 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Cortina visible
                    GestureDetector(
                      onTap: () {
                        // Opcional: puedes expandir/retraer el panel aquí si quieres
                      },
                      child: Container(
                        width: 40,
                        height: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: _selectedParking != null
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_selectedParking!.nombre,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    const SizedBox(height: 8),
                                    Text(_selectedParking!.direccion),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.event_available,
                                            size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                            'Disponibles: ${_selectedParking!.disponibles} / ${_selectedParking!.capacidadTotal}'),
                                      ],
                                    ),
                                    if (_selectedParking!.tarifaPorHora !=
                                        null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.payments_outlined,
                                              size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                              'Tarifa por Hora: \$${_selectedParking!.tarifaPorHora?.toStringAsFixed(0) ?? 'N/A'}'),
                                        ],
                                      ),
                                    ],
                                    if (_selectedParking!.horario != null &&
                                        _selectedParking!
                                            .horario!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                              'Horario: ${_selectedParking!.horario!}'),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 24),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // lógica futura de reserva
                                        },
                                        child:
                                            const Text("Reservar parqueadero"),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Desliza hacia arriba para ver los parqueaderos cercanos o selecciona uno en el mapa.",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    // Lista de parqueaderos cercanos (opcional)
                                    if (_parqueaderosCercanos.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _parqueaderosCercanos.length,
                                        itemBuilder: (context, index) {
                                          final parqueadero =
                                              _parqueaderosCercanos[index];
                                          return ListTile(
                                            leading: const Icon(
                                                Icons.local_parking_outlined),
                                            title: Text(parqueadero.nombre),
                                            subtitle:
                                                Text(parqueadero.direccion),
                                            trailing: Text(
                                                '${parqueadero.disponibles}/${parqueadero.capacidadTotal}'),
                                            onTap: () {
                                              setState(() {
                                                _selectedParking = parqueadero;
                                                // Opcional: puedes expandir el panel aquí
                                              });
                                            },
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Error de API (overlay arriba del mapa)
          if (_apiErrorMessage != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error de API: $_apiErrorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    if (locationResult is LocationFailure) {
      String message = locationResult.message;
      VoidCallback? buttonAction;
      String? buttonText;

      switch (locationResult.reason) {
        case LocationFailureReason.serviceDisabled:
          buttonAction = () => _geolocatorService.openLocationSettings();
          buttonText = 'Activar GPS';
          break;
        case LocationFailureReason.permissionDenied:
          message =
              "El permiso de ubicación es necesario. Por favor, actívalo para usar esta función.";
          break;
        case LocationFailureReason.permissionDeniedForever:
          buttonAction = () => _geolocatorService.openAppSettings();
          buttonText = 'Abrir Configuración';
          break;
        case LocationFailureReason.unknownError:
          break;
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 60, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Problema de Ubicación',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              if (buttonAction != null && buttonText != null)
                ElevatedButton.icon(
                  icon: Icon(buttonText == 'Activar GPS'
                      ? Icons.gps_fixed
                      : Icons.settings),
                  onPressed: buttonAction,
                  label: Text(buttonText),
                ),
            ],
          ),
        ),
      );
    }

    return const Center(child: Text('Estado de ubicación inesperado.'));
  }

  List<Marker> _buildMarkers(Position? userPosition) {
    final List<Marker> markers = [];

    if (userPosition != null) {
      markers.add(
        Marker(
            width: 80.0,
            height: 80.0,
            point: latlng.LatLng(userPosition.latitude, userPosition.longitude),
            child: Tooltip(
              message: "Tu ubicación actual",
              child: Icon(Icons.person_pin_circle,
                  color: Theme.of(context).primaryColor, size: 40.0),
            )),
      );
    }

    for (var parqueadero in _parqueaderosCercanos) {
      markers.add(
        Marker(
          width: 100.0,
          height: 80.0,
          point: parqueadero.ubicacion,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedParking = parqueadero;
                  _panelExtent.value = 0.5; // Abre el panel al seleccionar
                });
              },
              child: Tooltip(
                message:
                    "${parqueadero.nombre}\nDisponibles: ${parqueadero.disponibles}",
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_parking,
                        color: Colors.redAccent[700], size: 30.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        parqueadero.nombre.length > 12
                            ? "${parqueadero.nombre.substring(0, 10)}..."
                            : parqueadero.nombre,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    }
    return markers;
  }

  // Drawer lateral derecho para perfil
  Widget _buildProfileDrawer(BuildContext context) {
    return Drawer(
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // lógica de cambiar modo
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Cambiar de modo"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const CircleAvatar(
              radius: 36,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),
            const Text(
              "Usuario",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar perfil"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Ajustes"),
              onTap: () {},
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
