import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final controller = Get.put(OnboardingController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
      ),
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
                  Inter(text: 'Reset Password', fontSize: 25),
                  spaceH5,
                  Inter(
                    text: 'Enter your new password',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  spaceH50,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'New Password',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.newPassword,
                        isObscureText: true,
                        hintText: '',
                      ),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Confirm Password',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.confirmPassword,
                        isObscureText: true,
                        hintText: '',
                      ),
                    ],
                  ),
                  spaceH40,
                  RoundedButton(
                    onPressed: () {
                      // Reset password
                      Get.offAllNamed('/signin');
                    },
                    label: 'Reset Password',
                    fontsize: 18,
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
