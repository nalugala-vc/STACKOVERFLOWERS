import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:kenic/core/api/config.dart';
import 'package:kenic/core/api/endpoints.dart';
import 'package:kenic/core/utils/failure/app_failure.dart';
import 'package:kenic/features/support/models/ticket_models.dart';

class TicketRepository {
  // ==================== GET TICKETS ====================
  Future<Either<AppFailure, TicketListResponse>> getTickets() async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url = '${AppConfigs.appBaseUrl}${Endpoints.tickets}';

      debugPrint('Fetching tickets - URL: $url');
      debugPrint('Fetching tickets - Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('Get tickets response status: ${response.statusCode}');
      debugPrint('Get tickets response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final ticketsResponse = TicketListResponse.fromJson(responseBody);
        return right(ticketsResponse);
      } else {
        final message =
            responseBody['message'] as String? ??
            'Failed to fetch tickets. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Get tickets error: $e');
      return left(
        AppFailure(
          'An error occurred while fetching tickets. Please check your internet connection and try again.',
        ),
      );
    }
  }

  // ==================== GET SINGLE TICKET ====================
  Future<Either<AppFailure, Ticket>> getTicket(int ticketId) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url = '${AppConfigs.appBaseUrl}${Endpoints.tickets}/$ticketId';

      debugPrint('Fetching ticket - URL: $url');
      debugPrint('Fetching ticket - Headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('Get ticket response status: ${response.statusCode}');
      debugPrint('Get ticket response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final ticket = Ticket.fromJson(responseBody);
        return right(ticket);
      } else {
        final message =
            responseBody['message'] as String? ??
            'Failed to fetch ticket. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Get ticket error: $e');
      return left(
        AppFailure(
          'An error occurred while fetching ticket. Please check your internet connection and try again.',
        ),
      );
    }
  }

  // ==================== CREATE TICKET ====================
  Future<Either<AppFailure, CreateTicketResponse>> createTicket({
    required String subject,
    required String message,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url = '${AppConfigs.appBaseUrl}${Endpoints.tickets}';
      final body = jsonEncode({'subject': subject, 'message': message});

      debugPrint('Creating ticket - URL: $url');
      debugPrint('Creating ticket - Headers: $headers');
      debugPrint('Creating ticket - Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      debugPrint('Create ticket response status: ${response.statusCode}');
      debugPrint('Create ticket response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final createTicketResponse = CreateTicketResponse.fromJson(
          responseBody,
        );
        return right(createTicketResponse);
      } else {
        final message =
            responseBody['message'] as String? ??
            'Failed to create ticket. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Create ticket error: $e');
      return left(
        AppFailure(
          'An error occurred while creating ticket. Please check your internet connection and try again.',
        ),
      );
    }
  }

  // ==================== REPLY TO TICKET ====================
  Future<Either<AppFailure, ReplyTicketResponse>> replyToTicket({
    required int ticketId,
    required String message,
  }) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url =
          '${AppConfigs.appBaseUrl}${Endpoints.tickets}/$ticketId/reply';
      final body = jsonEncode({'message': message});

      debugPrint('Replying to ticket - URL: $url');
      debugPrint('Replying to ticket - Headers: $headers');
      debugPrint('Replying to ticket - Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      debugPrint('Reply to ticket response status: ${response.statusCode}');
      debugPrint('Reply to ticket response body: ${response.body}');

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final replyTicketResponse = ReplyTicketResponse.fromJson(responseBody);
        return right(replyTicketResponse);
      } else {
        final message =
            responseBody['message'] as String? ??
            'Failed to reply to ticket. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Reply to ticket error: $e');
      return left(
        AppFailure(
          'An error occurred while replying to ticket. Please check your internet connection and try again.',
        ),
      );
    }
  }

  // ==================== CLOSE TICKET ====================
  Future<Either<AppFailure, bool>> closeTicket(int ticketId) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url =
          '${AppConfigs.appBaseUrl}${Endpoints.tickets}/$ticketId?status=Closed';

      debugPrint('Closing ticket - URL: $url');
      debugPrint('Closing ticket - Headers: $headers');

      final response = await http.put(Uri.parse(url), headers: headers);

      debugPrint('Close ticket response status: ${response.statusCode}');
      debugPrint('Close ticket response body: ${response.body}');

      if (response.statusCode == 200) {
        return right(true);
      } else {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final message =
            responseBody['message'] as String? ??
            'Failed to close ticket. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Close ticket error: $e');
      return left(
        AppFailure(
          'An error occurred while closing ticket. Please check your internet connection and try again.',
        ),
      );
    }
  }

  // ==================== DELETE TICKET ====================
  Future<Either<AppFailure, bool>> deleteTicket(int ticketId) async {
    try {
      final headers = await AppConfigs.authorizedHeaders();
      final url = '${AppConfigs.appBaseUrl}${Endpoints.tickets}/$ticketId';

      debugPrint('Deleting ticket - URL: $url');
      debugPrint('Deleting ticket - Headers: $headers');

      final response = await http.delete(Uri.parse(url), headers: headers);

      debugPrint('Delete ticket response status: ${response.statusCode}');
      debugPrint('Delete ticket response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return right(true);
      } else {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final message =
            responseBody['message'] as String? ??
            'Failed to delete ticket. Please try again.';

        return left(AppFailure(message));
      }
    } catch (e) {
      debugPrint('Delete ticket error: $e');
      return left(
        AppFailure(
          'An error occurred while deleting ticket. Please check your internet connection and try again.',
        ),
      );
    }
  }
}
