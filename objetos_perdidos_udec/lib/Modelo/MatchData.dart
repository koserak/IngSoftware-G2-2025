
class MatchData {
  final String idMatch;
  final String idObjeto; // Para saber a qué objeto pertenece
  final String nombreSolicitante;
  final String apellidoSolicitante;
  final String rut; // O Pasaporte
  final String contacto;
  final String? informacionAdicional;
  final String? imagenPruebaPath; // Ruta de la foto de prueba

  MatchData({
    required this.idMatch,
    required this.idObjeto,
    required this.nombreSolicitante,
    required this.apellidoSolicitante,
    required this.rut,
    required this.contacto,
    this.informacionAdicional,
    this.imagenPruebaPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'idMatch': idMatch,
      'idObjeto': idObjeto,
      'nombreSolicitante': nombreSolicitante,
      'apellidoSolicitante': apellidoSolicitante,
      'rut': rut,
      'contacto': contacto,
      'informacionAdicional': informacionAdicional,
      'imagenPruebaPath': imagenPruebaPath,
    };
  }

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      idMatch: json['idMatch'],
      idObjeto: json['idObjeto'],
      nombreSolicitante: json['nombreSolicitante'],
      apellidoSolicitante: json['apellidoSolicitante'],
      rut: json['rut'],
      contacto: json['contacto'],
      informacionAdicional: json['informacionAdicional'],
      imagenPruebaPath: json['imagenPruebaPath'],
    );
  }
}