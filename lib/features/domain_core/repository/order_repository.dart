import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/domain_core/models/order.dart';
import 'package:kenic/features/domain_core/models/payment.dart';

class OrderRepository {
  Future<Either<AppFailure, OrderResponse>> createOrder() async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url = '${AppConfigs.appBaseUrl}${Endpoints.orders}';

      debugPrint('Creating order - Making POST request to: $url');
      debugPrint('Creating order - Headers: $headers');

      final response = await http.post(Uri.parse(url), headers: headers);

      debugPrint(
        'Creating order - Response status code: ${response.statusCode}',
      );
      debugPrint('Creating order - Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(OrderResponse.fromJson(responseBody));
      }

      return Left(AppFailure('Failed to create order'));
    } catch (e) {
      debugPrint('Error creating order: $e');
      return Left(AppFailure('Error creating order: $e'));
    }
  }

  Future<Either<AppFailure, PaymentResponse>> payOrder({
    required int orderId,
    required PaymentMethod paymentMethod,
    String? phoneNumber,
    CardPaymentDetails? cardDetails,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      var url =
          '${AppConfigs.appBaseUrl}${Endpoints.orders}/$orderId/pay?payment_method=${paymentMethod.value}';

      if (paymentMethod == PaymentMethod.mpesa) {
        if (phoneNumber == null || phoneNumber.isEmpty) {
          return Left(
            AppFailure('Phone number is required for M-Pesa payments'),
          );
        }
        url = '$url&phone_number=$phoneNumber';
      }

      debugPrint('Paying order - Making POST request to: $url');
      debugPrint('Paying order - Headers: $headers');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body:
            paymentMethod == PaymentMethod.card
                ? jsonEncode(cardDetails?.toJson())
                : null,
      );

      debugPrint('Paying order - Response status code: ${response.statusCode}');
      debugPrint('Paying order - Response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('Payment response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final paymentResponse = PaymentResponse.fromJson(responseBody);

        // For card payments, if we have a payment URL, return it
        if (paymentMethod == PaymentMethod.card &&
            paymentResponse.data?.paymentUrl != null) {
          return Right(paymentResponse);
        }

        return Right(paymentResponse);
      }

      final message =
          responseBody['message'] as String? ??
          'Failed to process payment. Please try again.';

      return Left(AppFailure(message));
    } catch (e) {
      debugPrint('Error paying order: $e');
      return Left(AppFailure('Error paying order: $e'));
    }
  }

  Future<Either<AppFailure, PaymentResponse>> queryPayment({
    required String paymentReference,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url =
          '${AppConfigs.appBaseUrl}${Endpoints.payments}/query?payment_reference=$paymentReference';

      debugPrint('Querying payment - Making GET request to: $url');
      debugPrint('Querying payment - Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint(
        'Querying payment - Response status code: ${response.statusCode}',
      );
      debugPrint('Querying payment - Response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('Payment query response body: $responseBody');

      if (response.statusCode == 200) {
        return Right(PaymentResponse.fromJson(responseBody));
      }

      final message =
          responseBody['message'] as String? ??
          'Failed to query payment status. Please try again.';

      return Left(AppFailure(message));
    } catch (e) {
      debugPrint('Error querying payment: $e');
      return Left(AppFailure('Error querying payment: $e'));
    }
  }
}
