import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/common/reusable_text.dart';

void main() {
  group('ReusableText Widget Tests', () {
    testWidgets('renders text with provided style correctly', (WidgetTester tester) async {
      const testText = 'Hello FastFeast';
      const testStyle = TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReusableText(
              text: testText,
              style: testStyle,
            ),
          ),
        ),
      );

      final textFinder = find.text(testText);
      expect(textFinder, findsOneWidget);

      final Text textWidget = tester.widget(textFinder);
      expect(textWidget.style?.fontSize, equals(18));
      expect(textWidget.style?.color, equals(Colors.red));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(textWidget.softWrap, isFalse);
      expect(textWidget.textAlign, equals(TextAlign.left));
    });
  });
}
