import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kenic/core/di/app_bindings.dart';
import 'package:kenic/core/routes/app_routes.dart';
import 'package:kenic/core/utils/theme/app_theme.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferences.getInstance());

  // Initialize auth controller early
  final authController = Get.put(OnboardingController());
  await authController.initializeAuth();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<OnboardingController>();

    return Obx(
      () => GetMaterialApp(
        initialBinding: AppBindings(),
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightMode,
        initialRoute: authController.isLoggedIn.value ? '/home' : '/signin',
        getPages: AppRoutes.routes,
      ),
    );
  }
}
