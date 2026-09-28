class ReviewCartModel {
  String cartId;
  String cartImage;
  String cartName;
  double cartPrice;
  int cartQuantity;
  dynamic cartUnit;
  String? restaurantId;

  ReviewCartModel({
    required this.cartId,
    required this.cartImage,
    required this.cartName,
    required this.cartPrice,
    required this.cartQuantity,
    this.cartUnit,
    this.restaurantId,
  });
}
