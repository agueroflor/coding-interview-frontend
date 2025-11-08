import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';

void main() {
  group('CircularBackground', () {
    testWidgets('renders correctly with base background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularBackground(),
          ),
        ),
      );

      expect(find.byType(CircularBackground), findsOneWidget);
      expect(find.byType(ClipRect), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CircularBackground),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });

    testWidgets('contains Container with background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularBackground(),
          ),
        ),
      );

      final containerFinder = find.descendant(
        of: find.descendant(
          of: find.byType(CircularBackground),
          matching: find.byType(Stack),
        ),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsWidgets);
    });

    testWidgets('contains Positioned widget for circular decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularBackground(),
          ),
        ),
      );

      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('circular decoration has correct shape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularBackground(),
          ),
        ),
      );

      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      final container = positioned.child as Container;
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, AppColors.primary);
    });
  });
}
