import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nutriscale/firebase_options.dart';
import 'package:nutriscale/src/features/authentication/screens/splashscreen/splash_screen.dart';
import 'package:nutriscale/src/features/core/controllers/calorie_controller.dart';
import 'package:nutriscale/src/repository/auth_repository/authentication_repository.dart';
import 'package:nutriscale/src/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthenticationRepository()));
  await GetStorage.init();
  runApp(const NutriscaleApp());
  Get.put(CalorieController());
  
}

class NutriscaleApp extends StatelessWidget {
  const NutriscaleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
