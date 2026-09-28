import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../models/review_cart_model.dart';

class CartProvider with ChangeNotifier {
  final DatabaseReference? _dbRef;
  CartProvider({DatabaseReference? db}) : _dbRef = db;

  DatabaseReference get _db => _dbRef ?? FirebaseDatabase.instance.ref();
  List<ReviewCartModel> _cartList = [];
  bool _isLoading = false;

  List<ReviewCartModel> get cartList => _cartList;
  bool get isLoading => _isLoading;

  // add or update cart item in firebase
  Future<void> addToCart({
    required String cartId,
    required String cartName,
    required String cartImage,
    required double cartPrice,
    required int cartQuantity,
    String? restaurantId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _db.child("users/${user.uid}/cart/$cartId").set({
        "cartId": cartId,
        "cartName": cartName,
        "cartImage": cartImage,
        "cartPrice": cartPrice,
        "cartQuantity": cartQuantity,
        "restaurantId": restaurantId,
      });
      await getCartData();
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }

  // fetch user's cart from firebase
  Future<void> getCartData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      DataSnapshot snapshot = await _db.child("users/${user.uid}/cart").get();
      if (snapshot.exists) {
        List<ReviewCartModel> newList = [];
        
        if (snapshot.value is Map) {
          Map data = snapshot.value as Map;
          data.forEach((key, value) {
            if (value is Map) {
              newList.add(ReviewCartModel(
                cartId: value["cartId"]?.toString() ?? "",
                cartImage: value["cartImage"]?.toString() ?? "",
                cartName: value["cartName"]?.toString() ?? "",
                cartPrice: (value["cartPrice"] as num?)?.toDouble() ?? 0.0,
                cartQuantity: (value["cartQuantity"] as num?)?.toInt() ?? 0,
                cartUnit: value["cartUnit"],
                restaurantId: value["restaurantId"]?.toString(),
              ));
            }
          });
        } else if (snapshot.value is List) {
          List data = snapshot.value as List;
          for (var value in data) {
            if (value != null && value is Map) {
              newList.add(ReviewCartModel(
                cartId: value["cartId"]?.toString() ?? "",
                cartImage: value["cartImage"]?.toString() ?? "",
                cartName: value["cartName"]?.toString() ?? "",
                cartPrice: (value["cartPrice"] as num?)?.toDouble() ?? 0.0,
                cartQuantity: (value["cartQuantity"] as num?)?.toInt() ?? 0,
                cartUnit: value["cartUnit"],
                restaurantId: value["restaurantId"]?.toString(),
              ));
            }
          }
        }
        _cartList = newList;
      } else {
        _cartList = [];
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // delete item from cart
  Future<void> deleteCartItem(String cartId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _db.child("users/${user.uid}/cart/$cartId").remove();
      await getCartData();
    } catch (e) {
      debugPrint("Error deleting from cart: $e");
    }
  }

  // calculate cart total
  double getTotalPrice() {
    double total = 0.0;
    for (var element in _cartList) {
      total += element.cartPrice * element.cartQuantity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  // check item quantity in cart
  int getQuantity(String cartId) {
    int index = _cartList.indexWhere((element) => element.cartId == cartId);
    return index != -1 ? _cartList[index].cartQuantity : 0;
  }

  // clear entire cart
  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _db.child("users/${user.uid}/cart").remove();
      _cartList = [];
      notifyListeners();
    } catch (e) {
      debugPrint("Error clearing cart: $e");
    }
  }
}
