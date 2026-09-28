import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/delivery_address_model.dart';

void main() {
  group('DeliveryAddressModel Tests', () {
    test('should instantiate DeliveryAddressModel correctly', () {
      final address = DeliveryAddressModel(
        addressType: 'Home',
        aera: 'Downtown',
        alternateMobileNo: '01700000000',
        city: 'Metropolis',
        firstName: 'John',
        landMark: 'Near Central Park',
        lastName: 'Doe',
        mobileNo: '01800000000',
        pinCode: '1200',
        street: 'Main Street 12',
        scoirty: 'Green Housing',
      );

      expect(address.firstName, equals('John'));
      expect(address.lastName, equals('Doe'));
      expect(address.city, equals('Metropolis'));
      expect(address.pinCode, equals('1200'));
      expect(address.addressType, equals('Home'));
    });
  });
}
