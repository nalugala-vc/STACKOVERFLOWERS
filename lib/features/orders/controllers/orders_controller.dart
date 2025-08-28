import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/features/orders/models/models.dart';
import 'package:kenic/features/orders/repository/orders_repository.dart';

class OrdersController extends BaseController {
  static OrdersController get instance => Get.find();

  // Repository
  final OrdersRepository _ordersRepository = OrdersRepository();

  // Observable state
  final RxList<OrderItem> allOrders = <OrderItem>[].obs;
  final RxList<OrderItem> paidOrders = <OrderItem>[].obs;
  final RxList<OrderItem> unpaidOrders = <OrderItem>[].obs;
  @override
  final RxBool isLoading = false.obs;
  final RxBool isPaginating = false.obs;
  final RxString error = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasMoreOrders = true.obs;

  // Selected tab index (0 = Unpaid, 1 = Paid)
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Fetch all orders
  Future<void> fetchOrders({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreOrders.value = true;
      }

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isPaginating.value = true;
      }

      error.value = '';

      final result = await _ordersRepository.getOrders(
        page: currentPage.value,
        perPage: 10,
      );

      result.fold(
        (failure) {
          error.value = failure.message;
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
          );
        },
        (response) {
          if (response.success) {
            if (currentPage.value == 1) {
              allOrders.clear();
            }

            allOrders.addAll(response.data.orders);
            totalPages.value = response.data.lastPage;
            hasMoreOrders.value = currentPage.value < response.data.lastPage;

            // Separate paid and unpaid orders
            _categorizeOrders();
          } else {
            error.value = response.message;
          }
        },
      );
    } catch (e) {
      error.value = 'An unexpected error occurred';
      debugPrint('Fetch orders error: $e');
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  /// Load more orders (pagination)
  Future<void> loadMoreOrders() async {
    if (!hasMoreOrders.value || isPaginating.value) return;

    currentPage.value++;
    await fetchOrders();
  }

  /// Refresh orders
  Future<void> refreshOrders() async {
    await fetchOrders(refresh: true);
  }

  /// Switch tab
  void switchTab(int index) {
    selectedTabIndex.value = index;
  }

  /// Get orders for current tab
  List<OrderItem> get currentTabOrders {
    switch (selectedTabIndex.value) {
      case 0:
        return unpaidOrders;
      case 1:
        return paidOrders;
      default:
        return unpaidOrders;
    }
  }

  /// Navigate to checkout page for pending payment order
  void payOrder(OrderItem order) {
    if (order.isPendingPayment) {
      // Navigate to checkout page with order details
      Get.toNamed(
        '/checkout-page',
        arguments: {
          'order': order.toJson(),
          'isExistingOrder': true,
          'orderId': order.id,
        },
      );
    }
  }

  /// Categorize orders into paid and unpaid
  void _categorizeOrders() {
    paidOrders.clear();
    unpaidOrders.clear();

    for (final order in allOrders) {
      if (order.isPaid) {
        paidOrders.add(order);
      } else {
        unpaidOrders.add(order);
      }
    }
  }

  /// Get status color
  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.paid:
        return Colors.green;
      case OrderStatus.active:
        return Colors.blue;
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.pendingPayment:
        return Colors.red;
      case OrderStatus.expired:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red.shade800;
    }
  }

  /// Get domain status color
  Color getDomainStatusColor(DomainStatus status) {
    switch (status) {
      case DomainStatus.active:
        return Colors.green;
      case DomainStatus.pending:
        return Colors.orange;
      case DomainStatus.expired:
        return Colors.grey;
      case DomainStatus.cancelled:
        return Colors.red;
    }
  }

  /// Format currency
  String formatCurrency(String amount, String currency) {
    final double value = double.tryParse(amount) ?? 0.0;
    return '$currency ${value.toStringAsFixed(0)}';
  }

  /// Format date
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format date with time
  String formatDateWithTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
