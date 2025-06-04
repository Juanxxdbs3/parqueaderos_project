import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart' as latlng; // Para el tipo de ubicación

class ParqueaderoEntity extends Equatable {
  final String id;
  final String nombre;
  final String direccion;
  final latlng.LatLng ubicacion;
  final int disponibles;
  final int capacidadTotal;
  final String? horario; // Ejemplo de campo adicional
  final double? tarifaPorHora; // Ejemplo de campo adicional

  const ParqueaderoEntity({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.ubicacion,
    required this.disponibles,
    required this.capacidadTotal,
    this.horario,
    this.tarifaPorHora,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        direccion,
        ubicacion,
        disponibles,
        capacidadTotal,
        horario,
        tarifaPorHora,
      ];
}
