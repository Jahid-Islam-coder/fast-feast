import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/review_cart_model.dart';

void main() {
  group('ReviewCartModel Tests', () {
    test('should instantiate ReviewCartModel correctly', () {
      final cartItem = ReviewCartModel(
        cartId: 'c1',
        cartImage: 'http://example.com/item.png',
        cartName: 'Cheese Burger',
        cartPrice: 8.50,
        cartQuantity: 2,
        cartUnit: '1 pc',
        restaurantId: 'rest101',
      );

      expect(cartItem.cartId, equals('c1'));
      expect(cartItem.cartName, equals('Cheese Burger'));
      expect(cartItem.cartPrice, equals(8.50));
      expect(cartItem.cartQuantity, equals(2));
      expect(cartItem.cartUnit, equals('1 pc'));
      expect(cartItem.restaurantId, equals('rest101'));
    });
  });
}
