import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/features/domain_core/models/cart.dart';
import 'package:kenic/features/domain_core/models/domain.dart';

class CartController extends BaseController {
  static CartController get instance => Get.find();

  final cart = Cart.empty().obs;
  final selectedPaymentMethod = PaymentMethod.mpesa.obs;
  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final promoDiscount = 0.0.obs;
  final isProcessingPayment = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  void loadCart() {
    // In real app, load from shared preferences or API
    cart.value = Cart.empty();
  }

  void addToCart(Domain domain, {int registrationYears = 1}) {
    final existingItemIndex = cart.value.items.indexWhere(
      (item) => item.domain.fullDomainName == domain.fullDomainName,
    );

    if (existingItemIndex != -1) {
      // Update existing item
      final updatedItems = List<CartItem>.from(cart.value.items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
          .copyWith(registrationYears: registrationYears);

      cart.value = cart.value.copyWith(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem(
        domain: domain.copyWith(isInCart: true),
        registrationYears: registrationYears,
      );

      final updatedItems = List<CartItem>.from(cart.value.items)..add(newItem);
      cart.value = cart.value.copyWith(items: updatedItems);
    }

    _saveCart();

    Get.snackbar(
      'Added to Cart',
      '${domain.fullDomainName} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeFromCart(String domainName) {
    final updatedItems =
        cart.value.items
            .where((item) => item.domain.fullDomainName != domainName)
            .toList();

    cart.value = cart.value.copyWith(items: updatedItems);
    _saveCart();

    Get.snackbar(
      'Removed from Cart',
      '$domainName has been removed from your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateRegistrationYears(String domainName, int years) {
    final itemIndex = cart.value.items.indexWhere(
      (item) => item.domain.fullDomainName == domainName,
    );

    if (itemIndex != -1) {
      final updatedItems = List<CartItem>.from(cart.value.items);
      updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
        registrationYears: years,
      );

      cart.value = cart.value.copyWith(items: updatedItems);
      _saveCart();
    }
  }

  void clearCart() {
    cart.value = Cart.empty();
    appliedPromoCode.value = '';
    promoDiscount.value = 0.0;
    promoCodeController.clear();
    _saveCart();
  }

  Future<void> applyPromoCode(String code) async {
    if (code.trim().isEmpty) return;

    setBusy(true);

    try {
      // Mock promo code validation - in real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 800));

      final discount = _validatePromoCode(code);

      if (discount > 0) {
        appliedPromoCode.value = code;
        promoDiscount.value = discount;

        cart.value = cart.value.copyWith(discount: discount, promoCode: code);

        _saveCart();

        Get.snackbar(
          'Promo Code Applied',
          'You saved \$${discount.toStringAsFixed(2)}!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Invalid Promo Code',
          'The promo code you entered is not valid or has expired.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to apply promo code. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setBusy(false);
    }
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    promoDiscount.value = 0.0;
    promoCodeController.clear();

    cart.value = cart.value.copyWith(discount: 0.0, promoCode: null);

    _saveCart();
  }

  double _validatePromoCode(String code) {
    // Mock promo code validation
    switch (code.toUpperCase()) {
      case 'SAVE10':
        return cart.value.subtotal * 0.1; // 10% off
      case 'FIRST20':
        return cart.value.subtotal * 0.2; // 20% off
      case 'NEWUSER':
        return 5.0; // $5 off
      case 'KENIC50':
        return cart.value.subtotal > 50
            ? 10.0
            : 0.0; // $10 off if subtotal > $50
      default:
        return 0.0;
    }
  }

  void setPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  Future<Map<String, dynamic>?> processPayment(
    PaymentDetails paymentDetails,
  ) async {
    if (cart.value.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add domains to your cart before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    isProcessingPayment.value = true;
    setBusy(true);

    try {
      // Mock payment processing - in real app, this would be a payment gateway call
      await Future.delayed(const Duration(seconds: 3));

      // Simulate payment success/failure
      final isSuccess = _mockPaymentProcess();

      if (isSuccess) {
        final transactionId = _generateTransactionId();
        final receipt = {
          'transactionId': transactionId,
          'amount': cart.value.total,
          'domains':
              cart.value.items
                  .map((item) => item.domain.fullDomainName)
                  .toList(),
          'paymentMethod': paymentDetails.method.name,
          'date': DateTime.now().toIso8601String(),
          'status': 'success',
        };

        // Clear cart after successful payment
        clearCart();

        return receipt;
      } else {
        Get.snackbar(
          'Payment Failed',
          'Your payment could not be processed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while processing your payment.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isProcessingPayment.value = false;
      setBusy(false);
    }
  }

  bool _mockPaymentProcess() {
    // Mock 90% success rate
    return DateTime.now().millisecond % 10 != 0;
  }

  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 10000;
    return 'TXN${timestamp.toString().substring(8)}$random';
  }

  void _saveCart() {
    // In real app, save to shared preferences or sync with backend
  }

  bool isInCart(String domainName) {
    return cart.value.containsDomain(domainName);
  }

  CartItem? getCartItem(String domainName) {
    return cart.value.findItem(domainName);
  }
}
