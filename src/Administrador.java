public class Administrador {
    private int idAdmin;
    private String nombreAdmin;
    private String correoAdmin;
    private String contrasena; // Por que el admin debe logearse.
    private boolean estadoConexion = false;

    public Administrador(int idAdmin, String nombreAdmin, String correoAdmin, String contrasena){
        this.idAdmin = idAdmin;
        this.nombreAdmin = nombreAdmin;
        this.correoAdmin = correoAdmin;
        this.contrasena = contrasena;
    }
    // ========Getters========
    public int getIdAdmin() {
        return idAdmin;
    }

    public String getNombreAdmin() {
        return nombreAdmin;
    }

    public String getCorreoAdmin() {
        return correoAdmin;
    }

    public String getContrasena() {
        return contrasena;
    }

    public boolean isConectado() {
        return estadoConexion;
    }
    // ========Setters========
    public void login(){
        estadoConexion = true;
    }
}
