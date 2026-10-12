import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fastfeast/controllers/provider/location_provider.dart';

void main() {
  group('LocationProvider Tests', () {
    test('initial values should be empty and not loading', () {
      final provider = LocationProvider();
      expect(provider.pickedLocation, isNull);
      expect(provider.address, isEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('getCoordinatesFromAddress should return null for empty string', () async {
      final provider = LocationProvider();
      final loc = await provider.getCoordinatesFromAddress('   ');
      expect(loc, isNull);
    });

    test('setPickedLocation updates pickedLocation and notifies listeners', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final provider = LocationProvider();
      int notifyCount = 0;
      provider.addListener(() {
        notifyCount++;
      });

      const target = LatLng(37.3892, -122.0819);
      await provider.setPickedLocation(target);

      expect(provider.pickedLocation, equals(target));
      expect(notifyCount, greaterThan(0));
    });
  });
}
