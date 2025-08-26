import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kenic/core/di/app_bindings.dart';
import 'package:kenic/core/routes/app_routes.dart';
import 'package:kenic/core/utils/theme/app_theme.dart';

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
      initialRoute: '/signin',
      getPages: AppRoutes.routes,
    );
  }
}
