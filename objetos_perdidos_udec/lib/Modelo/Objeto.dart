// Modelo de datos para un objeto encontrado/perdido
import 'package:image_picker/image_picker.dart';
class Objeto {
  final String idObjeto;
  final String nombreObjeto;
  final String descripcionObjeto;
  final String categoria;
  final String lugarEncontrado;
  final String facultad;
  final String contacto;
  final DateTime fechaEncontrado;
  final bool estadoEncuentro;
  final bool estadoVerificacion;
  final double? lat;
  final double? long;
  final XFile? imagen;

  Objeto({
    required this.idObjeto,
    required this.nombreObjeto,
    required this.descripcionObjeto,
    required this.categoria,
    required this.lugarEncontrado,
    required this.facultad,
    required this.contacto,
    required this.fechaEncontrado,
    required this.estadoEncuentro,
    required this.estadoVerificacion,
    this.lat,
    this.long,
    this.imagen,
  });

  String get getIdObjeto => idObjeto;
  String get getDescripcionObjeto => descripcionObjeto;
  bool get isEncontrado => estadoEncuentro;
  bool get isVerificado => estadoVerificacion;
  String get getCategoria => categoria;
  String get getLugarEncontrado => lugarEncontrado;

  // Convertir un Objeto a un Mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'idObjeto': idObjeto,
      'nombreObjeto': nombreObjeto,
      'descripcionObjeto': descripcionObjeto,
      'categoria': categoria,
      'lugarEncontrado': lugarEncontrado,
      'facultad': facultad,
      'contacto': contacto,
      'fechaEncontrado': fechaEncontrado.toIso8601String(), // Guardamos fecha como texto
      'estadoEncuentro': estadoEncuentro,
      'estadoVerificacion': estadoVerificacion,
      'lat': lat,
      'long': long,
      'imagenPath': imagen?.path, // Guardamos solo la ruta de la imagen
    };
  }

  // Crear un Objeto desde un Mapa (JSON)
  factory Objeto.fromJson(Map<String, dynamic> json) {
    return Objeto(
      idObjeto: json['idObjeto'],
      nombreObjeto: json['nombreObjeto'],
      descripcionObjeto: json['descripcionObjeto'],
      categoria: json['categoria'],
      lugarEncontrado: json['lugarEncontrado'],
      facultad: json['facultad'],
      contacto: json['contacto'],
      fechaEncontrado: DateTime.parse(json['fechaEncontrado']),
      estadoEncuentro: json['estadoEncuentro'],
      estadoVerificacion: json['estadoVerificacion'],
      lat: json['lat'],
      long: json['long'],
      // Si hay ruta, creamos el XFile, si no, es null
      imagen: json['imagenPath'] != null ? XFile(json['imagenPath']) : null,
    );
  }
}