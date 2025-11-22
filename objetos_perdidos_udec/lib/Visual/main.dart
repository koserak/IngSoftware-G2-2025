import 'package:flutter/material.dart';
import 'package:objetos_perdidos_udec/Visual/elegirubicacionscreen.dart';
import 'package:objetos_perdidos_udec/Visual/puntos_acopio_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../Modelo/Objeto.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objetos Perdidos UdeC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

// Pantalla principal con buscador y filtros
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Objeto> _objetos = [];
  String _busqueda = '';
  String? _filtroFacultad;
  String? _filtroCategoria;
  String? _filtroEstado; // "Perdido" o "Encontrado"
  String? _filtroVerificado; // "Verificado" o "No Verificado"

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
                content: Text(
                  '¡Objeto reportado exitosamente! Gracias por ayudar.',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          },
        );
      },
    );
  }

  List<Objeto> get _objetosFiltrados {
    return _objetos.where((objeto) {
      final nombreMatch =
          objeto.nombreObjeto.toLowerCase().contains(_busqueda.toLowerCase()) ||
          objeto.descripcionObjeto.toLowerCase().contains(
            _busqueda.toLowerCase(),
          );

      final facultadMatch =
          _filtroFacultad == null || objeto.facultad == _filtroFacultad;
      final categoriaMatch =
          _filtroCategoria == null || objeto.categoria == _filtroCategoria;
      final estadoMatch =
          _filtroEstado == null ||
          (_filtroEstado == "Encontrado" && objeto.isEncontrado) ||
          (_filtroEstado == "Perdido" && !objeto.isEncontrado);
      final verificadoMatch =
          _filtroVerificado == null ||
          (_filtroVerificado == "Verificado" && objeto.isVerificado) ||
          (_filtroVerificado == "No Verificado" && !objeto.isVerificado);

      return nombreMatch &&
          facultadMatch &&
          categoriaMatch &&
          estadoMatch &&
          verificadoMatch;
    }).toList();
  }

  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Mostrar todos los tipos posibles aunque no haya objetos
        final categorias = [
          'Electrónicos',
          'Documentos',
          'Ropa y Accesorios',
          'Llaves',
          'Carteras y Bolsos',
          'Libros y Cuadernos',
          'Artículos Deportivos',
          'Joyería',
          'Otros',
        ];

        final facultades = [
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
          'Otra ubicación',
        ];

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Filtros de búsqueda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Facultad
                    DropdownButtonFormField<String>(
                      initialValue: _filtroFacultad,
                      decoration: const InputDecoration(
                        labelText: 'Filtrar por Facultad',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      items: facultades
                          .map(
                            (fac) =>
                                DropdownMenuItem(value: fac, child: Text(fac)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => _filtroFacultad = value),
                    ),
                    const SizedBox(height: 12),

                    // Categoría
                    DropdownButtonFormField<String>(
                      initialValue: _filtroCategoria,
                      decoration: const InputDecoration(
                        labelText: 'Filtrar por Categoría',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: categorias
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => _filtroCategoria = value),
                    ),
                    const SizedBox(height: 12),

                    // Estado (Encontrado o Perdido)
                    DropdownButtonFormField<String>(
                      initialValue: _filtroEstado,
                      decoration: const InputDecoration(
                        labelText: 'Estado del objeto',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Encontrado",
                          child: Text("Encontrado"),
                        ),
                        DropdownMenuItem(
                          value: "Perdido",
                          child: Text("Perdido"),
                        ),
                      ],
                      onChanged: (value) =>
                          setModalState(() => _filtroEstado = value),
                    ),
                    const SizedBox(height: 12),

                    // Verificado
                    DropdownButtonFormField<String>(
                      initialValue: _filtroVerificado,
                      decoration: const InputDecoration(
                        labelText: 'Verificación',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.verified_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Verificado",
                          child: Text("Verificado"),
                        ),
                        DropdownMenuItem(
                          value: "No Verificado",
                          child: Text("No Verificado"),
                        ),
                      ],
                      onChanged: (value) =>
                          setModalState(() => _filtroVerificado = value),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.filter_alt_off),
                            label: const Text('Limpiar filtros'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _filtroFacultad = null;
                                _filtroCategoria = null;
                                _filtroEstado = null;
                                _filtroVerificado = null;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Aplicar'),
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final objetosFiltrados = _objetosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objetos Perdidos', style: TextStyle(fontSize: 20)),
            Text('Universidad de Concepción', style: TextStyle(fontSize: 12)),
          ],
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_alt),
            onPressed: _objetos.isEmpty ? null : _mostrarFiltros,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o descripción...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() => _busqueda = value),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.school, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Objetos Perdidos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'UdeC',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.blue),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.location_on_outlined,
                color: Colors.blue,
              ),
              title: const Text('Puntos de Acopio'),
              subtitle: const Text('Ver ubicaciones disponibles'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PuntosAcopioScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Objetos Perdidos UdeC',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.school,
                    size: 48,
                    color: Colors.blue,
                  ),
                  children: const [
                    Text(
                      'Aplicación para gestionar objetos perdidos y encontrados en la Universidad de Concepción.',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: objetosFiltrados.isEmpty
          ? Center(
              child: Text(
                _objetos.isEmpty
                    ? 'No hay objetos reportados aún'
                    : 'No se encontraron coincidencias',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: objetosFiltrados.length,
              itemBuilder: (context, index) {
                final objeto = objetosFiltrados[index];
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
                                  objeto.isEncontrado
                                      ? Text(
                                          'Encontrado en ${objeto.lugarEncontrado}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        )
                                      : Text(
                                          'Perdido en ${objeto.lugarEncontrado}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(objeto.descripcionObjeto),
                        if (objeto.lat != null && objeto.long != null)
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(
                                  objeto.lat!,
                                  objeto.long!,
                                ),
                                initialZoom: 16,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}{r}.png?api_key={apiKey}",
                                  additionalOptions: const {
                                    'apiKey':
                                        '20aba97e-7b65-437d-8f1e-a9d91a8ff2df',
                                  },
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 40,
                                      height: 40,
                                      point: LatLng(objeto.lat!, objeto.long!),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        Wrap(
                          spacing: 8,
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
                              avatar: Icon(
                                objeto.isVerificado
                                    ? Icons.check
                                    : Icons.block_outlined,
                                size: 16,
                              ),
                              label: Text(
                                objeto.isVerificado
                                    ? 'Verificado'
                                    : 'No Verificado',
                              ),
                              backgroundColor: objeto.isVerificado
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              labelStyle: TextStyle(
                                color: objeto.isVerificado
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 12,
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.calendar_today,
                                size: 16,
                              ),
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
                              label: Text(
                                objeto.isEncontrado ? 'Encontrado' : 'Perdido',
                              ),
                              backgroundColor: objeto.isEncontrado
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              labelStyle: TextStyle(
                                color: objeto.isEncontrado
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 12,
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

  const ReportarObjetoDialog({super.key, required this.onObjetoReportado});

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
  double? selectedLat;
  double? selectedLng;
  XFile? _imagenSeleccionada;

  final List<String> _categorias = [
    'Electrónicos',
    'Documentos',
    'Ropa y Accesorios',
    'Llaves',
    'Carteras y Bolsos',
    'Libros y Cuadernos',
    'Artículos Deportivos',
    'Joyería',
    'Otros',
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
    'Otra ubicación',
  ];

  final List<String> _estadosEncuentro = ['Encontrado', 'Perdido'];
  
  final ImagePicker _picker = ImagePicker();

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
        estadoEncuentro: _estadoEncuentro.toString() == 'Encontrado'
            ? true
            : false,
        estadoVerificacion:
            false, // al crear una publicación, esta no ha sido verificada
        lat: selectedLat,
        long: selectedLng,
        imagen: _imagenSeleccionada,
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

Future<void> _seleccionarImagen() async {
  try {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final mimeType = pickedFile.mimeType;
      
      if (mimeType == 'image/png' || mimeType == 'image/jpeg') {
        setState(() {
          _imagenSeleccionada = pickedFile; // ✅ Asignar directamente, sin XFile()
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solo se permiten imágenes PNG o JPG')),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al seleccionar imagen: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  Icon(
                    Icons.report_outlined,
                    color: Colors.blue[700],
                    size: 28,
                  ),
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
                          style: TextStyle(fontSize: 12, color: Colors.black54),
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
                        initialValue: _categoriaSeleccionada,
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

                      ElevatedButton.icon(
                        icon: const Icon(Icons.map_outlined),
                        label: const Text("Elegir ubicación en el mapa"),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ElegirUbicacionScreen(),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedLat = result['lat'];
                                    selectedLng = result['lng'];
                                  });
                                }
                              },
                      ),
                      if (selectedLat != null && selectedLng != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Ubicación seleccionada: ${selectedLat!.toStringAsFixed(5)}, ${selectedLng!.toStringAsFixed(5)}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _facultadSeleccionada,
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
                        initialValue: _estadoEncuentro,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
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
