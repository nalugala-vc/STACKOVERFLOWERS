import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/widgets/custom_dialogs.dart';
import 'package:kenic/features/support/models/ticket_models.dart';
import 'package:kenic/features/support/repository/ticket_repository.dart';

class TicketController extends GetxController {
  final TicketRepository _repository = TicketRepository();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isCreatingTicket = false.obs;
  final RxBool isReplying = false.obs;
  final RxList<Ticket> tickets = <Ticket>[].obs;
  final Rx<Ticket?> selectedTicket = Rx<Ticket?>(null);
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  // ==================== FETCH TICKETS ====================
  Future<void> fetchTickets() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.getTickets();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          tickets.clear();
        },
        (response) {
          tickets.value = response.tickets;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      tickets.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CREATE TICKET ====================
  Future<bool> createTicket({
    required String subject,
    required String message,
  }) async {
    isCreatingTicket.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.createTicket(
        subject: subject,
        message: message,
      );

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          showErrorDialog(failure.message);
          return false;
        },
        (response) {
          showSuccessDialog('Ticket created successfully!');
          fetchTickets(); // Refresh the list
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      showErrorDialog('An unexpected error occurred');
      return false;
    } finally {
      isCreatingTicket.value = false;
    }
  }

  // ==================== GET SINGLE TICKET ====================
  Future<Ticket?> getTicket(int ticketId) async {
    try {
      final result = await _repository.getTicket(ticketId);

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          showErrorDialog(failure.message);
          return null;
        },
        (ticket) {
          selectedTicket.value = ticket;
          debugPrint(
            'Ticket refreshed: ${ticket.tid}, Status: ${ticket.status}, Replies: ${ticket.replies?.length ?? 0}',
          );
          return ticket;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      showErrorDialog('An unexpected error occurred');
      return null;
    }
  }

  // ==================== REPLY TO TICKET ====================
  Future<bool> replyToTicket({
    required int ticketId,
    required String message,
  }) async {
    isReplying.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.replyToTicket(
        ticketId: ticketId,
        message: message,
      );

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          showErrorDialog(failure.message);
          return false;
        },
        (response) {
          showSuccessDialog('Reply sent successfully!');

          // Refresh both the selected ticket and the tickets list
          getTicket(ticketId);
          refreshTickets();
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      showErrorDialog('An unexpected error occurred');
      return false;
    } finally {
      isReplying.value = false;
    }
  }

  // ==================== CLOSE TICKET ====================
  Future<bool> closeTicket(int ticketId) async {
    try {
      final result = await _repository.closeTicket(ticketId);

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          showErrorDialog(failure.message);
          return false;
        },
        (success) {
          showSuccessDialog('Ticket closed successfully!');
          fetchTickets(); // Refresh the list
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      showErrorDialog('An unexpected error occurred');
      return false;
    }
  }

  // ==================== DELETE TICKET ====================
  Future<bool> deleteTicket(int ticketId) async {
    try {
      final result = await _repository.deleteTicket(ticketId);

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          showErrorDialog(failure.message);
          return false;
        },
        (success) {
          showSuccessDialog('Ticket deleted successfully!');
          fetchTickets(); // Refresh the list
          return true;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      showErrorDialog('An unexpected error occurred');
      return false;
    }
  }

  // ==================== REFRESH TICKETS ====================
  Future<void> refreshTickets() async {
    await fetchTickets();
  }

  // ==================== GET TICKETS BY STATUS ====================
  List<Ticket> getTicketsByStatus(String status) {
    return tickets
        .where((ticket) => ticket.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // ==================== GET OPEN TICKETS ====================
  List<Ticket> get openTickets => getTicketsByStatus('Open');

  // ==================== GET CLOSED TICKETS ====================
  List<Ticket> get closedTickets => getTicketsByStatus('Closed');

  // ==================== GET CUSTOMER REPLY TICKETS ====================
  List<Ticket> get customerReplyTickets => getTicketsByStatus('Customer-Reply');

  // ==================== CLEAR SELECTED TICKET ====================
  void clearSelectedTicket() {
    selectedTicket.value = null;
  }

  // ==================== SHOW SUCCESS DIALOG ====================
  void showSuccessDialog(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // ==================== SHOW ERROR DIALOG ====================
  void showErrorDialog(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }
}
