import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/constants/text_string.dart';
import 'package:nutriscale/src/repository/user_repository/user_repository.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController =
      TextEditingController(); // You can add password update logic later

  String? originalFullName;
  String? originalEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final user = await UserRepository.instance.getUserDetails();
      setState(() {
        fullNameController.text = user.fullName;
        emailController.text = user.eMail;
        originalFullName = user.fullName;
        originalEmail = user.eMail;
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data");
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newFullName = fullNameController.text.trim();
    final newEmail = emailController.text.trim();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    if (newFullName == originalFullName && newEmail == originalEmail) {
      Get.snackbar("Info", "No changes to save");
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.uid);
      Map<String, dynamic> updateData = {};

      if (newFullName != originalFullName) {
        updateData["Fullname"] = newFullName;
      }

      if (newEmail != originalEmail) {
        // Update Firebase Auth email
        await currentUser.updateEmail(newEmail);
        updateData["Email"] = newEmail;
      }

      if (updateData.isNotEmpty) {
        await docRef.update(updateData);
      }

      originalFullName = newFullName;
      originalEmail = newEmail;

      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'requires-recent-login') {
        Get.snackbar(
          "Authentication Required",
          "Please log out and log back in before changing your email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Auth Error",
          authError.message ?? "Failed to update email",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_circle_left_solid),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
            const SizedBox(height: 30),

            Form(
              child: Column(
                children: [
                  _buildTextField(
                    label: userName,
                    icon: LineAwesomeIcons.user,
                    controller: fullNameController,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: hintEmail,
                    icon: LineAwesomeIcons.envelope,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),

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
                        LineAwesomeIcons.save,
                        color: secondaryAppColor,
                      ),
                      label: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: secondaryAppColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: _saveChanges,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: primaryAppColor),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
        labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.black26,
          ),
        ),
      ),
    );
  }
}
