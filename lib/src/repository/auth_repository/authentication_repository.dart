import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nutriscale/network_manager.dart';
import 'package:nutriscale/src/features/authentication/screens/splashscreen/splash_screen.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/hybrid_layout.dart';
import 'package:nutriscale/src/repository/auth_repository/exceptions/sign_up_email_pass_fail.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const SplashScreen())
        : Get.offAll(() =>  HybridLayoutScreen());
  }

  Future<void> sendPasswordResetViaEmail(String email) async {
  if (!await NetworkManager.isConnected()) {
    throw const SignupEmailPassFailure(
      "No internet connection. Please check your network.",
    );
  }

  try {
    await _auth.sendPasswordResetEmail(email: email);
    
    // Show a message to the user
    Get.snackbar(
      "Success",
      "If this email is registered, a reset link will be sent.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.black,
    );
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase exceptions
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = "This email is not registered.";
        break;
      case 'invalid-email':
        errorMessage = "The email address is badly formatted.";
        break;
      default:
        errorMessage = "An error occurred: ${e.message}";
        break;
    }
    Get.snackbar(
      "Error",
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
    );
    throw SignupEmailPassFailure.code(e.code);
  } catch (_) {
    // Handle any other errors
    throw const SignupEmailPassFailure();
  }
}


  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
  if (!await NetworkManager.isConnected()) {
    throw const SignupEmailPassFailure("No internet connection. Please check your network.");
  }
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Navigation based on userCredential
    if (userCredential.user != null) {
      Get.offAll(() => HybridLayoutScreen());
    } else {
      Get.to(() => const SplashScreen());
    }

    return userCredential; // <-- Return this so caller gets UserCredential

  } on FirebaseAuthException catch (e) {
    throw SignupEmailPassFailure.code(e.code);
  } catch (_) {
    throw const SignupEmailPassFailure();
  }
}


  Future<void> logout() async {
    if (!await NetworkManager.isConnected()) {
      throw Exception("No internet connection. Cannot log out.");
    }
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Failed to log out: $e");
    }
  }

  Future<String?> loginWithEmailPassword(String email, String password) async {
    if (!await NetworkManager.isConnected()) {
    return "No internet connection. Please check your network.";
  }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "This email is not registered with MyApp.";
        case 'wrong-password':
          return "Incorrect password. Please try again.";
        case 'invalid-email':
          return "The email address format is invalid.";
        case 'invalid-credential':
          return "Invalid email or password.";
        case 'user-disabled':
          return "This user account has been disabled.";
        default:
          return "Authentication failed: ${e.message}";
      }
    } catch (e) {
      return "An unexpected error occurred. Please try again later.";
    }
  }
}
