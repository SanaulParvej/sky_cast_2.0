import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_cast/home_screen.dart';

import 'app_routes.dart';

class SkyCastApp extends StatelessWidget {
  const SkyCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyCast Weather',
      initialRoute: AppRoutes.home,
      getPages: [GetPage(name: AppRoutes.home, page: () => const HomeScreen())],
    );
  }
}
