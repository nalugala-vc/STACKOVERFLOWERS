import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/signin_controller.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final controller = Get.put(SignInController());
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
                    height: 100,
                    width: 160,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  spaceH40,
                  Inter(text: 'Welcome Back', fontSize: 25),
                  spaceH5,
                  Inter(
                    text: 'Sign in to your account',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  spaceH50,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Email',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(controller: controller.email, hintText: ''),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Password',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.password,
                        isObscureText: true,
                        hintText: '',
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
                        fontSize: 14,
                        textColor: AppPallete.kenicRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  spaceH40,
                  RoundedButton(
                    onPressed: () {},
                    label: 'Sign In',
                    fontsize: 18,
                  ),
                  spaceH50,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Inter(
                        text: "Don't have an account? ",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/signup'),
                        child: Inter(
                          text: 'Sign Up',
                          fontSize: 14,
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
