import 'package:flutter/material.dart';

class ProfileHelpScreen extends StatelessWidget {
  const ProfileHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("How to Use Profile Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '''
👤 **Profile Screen Guide**

Here's how you can use the Profile screen in the NutriScale app:

📷 **Profile Picture**
- Tap on the profile image to update your picture.
- Choose from camera or gallery.

📝 **User Information**
- See your full name and registered email.
- Make sure these are accurate for personalized results.

✏️ **Edit Profile**
- Click **Edit Profile** to change your name, or email.
- Updating your profile helps improve calorie and nutrition calculations.

🧮 **Maintenance Calorie Calculator**
- Tap **Maintenance Cal** to calculate your daily calorie needs based on your profile.
- Useful if your fitness goal changes.


ℹ️ **About**
- Learn more about the app, its mission, and the team behind it.

🚪 **Logout**
- Tap **Logout** to sign out of your account securely.
- You can always log back in later.


🔐 **Tip**
Always keep your profile updated to ensure you get accurate nutrition and health tracking!
            ''',
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}
