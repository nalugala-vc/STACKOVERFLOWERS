import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final authController = Get.find<OnboardingController>();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    authController.clearError();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
      appBar: AppBar(
        backgroundColor: AppPallete.kenicWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
        title: Inter(
          text: 'Change Password',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textColor: AppPallete.kenicBlack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Inter(
              text: 'Update your password',
              fontSize: 16,
              textColor: AppPallete.greyColor,
            ),
            spaceH30,
            Obx(() {
              if (authController.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Inter(
                      text: authController.errorMessage.value,
                      fontSize: 14,
                      textColor: Colors.red,
                      textAlignment: TextAlign.center,
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
            AuthField(
              controller: authController.currentPassword,
              hintText: 'Current Password',
              isObscureText: _obscureCurrentPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrentPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppPallete.greyColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
            ),
            spaceH20,
            AuthField(
              controller: authController.newPassword,
              hintText: 'New Password',
              isObscureText: _obscureNewPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppPallete.greyColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
            ),
            spaceH20,
            AuthField(
              controller: authController.confirmNewPassword,
              hintText: 'Confirm New Password',
              isObscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppPallete.greyColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            spaceH30,
            Obx(
              () => RoundedButton(
                onPressed: () async {
                  final result = await authController.changePassword();
                  result.fold(
                    (failure) {
                      // Error is already shown through the error message observable
                    },
                    (success) {
                      Get.back();
                      Get.snackbar(
                        'Success',
                        success,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
                },
                label: 'Update Password',
                isLoading: authController.isLoading.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
