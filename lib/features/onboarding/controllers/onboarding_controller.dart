import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';

class OnboardingController extends BaseController {
  static OnboardingController get instance => Get.find();

  // Controllers
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final newPassword = TextEditingController();
  final otp = TextEditingController();

  // Observable variables
  final currentStep = 0.obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    newPassword.dispose();
    otp.dispose();
    super.onClose();
  }

  // ==================== USER REGISTRATION ====================
  Future<Either<AppFailure, String>> createUser({
    required String phoneNumber,
    required String email,
    required String password,
    required String name,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({
      "email": email,
      "name": name,
      "phone_number": phoneNumber,
      "password": password,
    });

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.register),
        headers: headers,
        body: body,
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.body.isEmpty) {
        return Left(AppFailure('Empty response from server'));
      }

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Something went wrong';
        return Left(AppFailure(message));
      }

      return Right(resBodyMap['message'] ?? 'Account created successfully');
    } catch (e) {
      return Left(AppFailure('Unexpected error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== USER LOGIN ====================
  Future<Either<AppFailure, String>> loginUser({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.login),
        headers: headers,
        body: body,
      );

      debugPrint('Login Status code: ${response.statusCode}');
      debugPrint('Login Response body: ${response.body}');

      if (response.body.isEmpty) {
        return Left(AppFailure('Empty response from server'));
      }

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Login failed';
        return Left(AppFailure(message));
      }

      // Store user data and token
      final token = resBodyMap['token'] ?? resBodyMap['access_token'];
      if (token != null) {
        // Store token in secure storage
        await _storeUserToken(token);
        isLoggedIn.value = true;
      }

      return Right(resBodyMap['message'] ?? 'Login successful');
    } catch (e) {
      return Left(AppFailure('Login error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== SEND VERIFICATION ====================
  Future<Either<AppFailure, String>> sendVerification({
    required String email,
    String? phoneNumber,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({
      "email": email,
      if (phoneNumber != null) "phone_number": phoneNumber,
    });

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.verifyEmail),
        headers: headers,
        body: body,
      );

      debugPrint('Verification Status code: ${response.statusCode}');
      debugPrint('Verification Response body: ${response.body}');

      if (response.body.isEmpty) {
        return Left(AppFailure('Empty response from server'));
      }

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Failed to send verification';
        return Left(AppFailure(message));
      }

      return Right(
        resBodyMap['message'] ?? 'Verification code sent successfully',
      );
    } catch (e) {
      return Left(AppFailure('Verification error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VERIFY OTP ====================
  Future<Either<AppFailure, String>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({"email": email, "otp": otp});

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.verifyOtp),
        headers: headers,
        body: body,
      );

      debugPrint('OTP Verification Status code: ${response.statusCode}');
      debugPrint('OTP Verification Response body: ${response.body}');

      if (response.body.isEmpty) {
        return Left(AppFailure('Empty response from server'));
      }

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'OTP verification failed';
        return Left(AppFailure(message));
      }

      return Right(resBodyMap['message'] ?? 'OTP verified successfully');
    } catch (e) {
      return Left(AppFailure('OTP verification error: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== RESET PASSWORD ====================
  Future<Either<AppFailure, String>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({
      "email": email,
      "new_password": newPassword,
      "otp": otp,
    });

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.resetPassword),
        headers: headers,
        body: body,
      );

      debugPrint('Reset Password Status code: ${response.statusCode}');
      debugPrint('Reset Password Response body: ${response.body}');

      if (response.body.isEmpty) {
        return Left(AppFailure('Empty response from server'));
      }

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Password reset failed';
        return Left(AppFailure(message));
      }

      return Right(resBodyMap['message'] ?? 'Password reset successfully');
    } catch (e) {
      return Left(AppFailure('Password reset error: ${e.toString()}'));
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
    if (phone.length < 10) {
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
  Future<void> _storeUserToken(String token) async {
    // TODO: Implement secure token storage
    // This should use secure storage like flutter_secure_storage
    debugPrint('Storing user token: $token');
  }

  void clearError() {
    errorMessage.value = '';
  }

  void setCurrentStep(int step) {
    currentStep.value = step;
  }

  void logout() {
    isLoggedIn.value = false;
    // TODO: Clear stored token and user data
    clearError();
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
}
