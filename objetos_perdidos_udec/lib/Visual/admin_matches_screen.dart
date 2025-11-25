import 'dart:io';
import 'package:flutter/material.dart';
import '../Modelo/MatchData.dart';
import '../Modelo/Objeto.dart';
import '../Modelo/Almacenamiento.dart';

class AdminMatchesScreen extends StatefulWidget {
  const AdminMatchesScreen({super.key});

  @override
  State<AdminMatchesScreen> createState() => _AdminMatchesScreenState();
}

class _AdminMatchesScreenState extends State<AdminMatchesScreen> {
  List<MatchData> _matches = [];
  List<Objeto> _objetos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final matches = await Almacenamiento.obtenerMatches();
    final objetos = await Almacenamiento.obtenerObjetos();
    setState(() {
      _matches = matches;
      _objetos = objetos;
      _isLoading = false;
    });
  }

  Future<void> _procesarSolicitud(MatchData match, bool aprobar) async {
    setState(() => _isLoading = true);

    if (aprobar) {
      // 1. Buscar el objeto original
      final index = _objetos.indexWhere((o) => o.idObjeto == match.idObjeto);
      if (index != -1) {
        final objetoAntiguo = _objetos[index];
        
        // 2. Crear versión actualizada con isResuelto = true
        final objetoResuelto = Objeto(
          idObjeto: objetoAntiguo.idObjeto,
          nombreObjeto: objetoAntiguo.nombreObjeto,
          descripcionObjeto: objetoAntiguo.descripcionObjeto,
          categoria: objetoAntiguo.categoria,
          lugarEncontrado: objetoAntiguo.lugarEncontrado,
          facultad: objetoAntiguo.facultad,
          contacto: objetoAntiguo.contacto,
          fechaEncontrado: objetoAntiguo.fechaEncontrado,
          estadoEncuentro: objetoAntiguo.estadoEncuentro,
          estadoVerificacion: true, // Se verifica automáticamente
          isResuelto: true,         // <--- MARCAR COMO RESUELTO
          lat: objetoAntiguo.lat,
          long: objetoAntiguo.long,
          imagen: objetoAntiguo.imagen,
        );

        _objetos[index] = objetoResuelto;
        await Almacenamiento.guardarObjetos(_objetos);
      }
    }

    // Tanto si aprueba como rechaza, eliminamos la solicitud de match pendiente
    await Almacenamiento.eliminarMatch(match.idMatch);
    
    await _cargarDatos(); // Recargar lista
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(aprobar ? "Match aprobado y objeto resuelto" : "Solicitud rechazada")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitudes de Match")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _matches.isEmpty
              ? const Center(child: Text("No hay solicitudes pendientes"))
              : ListView.builder(
                  itemCount: _matches.length,
                  itemBuilder: (context, index) {
                    final match = _matches[index];
                    // Buscar nombre del objeto asociado
                    final objetoAsociado = _objetos.firstWhere(
                      (o) => o.idObjeto == match.idObjeto,
                      orElse: () => Objeto( // Objeto dummy si no se encuentra
                        idObjeto: '', nombreObjeto: 'Objeto desconocido', descripcionObjeto: '',
                        categoria: '', lugarEncontrado: '', facultad: '', contacto: '',
                        fechaEncontrado: DateTime.now(), estadoEncuentro: false, estadoVerificacion: false
                      ),
                    );

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Objeto: ${objetoAsociado.nombreObjeto}", 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Solicitante: ${match.nombreSolicitante} ${match.apellidoSolicitante}"),
                            Text("RUT: ${match.rut}"),
                            Text("Contacto: ${match.contacto}"),
                            if(match.informacionAdicional != null)
                              Text("Info Extra: ${match.informacionAdicional}"),
                            const SizedBox(height: 10),
                            const Text("Prueba visual:", style: TextStyle(fontWeight: FontWeight.bold)),
                            if (match.imagenPruebaPath != null)
                              SizedBox(
                                height: 150,
                                child: Image.file(File(match.imagenPruebaPath!)),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _procesarSolicitud(match, false),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text("Rechazar"),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => _procesarSolicitud(match, true),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                  child: const Text("Aprobar Match"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}