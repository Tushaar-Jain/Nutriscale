import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/commonwidgets/form_widgets/form_footer_widget.dart';
import 'package:nutriscale/src/commonwidgets/form_widgets/form_header_widget.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/image_string.dart';
import 'package:nutriscale/src/constants/sizes.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/screens/loginscreen/forget_password_screen/forget_pass_scree.dart';
import 'package:nutriscale/src/features/authentication/screens/loginscreen/login_controller.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    final LoginController controller = Get.put(LoginController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDarkMode ? null : Colors.white,
            gradient: isDarkMode
                ? const LinearGradient(
                    colors: [
                      primaryAppColor,
                      Colors.black12, // Medium Green
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [
                      primaryAppColor,
                      secondaryAppColor, // Medium Green
                    ],
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
                    title: loginTitle,
                    subtitle: loginSubTitle,
                  ),
                  const SizedBox(height: 24),
                  _loginFormWidget(context, controller),
                  const SizedBox(height: 7),
                  LoginFooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginFormWidget(BuildContext context, LoginController controller) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Email Field
          TextFormField(
            controller: controller.emailController,
            style: TextStyle(color: Colors.green),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.person_outline_outlined),
              labelText: hintEmail,
              labelStyle: TextStyle(color: Colors.black),
              hintText: hintEmail,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Password Field
          Obx(() => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: hintPassword,
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: hintPassword,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              )),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ForgetPasswordScreen.buildShowModelBottomSheet(context);
              },
              child: Text(
                forgetPassword,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Login Button
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? secondaryAppColor : primaryAppColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          loginBtnTxt.toUpperCase(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.green : Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              )),
        ],
      ),
    );
  }
}
