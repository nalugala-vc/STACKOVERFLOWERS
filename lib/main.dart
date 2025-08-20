import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kenic/core/di/app_bindings.dart';
import 'package:kenic/core/utils/theme/app_theme.dart';
import 'package:kenic/features/domain_core/models/cart.dart';
import 'package:kenic/features/domain_core/views/cart_checkout.dart';
import 'package:kenic/features/domain_core/views/home_dashboard.dart';
import 'package:kenic/features/onboarding/views/SignUp.dart';
import 'package:kenic/features/onboarding/views/forgot_password.dart';
import 'package:kenic/features/onboarding/views/reset_password.dart';
import 'package:kenic/features/onboarding/views/signin.dart';
import 'package:kenic/features/onboarding/views/verify_email.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightMode,
      home: const HomeDashboard(),
    );
  }
}
