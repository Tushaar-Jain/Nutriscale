import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/hybrid_layout.dart';
import 'package:nutriscale/src/repository/auth_repository/authentication_repository.dart';

class LoginController extends GetxController {
  // Observables for the form state
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email);
  }

  // Login function
  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Input validation
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill in both email and password");
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address");
      return;
    }

    isLoading.value = true; // Start loading

    String? error = await AuthenticationRepository.instance
        .loginWithEmailPassword(email, password);

    isLoading.value = false; // Stop loading

    if (error != null) {
      Get.snackbar("Login Failed", error);
    } else {
      Get.offAll(() => HybridLayoutScreen(), transition: Transition.fadeIn);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
