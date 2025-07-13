import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/image_string.dart';
import 'package:nutriscale/src/constants/sizes.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/screens/loginscreen/login_screen.dart';
import 'package:nutriscale/src/features/authentication/screens/signupscreen/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final isDarkMode = mediaQuery.platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultSizePadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header Image
                Image.asset(
                  welcomeScreenImageNoBg,
                  height: height * 0.68,
                  width: width,
                  fit: BoxFit.contain,
                ),
            
                // Welcome Text
                Column(
                  children: [
                    Text(
                      tWelcomeScreenTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tWelcomeSubTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.black.withOpacity(0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            
                // Buttons
                Row(
                  children: [
                    // Login Button (Outlined)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.to(() => const LoginScreen()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isDarkMode ? Colors.white : Colors.black,
                          side: BorderSide(
                              color: isDarkMode
                                  ? Colors.white70
                                  : primaryAppColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          loginBtnTxt.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
            
                    // Signup Button (Filled)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const SignUpScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode ? secondaryAppColor : primaryAppColor,
                          foregroundColor: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          tSignUp.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
