import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';

class CustomDialogs {
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logout.png', height: 150),
                spaceH20,
                Inter(
                  text: 'Sign Out',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  textColor: AppPallete.kenicBlack,
                ),
                spaceH10,
                Inter(
                  text: 'Are you sure you want to sign out?',
                  fontSize: 16,
                  textColor: AppPallete.greyColor,
                  textAlignment: TextAlign.center,
                ),
                spaceH30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RoundedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        label: 'Cancel',
                        fontsize: 16,
                        backgroundColor: Colors.grey[200],
                        textColor: AppPallete.kenicBlack,
                      ),
                    ),
                    spaceW10,
                    Expanded(
                      child: RoundedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.find<OnboardingController>().logout();
                        },
                        label: 'Sign Out',
                        fontsize: 16,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showDeleteAccountDialog(BuildContext context) {
    final authController = Get.find<OnboardingController>();
    bool _obscurePassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/throw_away.png', height: 150),
                    spaceH20,
                    Inter(
                      text: 'Delete Account',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      textColor: AppPallete.kenicBlack,
                    ),
                    spaceH10,
                    Inter(
                      text:
                          'This action cannot be undone. Please enter your password to confirm.',
                      fontSize: 16,
                      textColor: AppPallete.greyColor,
                      textAlignment: TextAlign.center,
                    ),
                    spaceH20,
                    Obx(() {
                      if (authController.errorMessage.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Inter(
                            text: authController.errorMessage.value,
                            fontSize: 14,
                            textColor: Colors.red,
                            textAlignment: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                    AuthField(
                      controller: authController.deleteAccountPassword,
                      hintText: 'Enter your password',
                      isObscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppPallete.greyColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    spaceH30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RoundedButton(
                            onPressed: () {
                              authController.deleteAccountPassword.clear();
                              authController.clearError();
                              Navigator.of(context).pop();
                            },
                            label: 'Cancel',
                            fontsize: 16,
                            backgroundColor: Colors.grey[200],
                            textColor: AppPallete.kenicBlack,
                          ),
                        ),
                        spaceW10,
                        Expanded(
                          child: Obx(
                            () => RoundedButton(
                              onPressed: () async {
                                final result =
                                    await authController.deleteAccount();
                                result.fold(
                                  (failure) {
                                    // Error is shown through the error message observable
                                  },
                                  (success) {
                                    Navigator.of(context).pop();
                                    Get.offAllNamed('/signup');
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
                              label: 'Delete Account',
                              backgroundColor: Colors.red,
                              fontsize: 16,
                              isLoading: authController.isLoading.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
