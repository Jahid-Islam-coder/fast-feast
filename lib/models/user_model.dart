class UserModel {
  String userName;
  String userEmail;
  String userImage;
  String userUid;
  double? latitude;
  double? longitude;
  String? address;

  UserModel({
    required this.userEmail,
    required this.userImage,
    required this.userName,
    required this.userUid,
    this.latitude,
    this.longitude,
    this.address,
  });
}
