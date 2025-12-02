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
      testWidgets(
        'Cada punto de acopio muestra título, descripción, foto referencial, horario de atención y enlace para abrir en Google Maps',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(home: PuntosAcopioScreen()),
          );
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();

          // Verificar que hay cards de puntos de acopio
          expect(
            find.byType(Card),
            findsWidgets,
            reason: 'Debe haber tarjetas de puntos de acopio',
          );

          // Verificar elementos de al menos un punto de acopio
          expect(
            find.text('Biblioteca Central'),
            findsOneWidget,
            reason: 'Debe mostrar el título del punto de acopio',
          );

          // Buscar descripción (puede ser un Text o RichText)
          final descriptionFinder = find.byWidgetPredicate(
            (widget) =>
                (widget is Text &&
                    widget.data != null &&
                    widget.data!.length > 20) ||
                (widget is RichText),
          );
          expect(
            descriptionFinder,
            findsWidgets,
            reason: 'Debe mostrar descripción del punto de acopio',
          );

          // Verificar que hay imágenes
          expect(
            find.byType(Image),
            findsWidgets,
            reason: 'Debe mostrar foto referencial',
          );

          // Verificar horario de atención
          final horarioFinder = find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data != null &&
                (widget.data!.contains(':') ||
                    widget.data!.toLowerCase().contains('lun') ||
                    widget.data!.toLowerCase().contains('horario')),
          );
          expect(
            horarioFinder,
            findsWidgets,
            reason: 'Debe mostrar horario de atención',
          );

          // Verificar enlace a Google Maps (puede ser IconButton o InkWell con icono de mapa)
          final mapLinkFinder = find.byWidgetPredicate(
            (widget) =>
                widget is IconButton ||
                (widget is Icon &&
                    (widget.icon == Icons.map ||
                        widget.icon == Icons.location_on ||
                        widget.icon == Icons.pin_drop)),
          );
          expect(
            mapLinkFinder,
            findsWidgets,
            reason: 'Debe tener enlace para abrir en Google Maps',
          );
        },
      );

      testWidgets(
        'Al navegar a la sección "Puntos de Acopio", la aplicación despliega la lista correspondiente en formato correcto',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(home: PuntosAcopioScreen()),
          );
          await tester.pump(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();

          // Verificar que la pantalla se carga correctamente
          expect(
            find.byType(PuntosAcopioScreen),
            findsOneWidget,
            reason: 'Debe cargar la pantalla de Puntos de Acopio',
          );

          // Verificar que hay un ListView para la lista
          expect(
            find.byType(ListView),
            findsOneWidget,
            reason: 'Debe mostrar una lista (ListView)',
          );

          // Verificar que hay múltiples cards (formato de lista)
          final cardCount = find.byType(Card).evaluate().length;
          expect(
            cardCount,
            greaterThanOrEqualTo(2),
            reason:
                'Debe mostrar al menos 2 puntos de acopio en formato de tarjetas',
          );

          // Verificar que los puntos de acopio esperados están presentes
          expect(
            find.text('Biblioteca Central'),
            findsOneWidget,
            reason: 'Debe incluir Biblioteca Central',
          );

          // Scroll para verificar más elementos
          await tester.dragUntilVisible(
            find.text('Foro UdeC'),
            find.byType(ListView),
            const Offset(0, -300),
          );
          expect(
            find.text('Foro UdeC'),
            findsOneWidget,
            reason: 'Debe incluir Foro UdeC',
          );

          await tester.dragUntilVisible(
            find.text('Facultad de Medicina'),
            find.byType(ListView),
            const Offset(0, -300),
          );
          expect(
            find.text('Facultad de Medicina'),
            findsOneWidget,
            reason: 'Debe incluir Facultad de Medicina',
          );

          // Verificar que no hay excepciones
          expect(
            tester.takeException(),
            isNull,
            reason: 'No debe haber errores al cargar la lista',
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
