import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/features/authentication/screens/welcomescreen/welcome_screen.dart';
import 'package:nutriscale/src/features/core/controllers/bottom_nav_controller.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/dashboard.dart';
import 'package:nutriscale/src/features/core/screens/profile/profile.dart';
import 'package:nutriscale/src/features/core/screens/search/search_screen.dart';
import 'package:nutriscale/src/repository/auth_repository/authentication_repository.dart';
import 'package:sidebarx/sidebarx.dart';

class HybridLayoutScreen extends StatefulWidget {
  const HybridLayoutScreen({super.key});

  @override
  State<HybridLayoutScreen> createState() => _HybridLayoutScreenState();
}

class _HybridLayoutScreenState extends State<HybridLayoutScreen> {
  final sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );
  final bottomNavController = Get.put(BottomNavController());

  final pages = [
    Dashboard(), 
    FoodSearchScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    sidebarController.addListener(_handleSidebarTap);
  }

  void _handleSidebarTap() {
    final index = sidebarController.selectedIndex;
    switch (index) {
      case 0:
        Get.to(() => const ProfileScreen());
        break;
      case 1:
        Get.snackbar(
          "Settings",
          "Settings clicked",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 2:
        _logout();
        break;
    }

    // Optionally reset the sidebar to avoid re-triggering
    // sidebarController.setIndex(-1);
  }

  @override
  void dispose() {
    sidebarController.removeListener(_handleSidebarTap);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var colorDynamic = isDarkMode ? secondaryAppColor : appBlack;
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            // SidebarX(
            //   controller: sidebarController,
            //   theme: SidebarXTheme(
            //     decoration: BoxDecoration(color: Colors.blueGrey.shade900),
            //     selectedTextStyle: const TextStyle(color: Colors.white),
            //     selectedItemDecoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     textStyle: const TextStyle(color: Colors.white70),
            //     iconTheme: const IconThemeData(color: Colors.white70),
            //     selectedIconTheme: const IconThemeData(color: Colors.white),
            //   ),
            //   extendedTheme: const SidebarXTheme(width: 200),
            //   items: const [
            //     SidebarXItem(icon: Icons.person, label: 'Profile'),
            //     SidebarXItem(icon: Icons.settings, label: 'Settings'),
            //     SidebarXItem(icon: Icons.logout, label: 'Logout'),
            //   ],
            // ),
            Expanded(
              child: Obx(() => pages[bottomNavController.selectedIndex.value]),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: isDarkMode ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Obx(
            () => GNav(
              selectedIndex: bottomNavController.selectedIndex.value,
              onTabChange: bottomNavController.changeTab,
              gap: 8,
              padding: const EdgeInsets.all(16),
              activeColor: Colors.white,
              color: Colors.black,
              tabBackgroundColor: primaryAppColor,
              tabs: [
                GButton(
                  icon: Icons.dashboard,
                  iconColor: primaryAppColor,
                  iconActiveColor:colorDynamic,
                  text: "Home",
                  textColor:colorDynamic,
                ),
                GButton(
                  icon: Icons.search,
                  iconColor: primaryAppColor,
                  iconActiveColor: colorDynamic,
                  text: 'Search',
                  textColor: colorDynamic,
                ),
                GButton(
                  icon: Icons.man,
                  iconActiveColor: colorDynamic,
                  iconColor: primaryAppColor,
                  text: 'About',
                  textColor: colorDynamic,
                ),
              ],
            ),
          ),
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
