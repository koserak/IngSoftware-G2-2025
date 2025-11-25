import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Objeto.dart';

class Almacenamiento {
  static const String keyObjetos = 'lista_objetos_udec';

  // Guardar la lista completa
  static Future<void> guardarObjetos(List<Objeto> objetos) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Convertimos cada objeto a Mapa (JSON)
    // 2. Convertimos la lista de mapas a un String gigante
    final String datosCodificados = json.encode(
      objetos.map((obj) => obj.toJson()).toList(),
    );

    await prefs.setString(keyObjetos, datosCodificados);
    print("Datos guardados localmente: ${objetos.length} objetos.");
  }

  // Leer la lista
  static Future<List<Objeto>> obtenerObjetos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? datosCodificados = prefs.getString(keyObjetos);

    if (datosCodificados == null) {
      return []; // Si no hay datos, retornamos lista vacía
    }

    // Decodificamos el String a una lista de mapas
    final List<dynamic> mapas = json.decode(datosCodificados);

    // Convertimos cada mapa de vuelta a un Objeto
    return mapas.map((mapa) => Objeto.fromJson(mapa)).toList();
  }
}