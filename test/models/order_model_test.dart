import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/order_model.dart';

void main() {
  group('OrderModel and OrderItemModel Tests', () {
    test('should instantiate OrderItemModel and convert to Json', () {
      final item = OrderItemModel(
        itemName: 'Chicken Nuggets',
        itemImage: 'http://example.com/nuggets.png',
        itemPrice: 5.99,
        itemQuantity: 3,
      );

      final jsonMap = item.toJson();

      expect(jsonMap['itemName'], equals('Chicken Nuggets'));
      expect(jsonMap['itemImage'], equals('http://example.com/nuggets.png'));
      expect(jsonMap['itemPrice'], equals(5.99));
      expect(jsonMap['itemQuantity'], equals(3));
    });

    test('should instantiate OrderModel and convert to Json', () {
      final item = OrderItemModel(
        itemName: 'Fries',
        itemImage: 'http://example.com/fries.png',
        itemPrice: 2.99,
        itemQuantity: 1,
      );

      final order = OrderModel(
        orderId: 'ORD_12345',
        orderDate: '2025-01-01T12:00:00Z',
        totalAmount: 2.99,
        orderStatus: 'Placed',
        restaurantId: 'rest_01',
        orderItems: [item],
      );

      final jsonMap = order.toJson();

      expect(jsonMap['orderId'], equals('ORD_12345'));
      expect(jsonMap['orderDate'], equals('2025-01-01T12:00:00Z'));
      expect(jsonMap['totalAmount'], equals(2.99));
      expect(jsonMap['orderStatus'], equals('Placed'));
      expect(jsonMap['restaurantId'], equals('rest_01'));
      expect((jsonMap['orderItems'] as List).length, equals(1));
    });
  });
}
