import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stores user data in Firestore under "Users" collection.
  Future<void> createUser(UserModel user) async {
    try {
      if (user.id == null) {
        Get.snackbar(
          "Error",
          "User ID is missing. Cannot create user.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      await _db.collection("Users").doc(user.id).set(user.toJson());

      Get.snackbar(
        "Success",
        "Your account has been created",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent,
        colorText: Colors.black,
      );
    } catch (error) {
      print("🔥 Error creating user document: $error");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  /// Fetch user details for profile screen
  Future<UserModel> getUserDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("No user logged in");

    final doc = await _db.collection("Users").doc(uid).get();

    if (!doc.exists) {
      throw Exception("User not found");
    }

    return UserModel.fromSnapshot(doc);
  }

  /// Optional: Fetch user by ID (e.g., for admin views or multi-user apps)
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _db.collection("Users").doc(userId).get();

    if (!doc.exists) return null;

    return UserModel.fromSnapshot(doc);
  }
}
