
# Historia de Usuario 1: Publicar objeto 

**Como** usuario del sistema.  
**Quiero** poder publicar información sobre un objeto que he perdido  
**Para que** otras personas puedan ayudarme a encontrarlo y el moderador pueda verificar la publicación

### Criterios de Aceptación

- [ ] El formulario debe solicitar:
      - Descripción detallada del objeto
      - Fecha y hora aproximada de la pérdida
      - Ubicación donde se perdió el objeto
      - Campus asociado (si aplica)
- [ ] El sistema debe permitir seleccionar el tipo de objeto (perdido o encontrado)

- [ ] Al crear la publicación, el estado inicial debe ser "pendiente de verificación"
- [ ] El usuario debe recibir una confirmación de que su reporte fue creado exitosamente
- [ ] La publicación debe quedar asociada al usuario que la creó
- [ ] El moderador debe recibir una notificación sobre la nueva publicación pendiente de verificación

### Notas Técnicas

- Relación: Usuario (1) crea (0..*) Reporte
- Estados del reporte: pendiente, verificado, archivado
- El objeto debe marcarse con tipoObjeto = false (perdido)/ true(encontrado)

# Historia de Usuario 2: Verificar Publicacion

**Como** moderador del sistema.  
**Quiero** revisar y verificar las publicaciones de objetos.  
**Para que** solo información válida y apropiada sea visible públicamente en la plataforma

### Criterios de Aceptación

- [ ] El moderador debe poder acceder a una lista de publicaciones pendientes de verificación
- [ ] El sistema debe mostrar todos los detalles del reporte:
- [ ] El moderador debe poder:
  - Aprobar la publicación (cambiar estadoVerificacion a true)
  - Rechazar/eliminar la publicación si no cumple los criterios
  - Modificar información incorrecta antes de aprobar
- [ ] Al aprobar, el usuario que creó el reporte debe recibir una notificación
- [ ] Ser eliminada una publicación, el usuario que creó el reporte debe recibir una notificación
- [ ] Al buscar publicaciones se podra filtrar entre verficadas y todas.
- [ ] El moderador debe poder archivar publicaciones resueltas.

### Notas Técnicas

- Relación: Administrador/Moderador administra (0..*) Reporte
- Estados: estadoVerificacion cambia de false a true tras aprobación
- Se debe enviar una Notificación al usuario cuando su reporte sea verificado
- El objeto debe tener tipoObjeto = true (encontrado)
