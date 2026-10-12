import 'dart:convert';
import '../../domain/entities/restaurant_entity.dart';

class RestaurantDetailModel extends RestaurantEntity {
  const RestaurantDetailModel({
    required super.isAvailable,
    required super.id,
    required super.name,
    required super.image,
    required super.rating,
    super.ratingCount,
    required super.address,
    required super.cuisineType,
    super.categories,
    super.searchKeywords,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'ratingCount': ratingCount,
      'address': address,
      'cuisineType': cuisineType,
      'isAvailable': isAvailable,
      'categories': categories,
      'searchKeywords': searchKeywords,
    };
  }

  factory RestaurantDetailModel.fromMap(String id, Map map) {
    return RestaurantDetailModel(
      id: id,
      name: map['name']?.toString() ?? "No Name",
      image: map['image']?.toString() ?? "",
      rating: map['rating']?.toDouble() ?? 0.0,
      ratingCount: map['ratingCount']?.toInt() ?? 0,
      address: map['address']?.toString() ?? "No Address",
      cuisineType: map['cuisineType']?.toString() ?? "No Cuisine Type",
      isAvailable: map['isAvailable'] ?? false,
      categories: map['categories'] as Map<dynamic, dynamic>?,
      searchKeywords: map['searchKeywords'] as Map<dynamic, dynamic>?,
    );
  }

  String toJson() => json.encode(toMap());
  factory RestaurantDetailModel.fromJson(String source) =>
      RestaurantDetailModel.fromMap(
          source, json.decode(source) as Map<String, dynamic>);
}
