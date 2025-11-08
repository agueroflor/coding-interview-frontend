import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/presentation/widgets/widgets.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';

void main() {
  group('InfoStateWidget', () {
    testWidgets('renders loading state with ShimmerLoading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.loading,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerLoading), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders error state with default message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.error,
            ),
          ),
        ),
      );

      expect(find.text('Error desconocido'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders error state with custom message', (tester) async {
      const errorMessage = 'Error al cargar datos';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.error,
              message: errorMessage,
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Error desconocido'), findsNothing);
    });

    testWidgets('error message has correct style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.error,
              message: 'Test error',
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test error'));
      expect(text.style, AppTextStyles.errorMessage);
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('renders placeholder state with default message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.placeholder,
            ),
          ),
        ),
      );

      expect(find.text('Sin información'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders placeholder state with custom message', (tester) async {
      const placeholderMessage = 'Ingresa un monto\n para ver la conversión';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.placeholder,
              message: placeholderMessage,
            ),
          ),
        ),
      );

      expect(find.text(placeholderMessage), findsOneWidget);
      expect(find.text('Sin información'), findsNothing);
    });

    testWidgets('placeholder message has correct style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.placeholder,
              message: 'Test placeholder',
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test placeholder'));
      expect(text.style, AppTextStyles.conversionPlaceholder);
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('loading state has correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.loading,
            ),
          ),
        ),
      );

      final paddingFinder = find.descendant(
        of: find.byType(ShimmerLoading),
        matching: find.byType(Padding),
      );
      
      expect(paddingFinder, findsWidgets);
      
      final padding = tester.widget<Padding>(paddingFinder.first);
      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('error state has correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.error,
              message: 'Error',
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.text('Error'),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('placeholder state has correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.placeholder,
              message: 'Placeholder',
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.text('Placeholder'),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('switches between states correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.loading,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerLoading), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.error,
              message: 'Error occurred',
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerLoading), findsNothing);
      expect(find.text('Error occurred'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoStateWidget(
              state: InfoState.placeholder,
              message: 'Enter data',
            ),
          ),
        ),
      );

      expect(find.text('Error occurred'), findsNothing);
      expect(find.text('Enter data'), findsOneWidget);
    });
  });
}
