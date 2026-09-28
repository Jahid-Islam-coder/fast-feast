import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/controllers/provider/review_cart_provider.dart';

void main() {
  group('CartProvider Computation Tests', () {
    test('getTotalPrice should return 0 when cart is empty', () {
      final cartProvider = CartProvider();
      expect(cartProvider.cartList, isEmpty);
      expect(cartProvider.getTotalPrice(), equals(0.0));
    });

    test('getQuantity should return 0 when cart is empty', () {
      final cartProvider = CartProvider();
      expect(cartProvider.getQuantity('item_1'), equals(0));
    });
  });
}
