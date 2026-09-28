import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/common/heading.dart';

void main() {
  group('Heading Widget Tests', () {
    testWidgets('renders title text and triggers onTap callback on grid icon tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 375,
                child: Heading(
                  text: 'Categories',
                  onTap: () {
                    tapped = true;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Categories'), findsOneWidget);
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
