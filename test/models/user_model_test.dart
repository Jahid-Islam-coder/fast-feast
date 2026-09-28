import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should instantiate UserModel with all fields', () {
      final user = UserModel(
        userEmail: 'test@example.com',
        userImage: 'http://example.com/profile.png',
        userName: 'John Doe',
        userUid: 'uid_123',
        latitude: 23.8103,
        longitude: 90.4125,
        address: 'Dhaka, Bangladesh',
      );

      expect(user.userEmail, equals('test@example.com'));
      expect(user.userImage, equals('http://example.com/profile.png'));
      expect(user.userName, equals('John Doe'));
      expect(user.userUid, equals('uid_123'));
      expect(user.latitude, equals(23.8103));
      expect(user.longitude, equals(90.4125));
      expect(user.address, equals('Dhaka, Bangladesh'));
    });

    test('should allow null optional location fields', () {
      final user = UserModel(
        userEmail: 'test@example.com',
        userImage: 'http://example.com/profile.png',
        userName: 'Jane Doe',
        userUid: 'uid_456',
      );

      expect(user.latitude, isNull);
      expect(user.longitude, isNull);
      expect(user.address, isNull);
    });
  });
}
