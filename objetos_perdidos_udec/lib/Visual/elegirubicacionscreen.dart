import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ElegirUbicacionScreen extends StatefulWidget {
  const ElegirUbicacionScreen({super.key});

  @override
  State<ElegirUbicacionScreen> createState() => _ElegirUbicacionScreenState();
}

class _ElegirUbicacionScreenState extends State<ElegirUbicacionScreen> {
  LatLng? _punto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seleccionar ubicación")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-36.827, -73.050), // UdeC default
          initialZoom: 16,
          onTap: (tapPosition, latlng) {
            setState(() {
              _punto = latlng;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          if (_punto != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _punto!,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _punto == null
            ? null
            : () {
                Navigator.pop(context, {
                  'lat': _punto!.latitude,
                  'lng': _punto!.longitude,
                });
              },
        label: const Text("Confirmar"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
