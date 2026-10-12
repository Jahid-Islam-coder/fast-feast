import 'dart:convert';
import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.description,
    required super.category,
    super.restaurantId,
  });

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
