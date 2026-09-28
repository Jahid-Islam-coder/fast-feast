import 'dart:convert';

class CategoryModel{
  final String id;
  final String name;
  final String imageUrl;
  final String? description;

  // Constructor
  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
  });

  // convert to map
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // map to model
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);



}