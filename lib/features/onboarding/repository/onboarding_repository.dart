import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/onboarding/models/models.dart';

class OnboardingRepository {
  // ==================== USER REGISTRATION ====================
  Future<Either<AppFailure, User>> createUser({
    required String phoneNumber,
    required String email,
    required String password,
    required String name,
  }) async {
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

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      debugPrint('resBodyMap: $resBodyMap');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Something went wrong';
        return Left(AppFailure(message));
      }

      final token = resBodyMap['token'] as String;
      final userInfo = resBodyMap['data'] as Map<String, dynamic>;

      final user = User(
        id: userInfo['id'] as int,
        name: userInfo['name'] as String,
        email: userInfo['email'] as String,
        phoneNumber: userInfo['phone_number'] as String,
        emailVerifiedAt: userInfo['email_verified_at'] as String?,
        createdAt: userInfo['created_at'] as String,
        updatedAt: userInfo['updated_at'] as String,
        token: token,
      );

      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== USER LOGIN ====================
  Future<Either<AppFailure, User>> loginUser({
    required String email,
    required String password,
  }) async {
    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.login),
        headers: headers,
        body: body,
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Login failed';
        return Left(AppFailure(message));
      }

      final token = resBodyMap['token'] as String;
      final userInfo = resBodyMap['data'] as Map<String, dynamic>;

      final user = User(
        id: userInfo['id'] as int,
        name: userInfo['name'] as String,
        email: userInfo['email'] as String,
        phoneNumber: userInfo['phone_number'] as String,
        emailVerifiedAt: userInfo['email_verified_at'] as String?,
        createdAt: userInfo['created_at'] as String,
        updatedAt: userInfo['updated_at'] as String,
        token: token,
      );

      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== SEND VERIFICATION ====================
  Future<Either<AppFailure, String>> sendVerification() async {
    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({"type": "sms"});

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.sendOTP),
        headers: headers,
        body: body,
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = resBodyMap['message'] ?? 'Failed to send verification';
        return Left(AppFailure(message));
      }

      return Right(
        resBodyMap['message'] ?? 'Verification code sent successfully',
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== VERIFY OTP ====================
  Future<Either<AppFailure, bool>> verifyOTP({
    required String OTPCode,
    required String email,
  }) async {
    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({"email": email, "otpCode": OTPCode});

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.verifyOtp),
        headers: headers,
        body: body,
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        final message = resBodyMap['message'] ?? 'Something went wrong';
        return Left(AppFailure(message));
      }

      return Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
