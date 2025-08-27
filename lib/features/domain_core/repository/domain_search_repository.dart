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
    final headers = await AppConfigs.authorizedHeaders();

    try {
      final response = await http.get(
        Uri.parse(
          '${AppConfigs.appBaseUrl}${Endpoints.domainSearch}?searchTerm=$searchTerm',
        ),
        headers: headers,
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      debugPrint('Domain search response: $resBodyMap');

      if (response.statusCode != 200) {
        final message = resBodyMap['message'] ?? 'Failed to search domains';
        return Left(AppFailure(message));
      }

      final domainSearch = DomainSearch.fromJson(resBodyMap);
      return Right(domainSearch);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== DOMAIN SUGGESTIONS ====================
  Future<Either<AppFailure, List<DomainSuggestionResponse>>>
  getDomainSuggestions({required String searchTerm}) async {
    final headers = await AppConfigs.authorizedHeaders();
    final body = jsonEncode({"searchTerm": searchTerm});

    try {
      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.domainSuggestions),
        headers: headers,
        body: body,
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      debugPrint('Domain suggestions response: $resBodyMap');

      if (response.statusCode != 200) {
        final message =
            resBodyMap['message'] ?? 'Failed to get domain suggestions';
        return Left(AppFailure(message));
      }

      final List<dynamic> suggestionsList = resBodyMap['data'] ?? [];
      final suggestions =
          suggestionsList
              .map((json) => DomainSuggestionResponse.fromJson(json))
              .toList();

      return Right(suggestions);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
