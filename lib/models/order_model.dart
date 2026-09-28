class OrderModel {
  final String orderId;
  final String orderDate;
  final double totalAmount;
  final String orderStatus;
  final List<OrderItemModel> orderItems;
  final String? restaurantId;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    required this.orderStatus,
    required this.orderItems,
    this.restaurantId,
  });

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "orderDate": orderDate,
      "totalAmount": totalAmount,
      "orderStatus": orderStatus,
      "orderItems": orderItems.map((item) => item.toJson()).toList(),
      "restaurantId": restaurantId,
    };
  }
}

class OrderItemModel {
  final String itemName;
  final String itemImage;
  final double itemPrice;
  final int itemQuantity;

  OrderItemModel({
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.itemQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "itemName": itemName,
      "itemImage": itemImage,
      "itemPrice": itemPrice,
      "itemQuantity": itemQuantity,
    };
  }
}
