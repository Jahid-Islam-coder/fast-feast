import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/controllers/provider/bottom_navigation_bar_provider.dart';

void main() {
  group('TabIndexController Tests', () {
    test('initial tabIndex should be 0', () {
      final controller = TabIndexController();
      expect(controller.tabIndex, equals(0));
    });

    test('updating tabIndex should change state and notify listeners', () {
      final controller = TabIndexController();
      bool listenerCalled = false;

      controller.addListener(() {
        listenerCalled = true;
      });

      controller.tabIndex = 2;

      expect(controller.tabIndex, equals(2));
      expect(listenerCalled, isTrue);
    });
  });
}
