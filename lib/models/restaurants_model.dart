import 'dart:convert';

class RestaurantDetailModel {
  final String id;
  final String name;
  final String image;
  final double? rating;
  final int? ratingCount;
  final String address;
  final String? cuisineType;
  final bool? isAvailable;
  final Map<dynamic, dynamic>? categories;
  final Map<dynamic, dynamic>? searchKeywords;

  RestaurantDetailModel({
    required this.isAvailable,
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    this.ratingCount,
    required this.address,
    required this.cuisineType,
    this.categories,
    this.searchKeywords,
  });
  // convert to map
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

  // map to model
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
