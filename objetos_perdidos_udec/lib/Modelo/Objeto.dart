// Modelo de datos para un objeto encontrado/perdido
import 'package:image_picker/image_picker.dart';
class Objeto{
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

  bool get isEncontrado => estadoEncuentro; // false significa que no se ha encontrado el objeto

  bool get isVerificado => estadoVerificacion; // false significa que no a sido verificado por un administrador

  String get getCategoria => categoria;

  String get getLugarEncontrado => lugarEncontrado;
}