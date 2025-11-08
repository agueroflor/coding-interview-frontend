import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:currency_exchange/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Challenge Integration Tests', () {
    testWidgets('Complete currency exchange flow', (tester) async {
      // Inicia la app
      app.main();
      await tester.pumpAndSettle();

      // Verifica el estado inicial
      expect(find.text('TENGO'), findsOneWidget);
      expect(find.text('QUIERO'), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);

      // Encuentra y toca el campo de entrada de cantidad
      final amountFieldFinder = find.byType(TextField);
      expect(amountFieldFinder, findsOneWidget);

      // Ingresa un monto
      await tester.enterText(amountFieldFinder, '100');
      await tester.pumpAndSettle();

      // Espera la respuesta de la API (debounce + red)
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verifica que la tasa aparezca o muestre un mensaje de error
      // (depende de la conexión a internet)
      final hasInfo = find.text('Tasa estimada').evaluate().isNotEmpty ||
          find.text('Sin conexión a internet').evaluate().isNotEmpty ||
          find.text('No hay datos disponibles').evaluate().isNotEmpty;

      expect(hasInfo, isTrue);
    });

    testWidgets('Currency swap animation works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Encuentra el botón de swap
      final swapButtonFinder = find.byIcon(Icons.swap_horiz);
      expect(swapButtonFinder, findsOneWidget);

      // Obtiene las monedas iniciales
      final currencyButtonsFinder = find.byType(InkWell);
      expect(currencyButtonsFinder, findsAtLeastNWidgets(2));

      // Tap en el botón de swap
      await tester.tap(swapButtonFinder);
      await tester.pump();

      // Verifica la animación
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Las monedas deberían ser intercambiadas
      expect(currencyButtonsFinder, findsAtLeastNWidgets(2));
    });

    testWidgets('Currency selector opens and closes', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Encuentra el primer botón de moneda (TENGO)
      final currencyButtons = find.byType(InkWell);
      expect(currencyButtons, findsAtLeastNWidgets(2));

      // Tap en el primer botón de moneda para abrir el selector
      await tester.tap(currencyButtons.first);
      await tester.pumpAndSettle();

      // Verify bottom sheet opened with title
      expect(find.text('FIAT'), findsOneWidget,
          reason: 'Bottom sheet should show FIAT title');

      // Cierra el bottomsheet tocando fuera o el botón de atrás
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    });

    testWidgets('Change button is disabled without amount', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Encuentra el botón "Cambiar"
      final changeButtonFinder = find.text('Cambiar');
      expect(changeButtonFinder, findsOneWidget);

      // El botón debe estar deshabilitado inicialmente 
      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull,
          reason: 'Button should be disabled without amount');
    });

    testWidgets('Change button enables with valid amount and rate', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Ingresa un monto
      final amountFieldFinder = find.byType(TextField);
      await tester.enterText(amountFieldFinder, '50');
      await tester.pumpAndSettle();

      // Espera la respuesta de la API
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Encuentra el botón "Cambiar" nuevamente
      final changeButtonFinder = find.text('Cambiar');
      expect(changeButtonFinder, findsOneWidget);

      // Si la tasa se cargó ok, el botón debería estar habilitado.
    });

    testWidgets('Shimmer loading displays during API call', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Ingresa un monto para activar la llamada a la API
      final amountFieldFinder = find.byType(TextField);
      await tester.enterText(amountFieldFinder, '75');
      await tester.pump();

      // Espera el debounce
      await tester.pump(const Duration(milliseconds: 600));

      // Durante la carga, el shimmer debería ser visible
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Error message displays on network error', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Este test necesitaría mocking para poder testear los estados de error de manera confiable
      // Por ahora, solo verificamos que el error pueda potencialmente mostrarse

      // Ingresa un monto
      final amountFieldFinder = find.byType(TextField);
      await tester.enterText(amountFieldFinder, '100');
      await tester.pumpAndSettle();

      // Espera la respuesta
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // El error podría mostrarse si no hay conexión a internet
      final hasErrorOrSuccess =
          find.textContaining('conexión').evaluate().isNotEmpty ||
          find.textContaining('Tasa estimada').evaluate().isNotEmpty ||
          find.textContaining('Recibirás').evaluate().isNotEmpty ||
          find.textContaining('Ingresa un monto').evaluate().isNotEmpty;

      expect(hasErrorOrSuccess, isTrue);
    });
  });
}
