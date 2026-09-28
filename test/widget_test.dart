// This is a basic Flutter widget test for the FastFeast app.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/common/reusable_text.dart';

void main() {
  testWidgets('ReusableText widget smoke test', (WidgetTester tester) async {
    // Build ReusableText widget inside ScreenUtilInit context and trigger a frame.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const MaterialApp(
          home: Scaffold(
            body: ReusableText(
              text: 'FastFeast Food Delivery',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ),
    );

    // Verify that our app header text is found on screen.
    expect(find.text('FastFeast Food Delivery'), findsOneWidget);
  });
}
