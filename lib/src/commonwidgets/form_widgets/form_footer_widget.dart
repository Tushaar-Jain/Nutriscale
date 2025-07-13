import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/image_string.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/screens/signupscreen/sign_up_screen.dart';
import 'package:nutriscale/src/google_sign_in_services/auth_services.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key,
  required});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text("OR"),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white),),
            onPressed: () =>AuthService().signInWithGoogle(),
            icon: Image(image: AssetImage(googleImage), width: 20),
            label: Text(
              signInWithGoogle,
              style: TextStyle(
                color: isDarkMode ? secondaryAppColor : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            Get.to(() => SignUpScreen());
          },
          child: Text.rich(
            TextSpan(
              text: tDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(text: tSignUp, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
