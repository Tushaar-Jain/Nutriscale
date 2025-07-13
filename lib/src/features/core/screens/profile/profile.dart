import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/features/authentication/models/user_model.dart';
import 'package:nutriscale/src/features/authentication/screens/welcomescreen/welcome_screen.dart';
import 'package:nutriscale/src/features/core/screens/maintain_cal/maintain_cal.dart';
import 'package:nutriscale/src/features/core/screens/profile/edit_profile.dart';
import 'package:nutriscale/src/features/core/screens/profile/profile_image_upload.dart';
import 'package:nutriscale/src/features/core/screens/profile/profile_widget.dart';
import 'package:nutriscale/src/help/common_help_dialog.dart';
import 'package:nutriscale/src/repository/auth_repository/authentication_repository.dart';
import 'package:nutriscale/src/repository/user_repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = UserRepository().getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? secondaryAppColor : appBlack,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add theme toggle logic here
            },
            icon: Icon(
              isDark ? LineAwesomeIcons.moon : LineAwesomeIcons.sun,
              color: isDark ? secondaryAppColor : appBlack,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Image with Edit Icon
            const ProfileImagePickerUpload(),

            const SizedBox(height: 25),

            // Name & Email
            FutureBuilder<UserModel>(
              future: userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('User data not found');
                }

                final user = snapshot.data!;
                return Column(
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user.eMail,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryAppColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  LineAwesomeIcons.user_edit_solid,
                  color: secondaryAppColor,
                ),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: secondaryAppColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => Get.to(() => EditProfilePage()),
              ),
            ),

            const SizedBox(height: 30),

            // Profile Widgets
            profileWidget(
              title: maintainCal,
              icon: LineAwesomeIcons.calculator_solid,
              onPress: () => Get.to(() => MaintainCal()),
            ),
            const SizedBox(height: 10),
            profileWidget(
              title: "Help",
              icon: LineAwesomeIcons.hire_a_helper,
              onPress: () {
                showCommonHelpDialog(context);

              },
            ),
            const SizedBox(height: 10),
           profileWidget(
  title: "About",
  icon: LineAwesomeIcons.info_solid,
  onPress: () {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('About'),
        content: Text(
          'NutriScale is a calorie and nutrition tracking application developed as part of a college project. Designed with both functionality and user experience in mind, NutriScale helps users track their daily calorie intake, monitor macronutrients, and maintain a balanced diet—especially focused on Indian cuisine.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    ); // <-- this was missing
  },
),

            const SizedBox(height: 10),
            profileWidget(
              title: logout,
              icon: LineAwesomeIcons.sign_out_alt_solid,
              endIcon: false,
              onPress: _logout,
              textColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    try {
      await AuthenticationRepository.instance.logout();
      Get.offAll(() => const WelcomeScreen(), transition: Transition.fadeIn);
    } catch (e) {
      Get.snackbar(
        "Logout Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
