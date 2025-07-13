import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/features/authentication/models/user_model.dart';
import 'package:nutriscale/src/repository/auth_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutriscale/src/repository/auth_repository/exceptions/sign_up_email_pass_fail.dart';
import 'package:nutriscale/src/repository/user_repository/user_repository.dart';
import 'package:nutriscale/src/utils/security_util.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final confirmPassword = TextEditingController();
  final userRepo = Get.put(UserRepository());

  void registerUser() async {
    final fullNameText = fullName.text.trim();
    final emailText = email.text.trim();
    final passwordText = password.text.trim();
    final confirmPasswordText = confirmPassword.text.trim();

    if (passwordText != confirmPasswordText) {
      Get.snackbar(
        "Password Mismatch",
        "Password and Confirm Password do not match.",
      );
      return;
    }

    try {
      UserCredential userCredential = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(emailText, passwordText);

      // Build UserModel with the newly created Firebase UID
      final user = UserModel(
        id: userCredential.user?.uid,
        fullName: fullNameText,
        eMail: emailText,
        password: hashPassword(passwordText),
      );
      await userRepo.createUser(user);
      Get.snackbar("Success", "User registered successfully!");
    } on FirebaseAuthException catch (e) {
      final error = SignupEmailPassFailure.code(e.code);
      Get.snackbar("Error", error.message);
    } catch (_) {
      const error = SignupEmailPassFailure();
      Get.snackbar("Error", error.message);
    }
  }
}
