import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Modelo/MatchData.dart';
import '../Modelo/Objeto.dart';
import '../Modelo/Almacenamiento.dart';

class MatchDialog extends StatefulWidget {
  final Objeto objeto;

  const MatchDialog({super.key, required this.objeto});

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _rutController = TextEditingController();
  final _contactoController = TextEditingController();
  final _infoController = TextEditingController();
  
  XFile? _imagenPrueba;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _seleccionarImagen() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagenPrueba = image;
      });
    }
  }

  Future<void> _enviarSolicitud() async {
    if (_formKey.currentState!.validate()) {
      if (_imagenPrueba == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes adjuntar una imagen de prueba')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final nuevoMatch = MatchData(
        idMatch: DateTime.now().millisecondsSinceEpoch.toString(),
        idObjeto: widget.objeto.idObjeto,
        nombreSolicitante: _nombreController.text,
        apellidoSolicitante: _apellidoController.text,
        rut: _rutController.text,
        contacto: _contactoController.text,
        informacionAdicional: _infoController.text,
        imagenPruebaPath: _imagenPrueba!.path,
      );

      await Almacenamiento.guardarMatch(nuevoMatch);

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pop(context); // Cierra el diálogo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada al administrador.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Texto del botón según el tipo de reporte
    final String textoAccion = widget.objeto.isEncontrado 
        ? "Soy el dueño" 
        : "Tengo el objeto";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          children: [
            Text(
              "Solicitud de Match: $textoAccion",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Objeto: ${widget.objeto.nombreObjeto}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(labelText: 'Nombres *', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _apellidoController,
                        decoration: const InputDecoration(labelText: 'Apellidos *', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _rutController,
                        decoration: const InputDecoration(labelText: 'RUT o ID *', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contactoController,
                        decoration: const InputDecoration(labelText: 'Teléfono / Email de contacto *', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _infoController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Información adicional (Opcional)', 
                          border: OutlineInputBorder(),
                          hintText: 'Detalles que solo el dueño sabría...',
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Selector de imagen
                      InkWell(
                        onTap: _seleccionarImagen,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _imagenPrueba == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                                    Text("Subir foto de prueba (Obligatorio)"),
                                  ],
                                )
                              : Image.file(
                                  File(_imagenPrueba!.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _enviarSolicitud,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text("Enviar Solicitud"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}