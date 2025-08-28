import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/onboarding/repository/onboarding_repository.dart';
import 'package:kenic/features/onboarding/models/models.dart';

class OnboardingController extends BaseController {
  static OnboardingController get instance => Get.find();

  // Repository
  final OnboardingRepository _repository = OnboardingRepository();

  // Controllers
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final otp = TextEditingController();

  // Observable variables
  final currentStep = 0.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();

  // Change Password Controllers
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();

  // Delete Account Controller
  final deleteAccountPassword = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  // Initialize auth state
  Future<void> initializeAuth() async {
    try {
      await _initializeUserFromStoredToken();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      // Clear any potentially corrupted data
      await _clearTokenFromPreferences();
      isLoggedIn.value = false;
      currentUser.value = null;
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    newPassword.dispose();
    currentPassword.dispose();
    confirmNewPassword.dispose();
    otp.dispose();
    super.onClose();
  }

  // ==================== CHANGE PASSWORD ====================
  Future<Either<AppFailure, String>> changePassword() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (!validateChangePasswordForm()) {
        return Left(AppFailure(errorMessage.value));
      }

      final result = await _repository.changePassword(
        currentPassword: currentPassword.text,
        newPassword: newPassword.text,
      );

      if (result.isRight()) {
        // Clear the password fields
        currentPassword.clear();
        newPassword.clear();
        confirmNewPassword.clear();
      }

      return result;
    } catch (e) {
      return Left(AppFailure('Change password error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  bool validateChangePasswordForm() {
    final currentPasswordError = validatePassword(currentPassword.text);
    final newPasswordError = validatePassword(newPassword.text);
    final confirmNewPasswordError = validateConfirmPassword(
      newPassword.text,
      confirmNewPassword.text,
    );

    if (currentPasswordError != null) {
      errorMessage.value = currentPasswordError;
      return false;
    }
    if (newPasswordError != null) {
      errorMessage.value = newPasswordError;
      return false;
    }
    if (confirmNewPasswordError != null) {
      errorMessage.value = confirmNewPasswordError;
      return false;
    }

    if (currentPassword.text == newPassword.text) {
      errorMessage.value =
          'New password must be different from current password';
      return false;
    }

    return true;
  }

  // ==================== USER REGISTRATION ====================
  Future<Either<AppFailure, User>> createUser({
    required String phoneNumber,
    required String email,
    required String password,
    required String name,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.createUser(
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        name: name,
      );
      debugPrint('phoneNumber: $phoneNumber');
      debugPrint('result: $result');

      if (result.isRight()) {
        result.fold((failure) => null, (user) {
          currentUser.value = user;
          if (user.token != null) {
            _saveTokenToPreferences(user.token!);
          }
          isLoggedIn.value = true;
        });
      }

      return result;
    } catch (e) {
      return Left(AppFailure('Unexpected error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== USER LOGIN ====================
  Future<Either<AppFailure, User>> loginUser({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.loginUser(
        email: email,
        password: password,
      );

      // If login is successful, store user data and token
      if (result.isRight()) {
        result.fold((failure) => null, (user) {
          currentUser.value = user;
          if (user.token != null) {
            _saveTokenToPreferences(user.token!);
          }
          isLoggedIn.value = true;
        });
      }

      return result;
    } catch (e) {
      return Left(AppFailure('Login error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== SEND VERIFICATION ====================
  Future<Either<AppFailure, String>> sendVerification() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.sendVerification();

      return result;
    } catch (e) {
      return Left(AppFailure('Verification error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VERIFY OTP ====================
  Future<Either<AppFailure, String>> verifyOTP({required String code}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.verifyOTP(code: code);

      if (result.isRight()) {
        return Right('OTP verified successfully');
      } else {
        return result.fold(
          (failure) => Left(failure),
          (success) => Right('OTP verified successfully'),
        );
      }
    } catch (e) {
      return Left(AppFailure('OTP verification error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VALIDATION METHODS ====================
  String? validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'(?=.*?[#?!@$%^&*-])').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (phone.length < 9) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name is required';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  String? validateOTP(String otp) {
    if (otp.isEmpty) {
      return 'OTP is required';
    }
    if (otp.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  // ==================== UTILITY METHODS ====================
  User? get user => currentUser.value;

  bool get hasUser => currentUser.value != null;

  String? get currentToken => currentUser.value?.token;

  bool get hasValidToken => currentUser.value?.token != null;

  void clearError() {
    errorMessage.value = '';
  }

  void setCurrentStep(int step) {
    currentStep.value = step;
  }

  Future<void> logout() async {
    await _clearTokenFromPreferences();
    await _clearLocalData();
    isLoggedIn.value = false;
    currentUser.value = null;
    clearError();
    Get.offAllNamed('/signin');
  }

  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all local data
  }

  Future<Either<AppFailure, String>> deleteAccount() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (deleteAccountPassword.text.isEmpty) {
        errorMessage.value = 'Password is required';
        return Left(AppFailure('Password is required'));
      }

      final result = await _repository.deleteUser(
        password: deleteAccountPassword.text,
      );

      print('result: $result');

      if (result.isRight()) {
        // Clear all local data and reset state
        await _clearLocalData();
        isLoggedIn.value = false;
        currentUser.value = null;
        deleteAccountPassword.clear();
      }

      return result;
    } catch (e) {
      return Left(AppFailure('Delete account error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FORM VALIDATION ====================
  bool validateSignUpForm() {
    final nameError = validateName(name.text);
    final emailError = validateEmail(email.text);
    final phoneError = validatePhone(phone.text);
    final passwordError = validatePassword(password.text);
    final confirmPasswordError = validateConfirmPassword(
      password.text,
      confirmPassword.text,
    );

    if (nameError != null) {
      errorMessage.value = nameError;
      return false;
    }
    if (emailError != null) {
      errorMessage.value = emailError;
      return false;
    }
    if (phoneError != null) {
      errorMessage.value = phoneError;
      return false;
    }
    if (passwordError != null) {
      errorMessage.value = passwordError;
      return false;
    }
    if (confirmPasswordError != null) {
      errorMessage.value = confirmPasswordError;
      return false;
    }

    return true;
  }

  bool validateSignInForm() {
    final emailError = validateEmail(email.text);
    final passwordError = validatePassword(password.text);

    if (emailError != null) {
      errorMessage.value = emailError;
      return false;
    }
    if (passwordError != null) {
      errorMessage.value = passwordError;
      return false;
    }

    return true;
  }

  bool validateForgotPasswordForm() {
    final emailError = validateEmail(email.text);
    if (emailError != null) {
      errorMessage.value = emailError;
      return false;
    }
    return true;
  }

  bool validateResetPasswordForm() {
    final passwordError = validatePassword(newPassword.text);
    final otpError = validateOTP(otp.text);

    if (passwordError != null) {
      errorMessage.value = passwordError;
      return false;
    }
    if (otpError != null) {
      errorMessage.value = otpError;
      return false;
    }

    return true;
  }

  // Helper method to save token and user data to shared preferences
  Future<void> _saveTokenToPreferences(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('USER_TOKEN', token);

    // Save user data if available
    if (currentUser.value != null) {
      final userJson = jsonEncode(currentUser.value!.toJson());
      await prefs.setString('USER_DATA', userJson);
    }
  }

  // Helper method to clear token and user data from shared preferences
  Future<void> _clearTokenFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('USER_TOKEN');
    await prefs.remove('USER_DATA');
  }

  // Helper method to initialize user from stored token
  Future<void> _initializeUserFromStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('USER_TOKEN');
    final storedUserJson = prefs.getString('USER_DATA');

    if (storedToken == null || storedToken.isEmpty) {
      isLoggedIn.value = false;
      currentUser.value = null;
      return;
    }

    if (storedUserJson != null) {
      try {
        final userData = jsonDecode(storedUserJson);
        final user = User.fromJson(userData);
        user.token = storedToken; // Ensure token is set
        currentUser.value = user;
        isLoggedIn.value = true;
      } catch (e) {
        debugPrint('Error parsing stored user data: $e');
        throw Exception('Invalid stored user data');
      }
    } else {
      // If we have a token but no user data, try to fetch user data from API
      // TODO: Add API endpoint to fetch user data using token
      // For now, we'll create a minimal user object with just the token
      currentUser.value = User(
        id: 0, // Placeholder ID
        name: '', // Will be updated when we add the user profile endpoint
        email: '',
        phoneNumber: '',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        token: storedToken,
      );
      isLoggedIn.value = true;
    }
  }

  // Method to check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('USER_TOKEN');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
