import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';
import 'package:kenic/features/onboarding/repository/onboarding_repository.dart';
import 'package:kenic/features/onboarding/models/models.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';

class PersonalInformationController extends BaseController {
  static PersonalInformationController get instance => Get.find();

  // Repository
  final OnboardingRepository _repository = OnboardingRepository();
  final OnboardingController _authController = Get.find<OnboardingController>();

  // Lazy access to DomainController to avoid dependency issues
  DomainController get _domainController => Get.find<DomainController>();

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

  Future<void> _initializeFields() async {
    // First, try to get basic user info from auth controller
    final user = _authController.currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
    }

    // Then, try to fetch complete user details from WHMCS
    await _loadWhmcsUserDetails();
  }

  Future<void> _loadWhmcsUserDetails() async {
    try {
      // Check if DomainController is available
      if (!Get.isRegistered<DomainController>()) {
        debugPrint(
          'DomainController not registered, skipping WHMCS details loading',
        );
        selectedCountry.value = 'KE';
        return;
      }

      final whmcsDetails = await _domainController.fetchWhmcsUserDetails();
      if (whmcsDetails != null) {
        // Prefill all available fields
        firstNameController.text =
            whmcsDetails.firstName.isNotEmpty
                ? whmcsDetails.firstName
                : firstNameController.text;
        lastNameController.text =
            whmcsDetails.lastName.isNotEmpty
                ? whmcsDetails.lastName
                : lastNameController.text;
        address1Controller.text = whmcsDetails.address1;
        cityController.text = whmcsDetails.city;
        stateController.text =
            whmcsDetails.state.isNotEmpty
                ? whmcsDetails.state
                : whmcsDetails.fullState;
        postcodeController.text = whmcsDetails.postcode;

        // Set country from WHMCS details, fallback to Kenya if empty
        final countryToSet =
            whmcsDetails.countryCode.isNotEmpty
                ? whmcsDetails.countryCode
                : 'KE';
        debugPrint('Setting country from WHMCS to: $countryToSet');
        selectedCountry.value = countryToSet;
        debugPrint('Country after WHMCS set: ${selectedCountry.value}');

        // Handle company name - check if user has existing company info
        // Since WHMCS details don't include company info in current model,
        // we check if any company-related fields might have data from other sources
        // For now, we keep the toggle functionality for user input
      } else {
        // Set default country to Kenya if no WHMCS details
        selectedCountry.value = 'KE';
      }
    } catch (e) {
      debugPrint('Error loading WHMCS user details: $e');
      // Set default country to Kenya if error occurs
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
    debugPrint('Setting country to: $countryCode');
    selectedCountry.value = countryCode;
    debugPrint('Country set to: ${selectedCountry.value}');
  }

  // Method to refresh form fields with latest WHMCS user details
  Future<void> refreshFormData() async {
    // Force refresh to get latest data from server
    if (Get.isRegistered<DomainController>()) {
      await _domainController.refreshWhmcsUserDetails();
    }
    await _loadWhmcsUserDetails();
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

        // Refresh WHMCS user details in DomainController to update profile completion status
        try {
          await _domainController.refreshWhmcsUserDetails();
        } catch (e) {
          debugPrint('Error refreshing WHMCS user details: $e');
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
    // Don't dispose controllers since this is a persistent singleton
    // The controllers will be disposed when the app is closed
    super.onClose();
  }
}
