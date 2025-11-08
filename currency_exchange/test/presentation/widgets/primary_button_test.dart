import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders button with text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Cambiar',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Cambiar'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('calls onPressed callback when tapped and enabled', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled (null callback)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Disabled Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('has correct default height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.maxHeight, 48);
    });

    testWidgets('respects custom height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
              height: 60,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.maxHeight, 60);
    });

    testWidgets('has full width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.maxWidth, double.infinity);
    });

    testWidgets('has correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Button'));
      expect(text.style, AppTextStyles.changeButton);
    });

    testWidgets('has correct border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({}) as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('has correct background color when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final backgroundColor = button.style?.backgroundColor?.resolve({});
      expect(backgroundColor, AppColors.primary);
    });

    testWidgets('has correct background color when disabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final disabledColor = button.style?.backgroundColor?.resolve({WidgetState.disabled});
      expect(disabledColor, AppColors.disabledBackground);
    });

    testWidgets('has correct foreground color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final foregroundColor = button.style?.foregroundColor?.resolve({});
      expect(foregroundColor, Colors.white);
    });

    testWidgets('has no elevation on button itself', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.elevation?.resolve({}), 0);
    });

    testWidgets('has shadow on container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotEmpty);
      expect(decoration.boxShadow!.first.color, AppColors.shadowDarkest);
      expect(decoration.boxShadow!.first.blurRadius, 3);
      expect(decoration.boxShadow!.first.offset, const Offset(0, 2));
    });

    testWidgets('maintains enabled state through rebuilds', (tester) async {
      bool enabled = true;
      VoidCallback? getCallback() => enabled ? () {} : null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: getCallback(),
            ),
          ),
        ),
      );

      ElevatedButton button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      enabled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Button',
              onPressed: getCallback(),
            ),
          ),
        ),
      );

      button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
