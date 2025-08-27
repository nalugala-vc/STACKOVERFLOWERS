import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/domain_core/models/models.dart';

class CartRepository {
  // ==================== ADD TO CART ====================
  Future<Either<AppFailure, bool>> addToCart({
    required String domainName,
    required double price,
    int registrationYears = 1,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final body = jsonEncode({
        'domain_name': domainName,
        'price': price,
        'number_of_years': registrationYears,
      });

      debugPrint(
        'Cart - Adding to cart: $domainName with price: $price for $registrationYears year(s)',
      );
      debugPrint('Cart - Request body: $body');

      final response = await http.post(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.cart),
        headers: headers,
        body: body,
      );

      debugPrint('Cart - Status Code: ${response.statusCode}');
      debugPrint('Cart - Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Cart - Response body: $responseBody');

        if (responseBody is Map<String, dynamic>) {
          final success = responseBody['success'] as bool? ?? false;
          final message =
              responseBody['message'] as String? ?? 'Unknown response';

          if (success) {
            debugPrint('Cart - Successfully added to cart: $message');
            return const Right(true);
          } else {
            debugPrint('Cart - API returned success: false');
            return Left(AppFailure(message));
          }
        } else {
          debugPrint('Cart - Unexpected response format');
          return Left(AppFailure('Unexpected response format'));
        }
      } else {
        debugPrint('Cart - Failed to add to cart: ${response.statusCode}');
        return Left(
          AppFailure('Failed to add to cart: ${response.statusCode}'),
        );
      }
    } catch (e) {
      debugPrint('Cart - Error adding to cart: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== GET CART ====================
  Future<Either<AppFailure, Map<String, dynamic>>> getCart() async {
    try {
      final headers = await AppConfigs.authorizedHeaders();

      final response = await http.get(
        Uri.parse(AppConfigs.appBaseUrl + Endpoints.cart),
        headers: headers,
      );

      debugPrint('Cart - Get cart status: ${response.statusCode}');
      debugPrint('Cart - Get cart response: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Cart - Parsing response body: $responseBody');

        if (responseBody is Map<String, dynamic>) {
          final success = responseBody['success'] as bool? ?? false;

          if (success) {
            final data = responseBody['data'] as Map<String, dynamic>?;
            if (data != null && data.containsKey('cart')) {
              final cart = data['cart'] as Map<String, dynamic>?;
              if (cart != null) {
                debugPrint('Cart - Found cart with ID: ${cart['id']}');
                return Right(cart);
              }
            }
          }

          debugPrint('Cart - No cart found in response structure');
          return Left(AppFailure('No cart found'));
        } else {
          debugPrint(
            'Cart - Unexpected response format: ${responseBody.runtimeType}',
          );
          return Left(AppFailure('Unexpected response format'));
        }
      } else {
        return Left(AppFailure('Failed to get cart: ${response.statusCode}'));
      }
    } catch (e) {
      debugPrint('Cart - Error getting cart: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== REMOVE FROM CART ====================
  Future<Either<AppFailure, bool>> removeFromCart(int itemId) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();

      final response = await http.delete(
        Uri.parse('${AppConfigs.appBaseUrl}${Endpoints.cart}/items/$itemId'),
        headers: headers,
      );

      debugPrint(
        'Cart - Remove item $itemId from cart status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Cart - Successfully removed item $itemId from cart');
        return const Right(true);
      } else {
        debugPrint(
          'Cart - Failed to remove item $itemId from cart: ${response.statusCode}',
        );
        return Left(
          AppFailure('Failed to remove item from cart: ${response.statusCode}'),
        );
      }
    } catch (e) {
      debugPrint('Cart - Error removing item $itemId from cart: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  // ==================== CLEAR CART ====================
  Future<Either<AppFailure, bool>> clearCart(int cartId) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();

      final response = await http.delete(
        Uri.parse('${AppConfigs.appBaseUrl}${Endpoints.cart}/$cartId'),
        headers: headers,
      );

      debugPrint('Cart - Clear cart $cartId status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Cart - Successfully cleared cart $cartId');
        return const Right(true);
      } else {
        debugPrint(
          'Cart - Failed to clear cart $cartId: ${response.statusCode}',
        );
        return Left(AppFailure('Failed to clear cart: ${response.statusCode}'));
      }
    } catch (e) {
      debugPrint('Cart - Error clearing cart $cartId: $e');
      return Left(AppFailure(e.toString()));
    }
  }
}
