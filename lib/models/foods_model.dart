import 'dart:convert';

class FoodModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;
  final String category;
  final String? restaurantId;

  // 1. Standard Constructor
  FoodModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    this.restaurantId,
  });

  // convert to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'category': category,
      'restaurantId': restaurantId,
    };
  }

  // map to model
  factory FoodModel.fromMap(String id, Map data) {
    return FoodModel(
      id: id,
      name: data['name']?.toString() ?? "No Name",
      image: data['image']?.toString() ?? "",
      price: data['price']?.toDouble() ?? 0.0,
      description: data['description']?.toString() ?? "No Description",
      category: data['category']?.toString() ?? "No Category",
      restaurantId: data['restaurantId']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());
  factory FoodModel.fromJson(String id, String source) =>
      FoodModel.fromMap(id, json.decode(source) as Map<String, dynamic>);

}
