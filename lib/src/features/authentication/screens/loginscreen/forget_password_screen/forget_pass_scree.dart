import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nutriscale/src/constants/sizes.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/controllers/forgot_password_controller.dart';
import 'package:nutriscale/src/features/authentication/screens/loginscreen/forget_password_screen/forgot_pass_button.dart';
import 'package:nutriscale/src/features/authentication/screens/loginscreen/forget_password_screen/forgot_pass_mail_screen.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(defaultSizePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forgotPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  forgotPasswordSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 30.0),
                ForgetPasswordBtnWidget(
                  onTap: () {
                    Navigator.pop(context);

                    // Safely register the controller only once
                    if (!Get.isRegistered<ForgotPasswordController>()) {
                      Get.put(ForgotPasswordController());
                    }

                    Get.to(() => ForgetPasswordMailScreen());
                  },
                  btnIcon: Icons.mail_outline_sharp,
                  title: hintEmail,
                  subtitle: resetViaEmail,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
    );
  }
}
