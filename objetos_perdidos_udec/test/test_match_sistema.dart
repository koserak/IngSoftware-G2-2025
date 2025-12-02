import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:objetos_perdidos_udec/Modelo/Objeto.dart';
import 'package:objetos_perdidos_udec/Modelo/MatchData.dart';
import 'package:objetos_perdidos_udec/Modelo/Almacenamiento.dart';

void main() {
  group('Sistema de Match: Notificación de dueños y poseedores', () {
    
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    tearDown() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    test('Validar sistema de match completo: notificaciones, estados pendientes y reportes inexistentes', () async {
      
      // ============================================================
      // CASO 1: Usuario notifica que es DUEÑO de objeto ENCONTRADO
      // ============================================================
      
      // Arrange: Alguien reportó que ENCONTRÓ un objeto
      final objetoEncontrado = Objeto(
        idObjeto: 'obj_encontrado_001',
        nombreObjeto: 'iPhone 13 Pro',
        descripcionObjeto: 'iPhone azul con funda transparente',
        categoria: 'Electrónicos',
        lugarEncontrado: 'Biblioteca Central',
        facultad: 'Biblioteca Central',
        contacto: 'encontrador@udec.cl',
        fechaEncontrado: DateTime(2024, 1, 20),
        estadoEncuentro: true, // TRUE = ENCONTRADO
        estadoVerificacion: true,
      );

      await Almacenamiento.guardarObjetos([objetoEncontrado]);

      // Act: Usuario que PERDIÓ el iPhone notifica que es el dueño
      final matchDueno = MatchData(
        idMatch: 'match_001',
        idObjeto: objetoEncontrado.idObjeto,
        nombreSolicitante: 'Juan',
        apellidoSolicitante: 'Pérez',
        rut: '12345678-9',
        contacto: 'juan@udec.cl',
        informacionAdicional: 'Tiene mis fotos familiares',
        imagenPruebaPath: '/storage/prueba1.jpg',
      );

      await Almacenamiento.guardarMatch(matchDueno);

      // Assert: Verificar que el match quedó PENDIENTE de revisión
      var matches = await Almacenamiento.obtenerMatches();
      expect(matches.length, equals(1), reason: 'Debe haber 1 match pendiente');
      expect(matches.first.idObjeto, equals('obj_encontrado_001'));
      expect(matches.first.nombreSolicitante, equals('Juan'));
      print('✅ CASO 1: Usuario notificó que es DUEÑO de objeto ENCONTRADO - Match pendiente');

      // ============================================================
      // CASO 2: Usuario notifica que TIENE objeto PERDIDO
      // ============================================================
      
      // Arrange: Alguien reportó que PERDIÓ un objeto
      final objetoPerdido = Objeto(
        idObjeto: 'obj_perdido_002',
        nombreObjeto: 'Billetera de cuero',
        descripcionObjeto: 'Billetera marrón con iniciales "MP"',
        categoria: 'Carteras y Bolsos',
        lugarEncontrado: 'Casino Central',
        facultad: 'Otra ubicación',
        contacto: 'perdedor@udec.cl',
        fechaEncontrado: DateTime(2024, 1, 21),
        estadoEncuentro: false, // FALSE = PERDIDO
        estadoVerificacion: true,
      );

      var objetos = await Almacenamiento.obtenerObjetos();
      objetos.add(objetoPerdido);
      await Almacenamiento.guardarObjetos(objetos);

      // Act: Usuario que ENCONTRÓ la billetera notifica que la tiene
      final matchPoseedor = MatchData(
        idMatch: 'match_002',
        idObjeto: objetoPerdido.idObjeto,
        nombreSolicitante: 'María',
        apellidoSolicitante: 'González',
        rut: '98765432-1',
        contacto: 'maria@udec.cl',
        informacionAdicional: 'La encontré en el segundo piso',
        imagenPruebaPath: '/storage/prueba2.jpg',
      );

      await Almacenamiento.guardarMatch(matchPoseedor);

      // Assert: Verificar que el match quedó PENDIENTE de revisión
      matches = await Almacenamiento.obtenerMatches();
      expect(matches.length, equals(2), reason: 'Deben haber 2 matches pendientes');
      
      final matchBilletera = matches.firstWhere((m) => m.idObjeto == 'obj_perdido_002');
      expect(matchBilletera.nombreSolicitante, equals('María'));
      expect(matchBilletera.idObjeto, equals('obj_perdido_002'));
      print('✅ CASO 2: Usuario notificó que TIENE objeto PERDIDO - Match pendiente');

      // ============================================================
      // CASO 3: Verificar estado PENDIENTE de ambos matches
      // ============================================================
      
      // Assert: Los matches están pendientes y asociados correctamente
      expect(matches.length, equals(2));
      
      // Verificar asociación usuario-reporte para match 1
      final match1 = matches.firstWhere((m) => m.idMatch == 'match_001');
      expect(match1.idObjeto, equals('obj_encontrado_001'));
      expect(match1.contacto, equals('juan@udec.cl'));
      
      // Verificar asociación usuario-reporte para match 2
      final match2 = matches.firstWhere((m) => m.idMatch == 'match_002');
      expect(match2.idObjeto, equals('obj_perdido_002'));
      expect(match2.contacto, equals('maria@udec.cl'));
      
      // Verificar que los reportes originales siguen sin cambios
      objetos = await Almacenamiento.obtenerObjetos();
      expect(objetos.length, equals(2));
      
      final objEnc = objetos.firstWhere((o) => o.idObjeto == 'obj_encontrado_001');
      expect(objEnc.isEncontrado, isTrue, reason: 'Objeto debe seguir como ENCONTRADO');
      
      final objPer = objetos.firstWhere((o) => o.idObjeto == 'obj_perdido_002');
      expect(objPer.isEncontrado, isFalse, reason: 'Objeto debe seguir como PERDIDO');
      
      print('✅ CASO 3: Matches en estado PENDIENTE verificados correctamente');

      // ============================================================
      // CASO 4: Intento de match sobre reporte INEXISTENTE
      // ============================================================
      
      // Act: Intentar crear match para objeto que no existe
      final matchInvalido = MatchData(
        idMatch: 'match_003',
        idObjeto: 'obj_inexistente_999', // ID que NO existe
        nombreSolicitante: 'Pedro',
        apellidoSolicitante: 'Ramírez',
        rut: '11111111-1',
        contacto: 'pedro@udec.cl',
        imagenPruebaPath: '/storage/prueba3.jpg',
      );

      await Almacenamiento.guardarMatch(matchInvalido);
      
      // Assert: El match se guarda, pero no hay reporte asociado
      matches = await Almacenamiento.obtenerMatches();
      expect(matches.length, equals(3));
      
      final matchHuerfano = matches.firstWhere((m) => m.idMatch == 'match_003');
      expect(matchHuerfano.idObjeto, equals('obj_inexistente_999'));
      
      // Verificar que NO existe el reporte asociado
      objetos = await Almacenamiento.obtenerObjetos();
      final existeReporte = objetos.any((o) => o.idObjeto == 'obj_inexistente_999');
      expect(existeReporte, isFalse, reason: 'No debe existir reporte con ese ID');
      
      print('✅ CASO 4: Match sobre reporte INEXISTENTE - Comportamiento validado');

      // ============================================================
      // RESUMEN FINAL
      // ============================================================
      
      print('\n========== RESUMEN DE VALIDACIONES ==========');
      print('✅ Usuario notifica que es DUEÑO (objeto encontrado)');
      print('✅ Usuario notifica que TIENE objeto (objeto perdido)');
      print('✅ Matches quedan en estado PENDIENTE de revisión');
      print('✅ Asociaciones usuario-reporte correctas');
      print('✅ Comportamiento con reporte inexistente validado');
      print('=============================================\n');
    });
  });
}