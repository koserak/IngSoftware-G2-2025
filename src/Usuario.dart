import 'Reporte.dart';

class Usuario {
    int idUsuario;
    String nombre;
    String correo;
    String campus;
    List<Reporte> reportes;

    Usuario({
        required int matricula,
        required this.nombre,
                required this.correo,
                required this.campus,
    })  : idUsuario = matricula,
    reportes = [];

    // Getters
    int get getIdUsuario => idUsuario;

    String get getNombre => nombre;

    String get getCorreo => correo;

    String get getCampus => campus;

    // Métodos
    void addReporte(Reporte reporte) {
        reportes.add(reporte);
    }
}