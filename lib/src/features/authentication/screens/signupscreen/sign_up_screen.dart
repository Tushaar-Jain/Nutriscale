import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nutriscale/src/commonwidgets/form_widgets/form_header_widget.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/image_string.dart';
import 'package:nutriscale/src/constants/sizes.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/controllers/sign_up_controller.dart';
import 'package:nutriscale/src/features/authentication/screens/signupscreen/sign_up_footer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final controller = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient:
                isDarkMode
                    ? const LinearGradient(
                      colors: [primaryAppColor, Colors.black12],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : const LinearGradient(
                      colors: [primaryAppColor, secondaryAppColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(defaultSizePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormHeaderWidget(
                    image: loginHeaderImage,
                    title: signUpTitle,
                    subtitle: signUpSubTitle,
                  ),
                  const SizedBox(height: 24),
                  _signUpFormWidget(context, isDarkMode),
                  const SizedBox(height: 7),
                  SignUpFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpFormWidget(BuildContext context, bool isDarkMode) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.fullName,
            validator: (value) => value!.isEmpty ? 'Enter your name' : null,
            style: TextStyle(color: Colors.green),
            decoration: _inputDecoration(
              Icons.person_outline_outlined,
              userName,
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: controller.email,
            validator: (value) => value!.isEmpty ? 'Enter email' : null,
            style: TextStyle(color: Colors.green),
            decoration: _inputDecoration(
              Icons.mail_outline_outlined,
              hintEmail,
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: controller.password,
            validator: (value) => value!.isEmpty ? 'Enter password' : null,
            obscureText: _obscurePassword,
            decoration: _inputDecoration(
              Icons.lock_outline,
              hintPassword,
              toggle: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              isObscured: _obscurePassword,
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: controller.confirmPassword,
            validator: (value) => value!.isEmpty ? 'Confirm password' : null,
            obscureText: _obscureConfirmPassword,
            decoration: _inputDecoration(
              Icons.lock_outline,
              confirmPassword,
              toggle: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              isObscured: _obscureConfirmPassword,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  controller.registerUser();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? secondaryAppColor : primaryAppColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                tSignUp.toUpperCase(),
                style: TextStyle(
                  color: isDarkMode ? Colors.green : Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    IconData icon,
    String label, {
    VoidCallback? toggle,
    bool? isObscured,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon),
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      suffixIcon:
          toggle != null
              ? IconButton(
                icon: Icon(
                  isObscured! ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: toggle,
              )
              : null,
    );
  }
}
