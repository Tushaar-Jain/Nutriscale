import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/hybrid_layout.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Get.back(); // remove loading if cancelled
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      // Check Firestore for username
      final userDoc = _firestore.collection('Users').doc(user!.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists || docSnapshot.data()?['fullname'] == null)
 {
        final username = await _promptForUsername();
        if (username != null && username.trim().isNotEmpty) {
          await userDoc.set({
            'Fullname': username.trim(),
            'Email': user.email,
          }, SetOptions(merge: true));
        }
      }

      Get.back(); // dismiss loading
      Get.offAll(() => HybridLayoutScreen());
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Google Sign-In failed: $e");
    }
  }

  Future<String?> _promptForUsername() async {
    TextEditingController controller = TextEditingController();
    return await Get.defaultDialog<String>(
      title: "Enter Username",
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Your username"),
      ),
      textCancel: "Cancel",
      textConfirm: "Submit",
      onConfirm: () {
        final entered = controller.text.trim();
        if (entered.isNotEmpty) {
          Get.back(result: entered);
        } else {
          Get.snackbar("Error", "Username cannot be empty");
        }
      },
      onCancel: () {
        Get.back(result: null);
      },
    );
  }
}
