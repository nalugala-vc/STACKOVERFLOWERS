import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/domain_core/models/user_domain.dart';

class UserDomainsRepository {
  // ==================== USER DOMAINS ====================
  Future<Either<AppFailure, UserDomainsResponse>> getUserDomains() async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final response = await http.get(
        Uri.parse('${AppConfigs.appBaseUrl}${Endpoints.userDomains}'),
        headers: headers,
      );

      debugPrint('Raw response: ${response.body}');

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to fetch user domains'));
      }

      final dynamic responseBody = jsonDecode(response.body);
      debugPrint('Decoded response: $responseBody');
      debugPrint('Response type: ${responseBody.runtimeType}');

      if (responseBody is! Map<String, dynamic>) {
        debugPrint(
          'Expected Map<String, dynamic> but got ${responseBody.runtimeType}',
        );
        return Left(AppFailure('Invalid response format'));
      }

      final Map<String, dynamic> resBodyMap = responseBody;

      // Validate required fields
      if (!resBodyMap.containsKey('result')) {
        debugPrint('Missing required field: result');
        return Left(AppFailure('Missing result information in response'));
      }

      if (!resBodyMap.containsKey('domains')) {
        debugPrint('Missing required field: domains');
        return Left(AppFailure('Missing domains information in response'));
      }

      final userDomainsResponse = UserDomainsResponse.fromJson(resBodyMap);
      return Right(userDomainsResponse);
    } catch (e) {
      debugPrint('Error in getUserDomains: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== DOMAIN NAMESERVERS ====================
  Future<Either<AppFailure, NameserversResponse>> getDomainNameservers({
    required int domainId,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final response = await http.get(
        Uri.parse(
          '${AppConfigs.appBaseUrl}${Endpoints.domainNameservers}?domainid=$domainId',
        ),
        headers: headers,
      );

      debugPrint('Nameservers response: ${response.body}');

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to fetch domain nameservers'));
      }

      final dynamic responseBody = jsonDecode(response.body);

      if (responseBody is! Map<String, dynamic>) {
        return Left(AppFailure('Invalid nameservers response format'));
      }

      final nameserversResponse = NameserversResponse.fromJson(responseBody);
      return Right(nameserversResponse);
    } catch (e) {
      debugPrint('Error in getDomainNameservers: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== DOMAIN EPP CODE ====================
  Future<Either<AppFailure, EppCodeResponse>> getDomainEppCode({
    required int domainId,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final response = await http.get(
        Uri.parse(
          '${AppConfigs.appBaseUrl}${Endpoints.domainEppCode}?domainid=$domainId',
        ),
        headers: headers,
      );

      debugPrint('EPP code response: ${response.body}');

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to fetch domain EPP code'));
      }

      final dynamic responseBody = jsonDecode(response.body);

      if (responseBody is! Map<String, dynamic>) {
        return Left(AppFailure('Invalid EPP code response format'));
      }

      final eppCodeResponse = EppCodeResponse.fromJson(responseBody);
      return Right(eppCodeResponse);
    } catch (e) {
      debugPrint('Error in getDomainEppCode: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== UPDATE DOMAIN NAMESERVERS ====================
  Future<Either<AppFailure, NameserversResponse>> updateDomainNameservers({
    required NameserverUpdateRequest request,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final response = await http.post(
        Uri.parse('${AppConfigs.appBaseUrl}${Endpoints.domainNameservers}'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      debugPrint('Update nameservers response: ${response.body}');

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to update domain nameservers'));
      }

      final dynamic responseBody = jsonDecode(response.body);

      if (responseBody is! Map<String, dynamic>) {
        return Left(AppFailure('Invalid update nameservers response format'));
      }

      final nameserversResponse = NameserversResponse.fromJson(responseBody);
      return Right(nameserversResponse);
    } catch (e) {
      debugPrint('Error in updateDomainNameservers: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== WHMCS USER DETAILS ====================
  Future<Either<AppFailure, WhmcsUserDetails>> getWhmcsUserDetails() async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final response = await http.get(
        Uri.parse('${AppConfigs.appBaseUrl}${Endpoints.userWhmcsDetails}'),
        headers: headers,
      );

      debugPrint('WHMCS user details response: ${response.body}');

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to fetch user details'));
      }

      final dynamic responseBody = jsonDecode(response.body);

      if (responseBody is! Map<String, dynamic>) {
        return Left(AppFailure('Invalid user details response format'));
      }

      // Extract the 'data' field from the response
      final dataField = responseBody['data'] as Map<String, dynamic>?;
      if (dataField == null) {
        return Left(AppFailure('No data field in user details response'));
      }

      final userDetails = WhmcsUserDetails.fromJson(dataField);
      return Right(userDetails);
    } catch (e) {
      debugPrint('Error in getWhmcsUserDetails: $e');
      return Left(AppFailure(e.toString()));
    }
  }
}
