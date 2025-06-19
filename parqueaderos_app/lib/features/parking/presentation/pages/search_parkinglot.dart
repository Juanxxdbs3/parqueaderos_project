import 'package:flutter/material.dart';

class SearchParkingLotPage extends StatelessWidget {
  const SearchParkingLotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Parqueadero'),
      ),
      body: const Center(
        child: Text('Aquí irá la búsqueda de parqueaderos.'),
      ),
    );
  }
}
