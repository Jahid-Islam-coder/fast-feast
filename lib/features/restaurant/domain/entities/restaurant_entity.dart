class RestaurantEntity {
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

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    this.ratingCount,
    required this.address,
    required this.cuisineType,
    required this.isAvailable,
    this.categories,
    this.searchKeywords,
  });
}
