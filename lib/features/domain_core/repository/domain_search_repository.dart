import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/domain_core/models/models.dart';

class DomainSearchRepository {
  // ==================== DOMAIN SEARCH ====================
  Future<Either<AppFailure, DomainSearch>> searchDomains({
    required String searchTerm,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final response = await http.get(
        Uri.parse(
          '${AppConfigs.appBaseUrl}${Endpoints.domainSearch}?searchTerm=$searchTerm',
        ),
        headers: headers,
      );

      debugPrint('Raw response: ${response.body}');

      if (response.statusCode != 200) {
        return Left(AppFailure('Failed to search domains'));
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
      if (!resBodyMap.containsKey('domain')) {
        debugPrint('Missing required field: domain');
        return Left(AppFailure('Missing domain information in response'));
      }

      if (!resBodyMap.containsKey('suggestions')) {
        debugPrint('Missing required field: suggestions');
        return Left(AppFailure('Missing suggestions information in response'));
      }

      final domainSearch = DomainSearch.fromJson(resBodyMap);
      return Right(domainSearch);
    } catch (e) {
      debugPrint('Error in searchDomains: $e');
      return Left(AppFailure(e.toString()));
    }
  }
}
