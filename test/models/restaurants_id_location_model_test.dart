import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/restaurants_id_location_model.dart';

void main() {
  group('RestaurantsIdLocationModel Tests', () {
    test('should instantiate and convert toMap properly', () {
      final loc = RestaurantsIdLocationModel(
        id: 'loc1',
        latitude: 23.7,
        longitude: 90.4,
      );

      final map = loc.toMap();

      expect(map['id'], equals('loc1'));
      expect(map['latitude'], equals(23.7));
      expect(map['longitude'], equals(90.4));
    });

    test('fromMap should parse correctly and fallback on defaults', () {
      final map = <String, dynamic>{
        'latitude': 23.8,
      };

      final loc = RestaurantsIdLocationModel.fromMap('loc2', map);

      expect(loc.id, equals('loc2'));
      expect(loc.latitude, equals(23.8));
      expect(loc.longitude, equals(0.0));
    });

    test('toJson and fromJson should serialize and deserialize properly', () {
      final loc = RestaurantsIdLocationModel(
        id: 'loc3',
        latitude: 24.1,
        longitude: 89.2,
      );

      final jsonStr = loc.toJson();
      final locFromJson = RestaurantsIdLocationModel.fromJson(jsonStr);

      expect(locFromJson.id, equals('loc3'));
      expect(locFromJson.latitude, equals(24.1));
      expect(locFromJson.longitude, equals(89.2));
    });
  });
}
