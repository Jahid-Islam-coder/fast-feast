import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

// handles user profile and address in firebase database
class UserProvider with ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  UserModel? _currentData;
  bool _isLoading = false;

  UserModel? get currentUserData => _currentData;

  bool get isLoading => _isLoading;

  // save user info to firebase
  Future<void> addUserData({
    required User currentUser,
    required String userName,
    required String userEmail,
    String userImage = "",
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.child("users/${currentUser.uid}/profile").set({
        "userName": userName,
        "userEmail": userEmail,
        "userImage": userImage,
        "userUid": currentUser.uid,
        "updatedAt": ServerValue.timestamp,
      });
      
      // refresh local copy
      await getUserData();
    } catch (e) {
      debugPrint("Error saving user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // fetch profile and address from firebase
  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // grab both in parallel
      final profileFuture = _db.child("users/${user.uid}/profile").get();
      final addressFuture = _db.child("users/${user.uid}/address").get();
      
      final results = await Future.wait([profileFuture, addressFuture]);
      DataSnapshot profileSnapshot = results[0];
      DataSnapshot addressSnapshot = results[1];
      
      if (profileSnapshot.exists) {
        Map profileData = profileSnapshot.value as Map;
        Map? addressData = addressSnapshot.exists ? addressSnapshot.value as Map : null;
        
        _currentData = UserModel(
          userEmail: profileData["userEmail"]?.toString() ?? "",
          userImage: profileData["userImage"]?.toString() ?? "",
          userName: profileData["userName"]?.toString() ?? "",
          userUid: profileData["userUid"]?.toString() ?? "",
          latitude: addressData?["latitude"] != null ? (addressData!["latitude"] as num).toDouble() : null,
          longitude: addressData?["longitude"] != null ? (addressData!["longitude"] as num).toDouble() : null,
          address: addressData?["address"]?.toString(),
        );
        notifyListeners();
      } else {
        // create profile record if first time logging in (e.g. google sign in)
        await _db.child("users/${user.uid}/profile").set({
          "userName": user.displayName ?? "User",
          "userEmail": user.email ?? "",
          "userImage": user.photoURL ?? "",
          "userUid": user.uid,
          "updatedAt": ServerValue.timestamp,
        });

        Map? addressData = addressSnapshot.exists ? addressSnapshot.value as Map : null;
        _currentData = UserModel(
          userEmail: user.email ?? "",
          userImage: user.photoURL ?? "",
          userName: user.displayName ?? "User",
          userUid: user.uid,
          latitude: addressData?["latitude"] != null ? (addressData!["latitude"] as num).toDouble() : null,
          longitude: addressData?["longitude"] != null ? (addressData!["longitude"] as num).toDouble() : null,
          address: addressData?["address"]?.toString(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  // clear profile state on logout
  void clearUserData() {
    _currentData = null;
    notifyListeners();
  }
}
