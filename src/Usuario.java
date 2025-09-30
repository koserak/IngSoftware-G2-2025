import java.lang.reflect.Array;
import java.util.ArrayList;

public class Usuario {
    private int idUsuario;
    private String nombre;
    private String correo;
    private String campus;
    private ArrayList<Reporte> reportes;

    public Usuario(int matricula, String nombre, String correo, String campus){
        this.idUsuario = matricula;
        this.nombre = nombre;
        this.correo = correo;
        this.campus = campus;
        reportes = new ArrayList<>();
    }

    public int getIdUsuario(){
        return idUsuario;
    }

    public String getNombre(){
        return nombre;
    }

    public String getCorreo(){
        return correo;
    }

    public String getCampus(){
        return campus;
    }

    public void addReporte(Reporte reporte){
        reportes.add(reporte);
    }

}
