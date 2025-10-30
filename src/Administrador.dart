class Administrador {
    int idAdmin;
    String nombreAdmin;
    String correoAdmin;
    String contrasena; // Por que el admin debe logearse.
    bool estadoConexion = false;

    Administrador({
        required this.idAdmin,
                required this.nombreAdmin,
                required this.correoAdmin,
                required this.contrasena,
    });

    // ========Getters========
    int get getIdAdmin => idAdmin;

    String get getNombreAdmin => nombreAdmin;

    String get getCorreoAdmin => correoAdmin;

    String get getContrasena => contrasena;

    bool get isConectado => estadoConexion;

    // ========Setters========
    void login() {
        estadoConexion = true;
    }
}
