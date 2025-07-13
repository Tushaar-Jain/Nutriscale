import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/features/core/screens/profile/profile_widget.dart';
import 'package:nutriscale/src/help/dashboardhelp.dart';
import 'package:nutriscale/src/help/searchloghelp.dart';
import 'package:nutriscale/src/help/profilehelp.dart';

Future<void> showCommonHelpDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Help'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          profileWidget(
            title: "Dashboard",
            icon: Icons.dashboard,
            onPress: () {
              Navigator.of(context).pop(); // close dialog before navigating
              Get.to(() => DashboardHelpScreen());
            },
          ),
          profileWidget(
            title: "Search and log food",
            icon: Icons.search_rounded,
            onPress: () {
              Navigator.of(context).pop();
              Get.to(() => FoodSearchHelpScreen());
            },
          ),
          profileWidget(
            title: "Profile",
            icon: Icons.person_2,
            onPress: () {
              Navigator.of(context).pop();
              Get.to(() => ProfileHelpScreen());
            },
          ),
          profileWidget(
            title: "Contact Support",
            icon: Icons.support_agent,
            onPress: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Contact Support"),
                  content: const Text(
                      "For any help, email us at:\n\nsupport@nutriscale.com"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
