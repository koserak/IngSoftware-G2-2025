import 'Comentario.dart';

class Reporte {
    DateTime fecha;
    DateTime hora;
    String descripcion;
    String ubicacion;
    bool estadoReporte = true;
    bool estadoVerificacion = false;
    List<Comentario> comentarios;

    Reporte({
        required this.fecha,
        required this.hora,
        required this.ubicacion,
        required this.descripcion,
    }) : comentarios = [];

    // Getters
    DateTime get getFecha => fecha;

    DateTime get getHora => hora;

    String get getUbicacion => ubicacion;

    String get getDescripcion => descripcion;

    // Si el reporte esta sin resolver (abierto) es true, si se cerro el caso es false
    bool get isOpen => estadoReporte;

    // Si el reporte no esta verificado es false, si esta verificado es true
    bool get isVerified => estadoVerificacion;

    // Métodos
}
