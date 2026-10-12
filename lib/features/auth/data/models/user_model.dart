import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String userName;
  final String userEmail;
  final String userImage;
  final String userUid;
  final double? latitude;
  final double? longitude;
  final String? address;

  const UserModel({
    required this.userEmail,
    required this.userImage,
    required this.userName,
    required this.userUid,
    this.latitude,
    this.longitude,
    this.address,
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
  }) : super(
          uid: uid ?? userUid,
          email: email ?? userEmail,
          displayName: displayName ?? userName,
          photoUrl: photoUrl ?? userImage,
        );

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      userEmail: user.email ?? "",
      userImage: user.photoURL ?? "",
      userName: user.displayName ?? "No Name",
      userUid: user.uid,
    );
  }
}
