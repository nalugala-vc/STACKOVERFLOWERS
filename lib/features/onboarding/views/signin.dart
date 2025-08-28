import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/responsive_sizes.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final controller = Get.put(OnboardingController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: ResponsiveSizes.size100,
                    width: ResponsiveSizes.size160,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  spaceH40,
                  Inter(text: 'Welcome Back', fontSize: ResponsiveSizes.size25),
                  spaceH5,
                  Inter(
                    text: 'Sign in to your account',
                    fontSize: ResponsiveSizes.size15,
                    fontWeight: FontWeight.normal,
                  ),
                  spaceH50,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Email',
                        fontSize: ResponsiveSizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.email,
                        hintText: '',
                        validator:
                            (value) => controller.validateEmail(value ?? ''),
                      ),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Password',
                        fontSize: ResponsiveSizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.password,
                        isObscureText: true,
                        hintText: '',
                        validator:
                            (value) => controller.validatePassword(value ?? ''),
                      ),
                    ],
                  ),
                  spaceH20,
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/forgot-password'),
                      child: Inter(
                        text: 'Forgot Password?',
                        fontSize: ResponsiveSizes.size14,
                        textColor: AppPallete.kenicRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  spaceH40,
                  RoundedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final result = await controller.loginUser(
                          email: controller.email.text.trim(),
                          password: controller.password.text,
                        );

                        if (result.isRight()) {
                          Get.offAllNamed('/main');
                        } else {
                          result.fold(
                            (failure) => Get.snackbar(
                              'Error',
                              failure.message,
                              snackPosition: SnackPosition.BOTTOM,
                            ),
                            (user) => null,
                          );
                        }
                      }
                    },
                    label: 'Sign In',
                    fontsize: ResponsiveSizes.size18,
                  ),
                  spaceH50,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Inter(
                        text: "Don't have an account? ",
                        fontSize: ResponsiveSizes.size14,
                        fontWeight: FontWeight.normal,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/signup'),
                        child: Inter(
                          text: 'Sign Up',
                          fontSize: ResponsiveSizes.size14,
                          textColor: AppPallete.kenicRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
