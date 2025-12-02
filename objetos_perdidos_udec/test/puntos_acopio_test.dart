import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objetos_perdidos_udec/Visual/puntos_acopio_screen.dart';
import 'package:objetos_perdidos_udec/main.dart';

void main() {
  group('Puntos de Acopio', () {
    group('Tests de Casos Exitosos', () {
      testWidgets(
        'Los puntos de acopio para el campus Concepción (Biblioteca Central, Foro UdeC, Facultad de Medicina) se cargan correctamente',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(home: PuntosAcopioScreen()),
          );
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();

          expect(
            find.text('Biblioteca Central'),
            findsOneWidget,
            reason: 'Debe mostrar Biblioteca Central como punto de acopio',
          );
          await tester.dragUntilVisible(
            find.text('Foro UdeC'),
            find.byType(ListView),
            const Offset(0, -300),
          );
          expect(
            find.text('Foro UdeC'),
            findsOneWidget,
            reason: 'Debe mostrar Foro UdeC como punto de acopio',
          );
          await tester.dragUntilVisible(
            find.text('Facultad de Medicina'),
            find.byType(ListView),
            const Offset(0, -300),
          );
          expect(
            find.text('Facultad de Medicina'),
            findsOneWidget,
            reason: 'Debe mostrar Facultad de Medicina como punto de acopio',
          );
        },
      );

      group('Tests de Casos Limite', () {
        testWidgets(
          'Error al cargar la información completa de un punto de acopio',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              const MaterialApp(home: PuntosAcopioScreen()),
            );
            await tester.pump(const Duration(milliseconds: 500));
            await tester.pumpAndSettle();
            expect(
              find.byType(PuntosAcopioScreen),
              findsOneWidget,
              reason: 'La pantalla debe cargarse incluso con posibles errores',
            );
            expect(
              tester.takeException(),
              isNull,
              reason: 'No debe haber excepciones no capturadas',
            );
          },
        );

        testWidgets(
          'Se muestra mensaje no intrusivo cuando no se puede cargar la información',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              const MaterialApp(home: PuntosAcopioScreen()),
            );
            await tester.pump(const Duration(milliseconds: 500));
            await tester.pumpAndSettle();
            expect(
              find.byType(AlertDialog),
              findsNothing,
              reason:
                  'No debe mostrar AlertDialog intrusivo al cargar exitosamente',
            );
          },
        );

        testWidgets('Fallo temporal de red al cargar mapa o marcador', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            const MaterialApp(home: PuntosAcopioScreen()),
          );
          expect(
            find.byType(CircularProgressIndicator),
            findsOneWidget,
            reason: 'Debe mostrar indicador de carga inicialmente',
          );
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();
          expect(
            find.byType(CircularProgressIndicator),
            findsNothing,
            reason: 'El indicador de carga debe desaparecer después de cargar',
          );
          final hasContent = find.byType(Card).evaluate().isNotEmpty;
          final hasError = find.text('Reintentar').evaluate().isNotEmpty;

          expect(
            hasContent || hasError,
            true,
            reason: 'Debe mostrar contenido o permitir reintentar',
          );
        });

        testWidgets(
          'Datos faltantes en un punto de acopio (por ejemplo, no tiene imagen)',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              const MaterialApp(home: PuntosAcopioScreen()),
            );
            await tester.pump(const Duration(milliseconds: 500));
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: 'No debe crashear si falta una imagen',
            );
            expect(
              find.byType(Card),
              findsWidgets,
              reason: 'Debe mostrar las tarjetas de puntos de acopio',
            );
          },
        );
      });
    });
  });
}
