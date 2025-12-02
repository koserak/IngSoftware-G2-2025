import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Modelo/PuntoAcopio.dart';

class PuntosAcopioScreen extends StatefulWidget {
  const PuntosAcopioScreen({super.key});

  @override
  State<PuntosAcopioScreen> createState() => _PuntosAcopioScreenState();
}

class _PuntosAcopioScreenState extends State<PuntosAcopioScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  List<PuntoAcopio> _puntosAcopio = [];
  String _campusSeleccionado = 'Concepción';

  final List<String> _campusDisponibles = [
    'Concepción',
    'Los Ángeles',
    'Chillán',
  ];

  @override
  void initState() {
    super.initState();
    _cargarPuntosAcopio();
  }

  Future<void> _cargarPuntosAcopio() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Datos de los puntos de acopio solo udec conce por ahora
      final todosPuntos = [
        PuntoAcopio(
          id: '1',
          nombre: 'Biblioteca Central',
          descripcion:
              'Punto de acopio ubicado en el primer piso de la Biblioteca Central. Puedes entregar o retirar objetos perdidos durante el horario de atención.',
          urlImagen: 'assets/images/central.jpg',
          horarioAtencion:
              'Lunes a Viernes: 8:00 - 20:00\nSábados: 9:00 - 14:00',
          ubicacion: 'Biblioteca Central, Campus Concepción',
          direccion:
              'Biblioteca Central UdeC, Edmundo Larenas, Concepción, Chile',
          campus: 'Concepción',
        ),
        PuntoAcopio(
          id: '2',
          nombre: 'Foro UdeC',
          descripcion:
              'Punto de acopio en el módulo de información del Foro. Personal capacitado te ayudará con el proceso de entrega o retiro de objetos.',
          urlImagen: 'assets/images/foro.jpg',
          horarioAtencion: 'Lunes a Viernes: 9:00 - 18:00',
          ubicacion: 'Foro UdeC, Campus Concepción',
          direccion: 'Foro Universidad de Concepción, Concepción, Chile',
          campus: 'Concepción',
        ),
        PuntoAcopio(
          id: '3',
          nombre: 'Facultad de Medicina',
          descripcion:
              'Punto de acopio en la secretaría de la Facultad de Medicina.',
          urlImagen: 'assets/images/medicina.jpeg',
          horarioAtencion: 'Lunes a Viernes: 8:30 - 17:30',
          ubicacion: 'Facultad de Medicina, Campus Concepción',
          direccion:
              'Facultad de Medicina UdeC, Barrio Universitario, Concepción, Chile',
          campus: 'Concepción',
        ),
      ];

      // Filtrar puntos según el campus seleccionado
      final puntosFiltrados = todosPuntos
          .where((punto) => punto.campus == _campusSeleccionado)
          .toList();

      setState(() {
        _puntosAcopio = puntosFiltrados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No se pudo cargar la información. Intenta nuevamente.';
        _isLoading = false;
      });
    }
  }

  Future<void> _abrirGoogleMaps(PuntoAcopio punto) async {
    final url = Uri.parse(punto.urlGoogleMaps);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir Google Maps'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al abrir el mapa'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPuntoAcopioCard(PuntoAcopio punto) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del punto
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              punto.urlImagen,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue[700], size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        punto.nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Descripción
                Text(
                  punto.descripcion,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Ubicación
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        punto.ubicacion,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Horario
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Horario de atención:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              punto.horarioAtencion,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[800],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Botón Google Maps
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirGoogleMaps(punto),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Ver en Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Puntos de Acopio', style: TextStyle(fontSize: 20)),
            Text(
              'Campus $_campusSeleccionado',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Cargando puntos de acopio...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage ?? 'Ocurrió un error',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _cargarPuntosAcopio,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargarPuntosAcopio,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Selector de Campus
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Selecciona el Campus',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<String>(
                            segments: _campusDisponibles.map((campus) {
                              return ButtonSegment<String>(
                                value: campus,
                                label: Text(campus),
                              );
                            }).toList(),
                            selected: {_campusSeleccionado},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _campusSeleccionado = newSelection.first;
                              });
                              _cargarPuntosAcopio();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Información introductoria
                  if (_puntosAcopio.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Estos son los puntos donde puedes entregar o retirar objetos perdidos en el campus.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Mensaje cuando no hay puntos disponibles
                  if (_puntosAcopio.isEmpty && !_isLoading)
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay puntos de acopio disponibles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Los puntos de acopio para el campus $_campusSeleccionado estarán disponibles próximamente.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  if (_puntosAcopio.isNotEmpty) const SizedBox(height: 20),

                  // Lista de puntos de acopio
                  ..._puntosAcopio.map((punto) => _buildPuntoAcopioCard(punto)),
                ],
              ),
            ),
    );
  }
}
