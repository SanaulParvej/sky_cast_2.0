import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/modern_home_screen.dart';
import 'core/routes/app_routes.dart';
import 'constants/app_constants.dart';

class SkyCastApp extends StatelessWidget {
  const SkyCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyCast Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: AppConstants.primaryColor,
          secondary: AppConstants.secondaryColor,
          surface: AppConstants.surfaceColor,
          background: AppConstants.backgroundColor,
          error: AppConstants.errorColor,
        ),
        scaffoldBackgroundColor: AppConstants.backgroundColor,
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AppRoutes.home, page: () => const ModernHomeScreen()),
      ],
    );
  }
}
