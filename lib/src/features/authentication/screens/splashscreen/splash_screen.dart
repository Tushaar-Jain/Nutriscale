import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/constants/image_string.dart';
import 'package:nutriscale/src/features/authentication/screens/welcomescreen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/hybrid_layout.dart'; // Firebase Auth

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check user authentication after 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // If user is logged in, navigate to Dashboard
        Get.off(() => HybridLayoutScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1));
      } else {
        // If user is not logged in, navigate to WelcomeScreen
        Get.off(() => const WelcomeScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double verticalOffset = -size.height * 0.18; // Move up by 18%

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            SizedBox.expand(
              child: Image.asset(splashScreenImage, fit: BoxFit.cover),
            ),

            // Centered Text
            Center(
              child: Transform.translate(
                offset: Offset(0, verticalOffset), // Move up by 18%
                child: Text(
                  'Welcome to NutriScale',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          Colors.purple,
                          Colors.green,
                        ],
                      ).createShader(
                        Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
                      ),
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
