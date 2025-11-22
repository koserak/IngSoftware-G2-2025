class PuntoAcopio {
  final String id;
  final String nombre;
  final String descripcion;
  final String urlImagen;
  final String horarioAtencion;
  final String ubicacion;
  final String direccion;
  final String campus;

  PuntoAcopio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.urlImagen,
    required this.horarioAtencion,
    required this.ubicacion,
    required this.direccion,
    required this.campus,
  });

  // URL para abrir en Google Maps usando la dirección
  String get urlGoogleMaps {
    final direccionCodificada = Uri.encodeComponent(direccion);
    return 'https://www.google.com/maps/search/?api=1&query=$direccionCodificada';
  }
}
