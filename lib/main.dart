import 'package:flutter/material.dart';
import 'package:kenic/core/utils/theme/app_theme.dart';
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
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightMode,
      home: const VerifyEmail(),
    );
  }
}
