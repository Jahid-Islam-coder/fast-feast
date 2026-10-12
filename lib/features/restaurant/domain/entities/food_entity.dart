class FoodEntity {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;
  final String category;
  final String? restaurantId;

  const FoodEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    this.restaurantId,
  });
}
