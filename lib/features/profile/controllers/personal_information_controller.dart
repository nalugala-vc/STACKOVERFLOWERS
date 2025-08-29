import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';
import 'package:kenic/features/onboarding/repository/onboarding_repository.dart';
import 'package:kenic/features/onboarding/models/models.dart';

class PersonalInformationController extends BaseController {
  static PersonalInformationController get instance => Get.find();

  // Repository
  final OnboardingRepository _repository = OnboardingRepository();
  final OnboardingController _authController = Get.find<OnboardingController>();

  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final companyNameController = TextEditingController();
  final postcodeController = TextEditingController();

  // Observable variables
  final selectedCountry = Rxn<String>();
  final isCompanyNameVisible = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFields();
  }

  void _initializeFields() {
    final user = _authController.currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      // Set default country to Kenya
      selectedCountry.value = 'KE';
    }
  }

  void toggleCompanyName() {
    isCompanyNameVisible.value = !isCompanyNameVisible.value;
    if (!isCompanyNameVisible.value) {
      companyNameController.clear();
    }
  }

  void setCountry(String? countryCode) {
    selectedCountry.value = countryCode;
  }

  bool validateForm() {
    errorMessage.value = '';

    if (firstNameController.text.trim().isEmpty) {
      errorMessage.value = 'First name is required';
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      errorMessage.value = 'Last name is required';
      return false;
    }

    if (address1Controller.text.trim().isEmpty) {
      errorMessage.value = 'Address is required';
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      errorMessage.value = 'City is required';
      return false;
    }

    if (stateController.text.trim().isEmpty) {
      errorMessage.value = 'State is required';
      return false;
    }

    if (postcodeController.text.trim().isEmpty) {
      errorMessage.value = 'Postal code is required';
      return false;
    }

    if (selectedCountry.value == null || selectedCountry.value!.isEmpty) {
      errorMessage.value = 'Please select a country';
      return false;
    }

    return true;
  }

  Future<Either<AppFailure, String>> updateUserDetails() async {
    if (!validateForm()) {
      return Left(AppFailure(errorMessage.value));
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      debugPrint('Updating user details...');

      final userDetails = UserDetails(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        address1: address1Controller.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        companyName:
            isCompanyNameVisible.value
                ? companyNameController.text.trim()
                : null,
        postcode: postcodeController.text.trim(),
        country: selectedCountry.value!,
      );

      debugPrint('User details to update: ${userDetails.toJson()}');

      final result = await _repository.updateUserDetails(
        userDetails: userDetails,
      );

      debugPrint('Update result: $result');

      if (result.isRight()) {
        // Update the user in the auth controller
        final currentUser = _authController.currentUser.value;
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            firstName: userDetails.firstName,
            lastName: userDetails.lastName,
          );
          _authController.currentUser.value = updatedUser;
        }
      }

      return result;
    } catch (e) {
      debugPrint('Error updating user details: $e');
      return Left(AppFailure('An unexpected error occurred: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    address1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    companyNameController.dispose();
    postcodeController.dispose();
    super.onClose();
  }
}
