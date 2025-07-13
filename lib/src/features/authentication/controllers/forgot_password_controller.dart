import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/repository/auth_repository/authentication_repository.dart';
import 'package:nutriscale/src/repository/auth_repository/exceptions/sign_up_email_pass_fail.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final email = TextEditingController();
  final forgotPasswordFormkey = GlobalKey<FormState>();

  Future<void> sendPasswordResetEmail() async {
    if (!forgotPasswordFormkey.currentState!.validate()) return;

    try {
      await AuthenticationRepository.instance.sendPasswordResetViaEmail(
        email.text.trim(),
      );

      Get.snackbar(
        "Success",
        "Password reset email sent.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.black,
      );
    } on SignupEmailPassFailure catch (e) {
      Get.snackbar(
        "Error",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
