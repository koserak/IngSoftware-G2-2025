import 'package:flutter/material.dart';

import '../Modelo/Objeto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objetos Perdidos UdeC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// Pantalla principal con el botón para reportar objetos
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Objeto> _objetos = [];

  void _mostrarDialogoReportarObjeto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ReportarObjetoDialog(
          onObjetoReportado: (objeto) {
            setState(() {
              _objetos.insert(0, objeto);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Objeto reportado exitosamente! Gracias por ayudar.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objetos Perdidos', style: TextStyle(fontSize: 20)),
            Text(
              'Universidad de Concepción',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: _objetos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay objetos reportados aún',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '¿Encontraste algo? ¿Perdiste algo? Repórtalo aquí',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _objetos.length,
        itemBuilder: (context, index) {
          final objeto = _objetos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.blue[700],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              objeto.nombreObjeto,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // verifica si objeto es encontrado o perdido
                            objeto.isEncontrado
                                ? Text(
                              'Encontrado en ${objeto.lugarEncontrado}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green),
                            )
                                : Text(
                              'Perdido en ${objeto.lugarEncontrado}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    objeto.descripcionObjeto,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.category, size: 16),
                        label: Text(objeto.categoria),
                        backgroundColor: Colors.purple[50],
                        labelStyle: TextStyle(
                          color: Colors.purple[700],
                          fontSize: 12,
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.school, size: 16),
                        label: Text(objeto.facultad),
                        backgroundColor: Colors.orange[50],
                        labelStyle: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          '${objeto.fechaEncontrado.day}/${objeto.fechaEncontrado.month}/${objeto.fechaEncontrado.year}',
                        ),
                        backgroundColor: Colors.green[50],
                        labelStyle: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                        ),
                      ),
                      // Chip para el estado del objeto
                      Chip(
                        avatar: const Icon(Icons.check_circle, size: 16),
                        label: Text(objeto.isEncontrado ? 'Encontrado' : 'Perdido'),
                        backgroundColor: objeto.isEncontrado ? Colors.green[50] : Colors.red[50],
                        labelStyle: TextStyle(
                          color: objeto.isEncontrado ? Colors.green[700] : Colors.red[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 18,
                          color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Contacto: ${objeto.contacto}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogoReportarObjeto,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Reportar Objeto'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

// Diálogo emergente para reportar objetos
class ReportarObjetoDialog extends StatefulWidget {
  final Function(Objeto) onObjetoReportado;

  const ReportarObjetoDialog({
    Key? key,
    required this.onObjetoReportado,
  }) : super(key: key);

  @override
  State<ReportarObjetoDialog> createState() => _ReportarObjetoDialogState();
}

class _ReportarObjetoDialogState extends State<ReportarObjetoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _lugarController = TextEditingController();
  final _contactoController = TextEditingController();

  String? _categoriaSeleccionada;
  String? _facultadSeleccionada;
  String? _estadoEncuentro;
  DateTime _fechaEncontrado = DateTime.now();
  bool _isLoading = false;

  final List<String> _categorias = [
    'Electrónicos',
    'Documentos',
    'Ropa y Accesorios',
    'Llaves',
    'Carteras y Bolsos',
    'Libros y Cuadernos',
    'Artículos Deportivos',
    'Joyería',
    'Otros'
  ];

  final List<String> _facultades = [
    'Ciencias Físicas y Matemáticas',
    'Ingeniería',
    'Ciencias Químicas',
    'Ciencias Naturales y Oceanográficas',
    'Medicina',
    'Odontología',
    'Farmacia',
    'Ciencias Veterinarias y Pecuarias',
    'Ciencias Forestales',
    'Ciencias Económicas y Administrativas',
    'Ciencias Jurídicas y Sociales',
    'Humanidades y Arte',
    'Educación',
    'Ciencias Sociales',
    'Arquitectura, Urbanismo y Geografía',
    'Biblioteca Central',
    'Campus Deportivo',
    'Otra ubicación'
  ];

  final List<String> _estadosEncuentro = [
    'Encontrado',
    'Perdido'
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _lugarController.dispose();
    _contactoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaEncontrado,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Selecciona la fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaEncontrado = fechaSeleccionada;
      });
    }
  }

  Future<void> _guardarReporte() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular guardado en el sistema
      await Future.delayed(const Duration(seconds: 1));

      final nuevoObjeto = Objeto(
        idObjeto: DateTime.now().millisecondsSinceEpoch.toString(),
        nombreObjeto: _nombreController.text.trim(),
        descripcionObjeto: _descripcionController.text.trim(),
        categoria: _categoriaSeleccionada!,
        lugarEncontrado: _lugarController.text.trim(),
        facultad: _facultadSeleccionada!,
        fechaEncontrado: _fechaEncontrado,
        contacto: _contactoController.text.trim(),
        estadoEncuentro: _estadoEncuentro.toString() == 'Encontrado' ? true : false,
        estadoVerificacion: false, // al crear una publicación, esta no ha sido verificada
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.of(context).pop();
        widget.onObjetoReportado(nuevoObjeto);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.report_outlined, color: Colors.blue[700], size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reportar Objeto Encontrado',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ayuda a alguien a recuperar lo que perdió',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Formulario
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del objeto *',
                          hintText: 'Ej: Celular Samsung, Mochila negra',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.label_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre es obligatorio';
                          }
                          if (value.trim().length < 3) {
                            return 'Mínimo 3 caracteres';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción detallada *',
                          hintText: 'Color, marca, características distintivas',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description_outlined),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          if (value.trim().length < 10) {
                            return 'Describe el objeto con más detalle (mín. 10 caracteres)';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _categoriaSeleccionada,
                        decoration: const InputDecoration(
                          labelText: 'Categoría *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: _categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                          setState(() {
                            _categoriaSeleccionada = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecciona una categoría';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lugarController,
                        decoration: const InputDecoration(
                          labelText: 'Lugar específico del objeto *',
                          hintText: 'Ej: Sala E-201, Baño 2do piso',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.place_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Indica ubicación exacta del objeto';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _facultadSeleccionada,
                        decoration: const InputDecoration(
                          labelText: 'Facultad o ubicación UdeC *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        items: _facultades.map((facultad) {
                          return DropdownMenuItem(
                            value: facultad,
                            child: Text(
                              facultad,
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                          setState(() {
                            _facultadSeleccionada = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecciona la facultad o ubicación';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _isLoading ? null : _seleccionarFecha,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha en que lo perdiste/encontraste *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(
                            '${_fechaEncontrado.day}/${_fechaEncontrado.month}/${_fechaEncontrado.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contactoController,
                        decoration: const InputDecoration(
                          labelText: 'Tu información de contacto *',
                          hintText: 'Email o teléfono',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.contact_phone_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Proporciona un medio de contacto';
                          }
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _estadoEncuentro,
                        decoration: const InputDecoration(
                          labelText: 'Estado del objeto *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.check_circle_outline),
                        ),
                        items: _estadosEncuentro.map((estadoEncuentro) {
                          return DropdownMenuItem(
                            value: estadoEncuentro,
                            child: Text(
                              estadoEncuentro,
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                          setState(() {
                            _estadoEncuentro = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecciona el estado del objeto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _guardarReporte,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline),
                              SizedBox(width: 8),
                              Text(
                                'Publicar Reporte',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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