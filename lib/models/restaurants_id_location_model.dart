import 'dart:convert';

class RestaurantsIdLocationModel {
  String id;
  double latitude;
  double longitude;

  RestaurantsIdLocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory RestaurantsIdLocationModel.fromMap(String id, Map map) {
    return RestaurantsIdLocationModel(
      id: id,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }
  String toJson() => json.encode(toMap());
  factory RestaurantsIdLocationModel.fromJson(String source) {
    final Map<String, dynamic> map = json.decode(source) as Map<String, dynamic>;
    return RestaurantsIdLocationModel.fromMap(
      map['id']?.toString() ?? '',
      map,
    );
  }





}

