import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/features/authentication/controllers/forgot_password_controller.dart';
import 'package:nutriscale/src/commonwidgets/form_widgets/form_header_widget.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/image_string.dart';
import 'package:nutriscale/src/constants/sizes.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/screens/loginscreen/login_screen.dart'; // Import login screen

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());
    final controller = ForgotPasswordController.instance;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSizePadding),
            child: Column(
              children: [
                const SizedBox(height: defaultSizePadding * 4),
                FormHeaderWidget(
                  image: forgetPasswordImage,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spaceBetween: 10.0,
                  title: forgotPasswordTitle,
                  subtitle: forgotPasswordSubTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Form(
                  key: controller.forgotPasswordFormkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.email,
                        decoration: const InputDecoration(
                          label: Text(hintEmail),
                          hintText: hintEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              primaryAppColor,
                            ),
                          ),
                          onPressed: () async {
                            if (controller.forgotPasswordFormkey.currentState!.validate()) {
                              await controller.sendPasswordResetEmail(); // Trigger the controller method

                              // Show success message
                              Get.snackbar(
                                "Success",
                                "Password reset link has been sent to your email.",
                                snackPosition: SnackPosition.BOTTOM,
                              );

                              // Redirect to login screen after 2 seconds
                              Future.delayed(const Duration(seconds: 2), () {
                                Get.offAll(() => const LoginScreen()); // Navigate to login screen
                              });
                            }
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
