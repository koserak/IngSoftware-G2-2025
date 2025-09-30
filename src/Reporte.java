import java.util.ArrayList;
import java.util.Date;

public class Reporte {
    private Date fecha;
    private Date hora;
    private String descripcion;
    private String ubicacion;
    private boolean estadoReporte = true;
    private boolean estadoVerificacion = false;
    private ArrayList<Comentario> comentarios;

    public Reporte(Date fecha, Date hora,String ubicacion, String descripcion){
        this.fecha = fecha;
        this.hora = hora;
        this.ubicacion = ubicacion;
        this.descripcion = descripcion;
        comentarios = new ArrayList<>();
    }

    public Date getFecha() {
        return fecha;
    }

    public Date getHora() {
        return hora;
    }

    public String getUbicacion(){
        return ubicacion;
    }
    public String getDescripcion() {
        return descripcion;
    }
    // Si el reporte esta sin resolver (abierto) es true, si se cerro el caso es false
    public boolean isOpen() {
        return estadoReporte;
    }
    // Si el reporte no esta verificado es false, si esta verificado es true
    public boolean isVerificado(){
        return estadoVerificacion;
    }

    public void addComentario(Comentario comentario){
        comentarios.add(comentario);
    }

}
