import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../models/review_cart_model.dart';

class OrderProvider with ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> addOrder({
    required List<ReviewCartModel> cartItems,
    required double totalAmount,
    String? restaurantId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      String orderId = "ORD_${DateTime.now().millisecondsSinceEpoch}";
      
      OrderModel newOrder = OrderModel(
        orderId: orderId,
        orderDate: DateTime.now().toIso8601String(),
        totalAmount: totalAmount,
        orderStatus: "Placed",
        restaurantId: restaurantId,
        orderItems: cartItems.map((item) => OrderItemModel(
          itemName: item.cartName,
          itemImage: item.cartImage,
          itemPrice: item.cartPrice,
          itemQuantity: item.cartQuantity,
        )).toList(),
      );

      // save under User Orders node
      await _db.child("User Orders").child(user.uid).child(orderId).set(newOrder.toJson());
      
      debugPrint("Order saved successfully: $orderId");
      await getOrders(); // reload list
    } catch (e) {
      debugPrint("Error saving order: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      DataSnapshot snapshot = await _db.child("User Orders").child(user.uid).get();
      if (snapshot.exists) {
        List<OrderModel> newList = [];
        Map data = snapshot.value as Map;
        data.forEach((key, value) {
          if (value is Map) {
            List<OrderItemModel> items = [];
            if (value["orderItems"] != null) {
              for (var item in (value["orderItems"] as List)) {
                items.add(OrderItemModel(
                  itemName: item["itemName"] ?? "",
                  itemImage: item["itemImage"] ?? "",
                  itemPrice: (item["itemPrice"] as num?)?.toDouble() ?? 0.0,
                  itemQuantity: (item["itemQuantity"] as num?)?.toInt() ?? 0,
                ));
              }
            }

            newList.add(OrderModel(
              orderId: value["orderId"] ?? "",
              orderDate: value["orderDate"] ?? "",
              totalAmount: (value["totalAmount"] as num?)?.toDouble() ?? 0.0,
              orderStatus: value["orderStatus"] ?? "",
              restaurantId: value["restaurantId"],
              orderItems: items,
            ));
          }
        });
        _orders = newList;
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // clear cached orders on logout
  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}
