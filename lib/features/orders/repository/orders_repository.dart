import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/orders/models/models.dart';

class OrdersRepository {
  /// Fetch orders with optional pagination
  Future<Either<AppFailure, OrderListResponse>> getOrders({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final url =
          '${AppConfigs.appBaseUrl}${Endpoints.orders}?page=$page&per_page=$perPage';

      final headers = await AppConfigs.authorizedHeaders();

      debugPrint('Fetching orders - URL: $url');
      debugPrint('Fetching orders - Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('Get orders response status: ${response.statusCode}');
      debugPrint('Get orders response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final ordersResponse = OrderListResponse.fromJson(responseBody);
        return right(ordersResponse);
      } else {
        final message =
            responseBody['message'] as String? ??
            'Failed to fetch orders. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Get orders error: $e');
      return left(
        AppFailure(
          'An error occurred while fetching orders. Please check your internet connection and try again.',
        ),
      );
    }
  }

  /// Fetch orders by status
  Future<Either<AppFailure, OrderListResponse>> getOrdersByStatus({
    required String status,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final url =
          '${AppConfigs.appBaseUrl}${Endpoints.orders}?status=$status&page=$page&per_page=$perPage';

      final headers = await AppConfigs.authorizedHeaders();

      debugPrint('Fetching orders by status - URL: $url');
      debugPrint('Fetching orders by status - Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint(
        'Get orders by status response status: ${response.statusCode}',
      );
      debugPrint('Get orders by status response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final ordersResponse = OrderListResponse.fromJson(responseBody);
        return right(ordersResponse);
      } else {
        final message =
            responseBody['message'] as String? ??
            'Failed to fetch orders. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Get orders by status error: $e');
      return left(
        AppFailure(
          'An error occurred while fetching orders. Please check your internet connection and try again.',
        ),
      );
    }
  }
}
