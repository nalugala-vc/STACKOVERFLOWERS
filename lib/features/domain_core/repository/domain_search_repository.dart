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

  // ==================== DOMAIN SUGGESTIONS ====================
  Future<Either<AppFailure, List<DomainSuggestionResponse>>>
  getDomainSuggestions({required String searchTerm}) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url =
          '${AppConfigs.appBaseUrl}${Endpoints.domainSuggestions}?searchTerm=$searchTerm';

      debugPrint('Domain suggestions - Making GET request to: $url');
      debugPrint('Domain suggestions - Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('Domain suggestions - Status Code: ${response.statusCode}');
      debugPrint('Domain suggestions - Raw response: ${response.body}');

      if (response.statusCode != 200) {
        debugPrint(
          'Domain suggestions - Failed with status code: ${response.statusCode}',
        );
        debugPrint(
          'Domain suggestions - Response headers: ${response.headers}',
        );
        return Left(
          AppFailure(
            'Failed to get domain suggestions: ${response.statusCode} - ${response.reasonPhrase}',
          ),
        );
      }

      final dynamic responseBody = jsonDecode(response.body);
      debugPrint('Domain suggestions - Decoded response: $responseBody');
      debugPrint(
        'Domain suggestions - Response type: ${responseBody.runtimeType}',
      );

      List<dynamic> suggestionsList;

      // Handle different response formats
      if (responseBody is List) {
        // Direct array response
        suggestionsList = responseBody;
        debugPrint(
          'Domain suggestions - Found direct array with ${suggestionsList.length} items',
        );
      } else if (responseBody is Map<String, dynamic>) {
        // Check if it has suggestions field or data field
        suggestionsList =
            responseBody['suggestions'] ?? responseBody['data'] ?? [];
        debugPrint(
          'Domain suggestions - Found object response with ${suggestionsList.length} suggestions',
        );
      } else {
        debugPrint(
          'Domain suggestions - Unexpected response format: ${responseBody.runtimeType}',
        );
        return Left(AppFailure('Unexpected response format'));
      }

      debugPrint(
        'Domain suggestions - Processing ${suggestionsList.length} items',
      );

      final suggestions =
          suggestionsList
              .map((json) {
                try {
                  if (json is Map<String, dynamic>) {
                    final suggestion = DomainSuggestionResponse.fromJson(json);
                    debugPrint(
                      'Domain suggestions - Successfully parsed: ${suggestion.domainName}',
                    );
                    return suggestion;
                  } else {
                    debugPrint(
                      'Domain suggestions - Invalid item format: $json',
                    );
                    return null;
                  }
                } catch (e) {
                  debugPrint('Domain suggestions - Error parsing item: $e');
                  debugPrint('Domain suggestions - Problematic JSON: $json');
                  return null;
                }
              })
              .whereType<DomainSuggestionResponse>()
              .toList();

      debugPrint(
        'Domain suggestions - Successfully parsed ${suggestions.length} suggestions',
      );

      return Right(suggestions);
    } catch (e) {
      debugPrint('Error in getDomainSuggestions: $e');
      return Left(AppFailure(e.toString()));
    }
  }
}
