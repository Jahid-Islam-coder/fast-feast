import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/common/custom_container.dart';

void main() {
  group('CustomContainer Widget Tests', () {
    testWidgets('renders child widget inside CustomContainer', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: CustomContainer(
                containerContent: Text('Inner Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Inner Content'), findsOneWidget);
      expect(find.byType(CustomContainer), findsOneWidget);
    });
  });
}
