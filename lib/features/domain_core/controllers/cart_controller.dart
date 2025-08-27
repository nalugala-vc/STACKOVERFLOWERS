import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/features/domain_core/models/cart.dart';
import 'package:kenic/features/domain_core/models/domain.dart';
import 'package:kenic/features/domain_core/models/models.dart';
import 'package:kenic/features/domain_core/repository/cart_repository.dart';
import 'package:kenic/features/domain_core/utils/domain_converter.dart';

class CartController extends BaseController {
  static CartController get instance => Get.find();

  // Repository
  final CartRepository _repository = CartRepository();

  final cart = Cart.empty().obs;
  final selectedPaymentMethod = PaymentMethod.mpesa.obs;
  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final promoDiscount = 0.0.obs;
  final isProcessingPayment = false.obs;

  // API data
  final cartId = Rxn<int>();
  final cartItemsWithIds = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    fetchCartFromAPI();
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

  /// Fetch cart items from the API
  Future<void> fetchCartFromAPI() async {
    setBusy(true);

    try {
      final result = await _repository.getCart();

      result.fold(
        (failure) {
          debugPrint('Failed to fetch cart: ${failure.message}');
          // Keep local cart if API fails
        },
        (cartData) {
          debugPrint('Fetched cart data: $cartData');
          _updateLocalCartFromAPI(cartData);
        },
      );
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      // Keep local cart if API fails
    } finally {
      setBusy(false);
    }
  }

  /// Update local cart with data from API
  void _updateLocalCartFromAPI(Map<String, dynamic> cartData) {
    // Extract cart ID
    final cartIdValue = cartData['id'] as int?;
    if (cartIdValue != null) {
      cartId.value = cartIdValue;
      debugPrint('Cart ID: $cartIdValue');
    }

    // Extract cart items
    final items = cartData['items'] as List<dynamic>?;
    if (items == null) {
      debugPrint('No items found in cart data');
      cart.value = Cart.empty();
      cartItemsWithIds.clear();
      return;
    }

    // Store items with IDs for API operations
    cartItemsWithIds.value = List<Map<String, dynamic>>.from(items);
    debugPrint('Stored ${cartItemsWithIds.length} cart items with IDs');

    final List<CartItem> localCartItems = [];

    for (final apiItem in items) {
      try {
        final itemData = apiItem as Map<String, dynamic>;
        debugPrint('Parsing API item: $itemData');

        // Extract data from API response
        final itemId = itemData['id'] as int? ?? 0;
        final domainName = itemData['domain_name'] as String? ?? '';
        final priceString = itemData['price'] as String? ?? '0.0';
        final price = double.tryParse(priceString) ?? 0.0;
        final numberOfYears = itemData['number_of_years'] as int? ?? 1;

        debugPrint(
          'Extracted: itemId=$itemId, domainName=$domainName, price=$price, years=$numberOfYears',
        );

        if (domainName.isNotEmpty && price > 0) {
          // Create a Domain object from API data
          final domain = Domain(
            name: domainName.split('.').first, // Extract SLD
            extension:
                domainName.contains('.')
                    ? '.${domainName.split('.').last}'
                    : '',
            isAvailable: true,
            price: price,
            description: 'Domain from cart',
          );

          debugPrint(
            'Created domain: ${domain.fullDomainName} with price: ${domain.price}',
          );

          // Create CartItem with item ID stored
          final cartItem = CartItem(
            domain: domain,
            registrationYears: numberOfYears,
            itemId: itemId,
          );

          localCartItems.add(cartItem);
          debugPrint(
            'Added cart item: ${cartItem.domain.fullDomainName} with ID: $itemId',
          );
        } else {
          debugPrint('Skipping item: domainName empty or price <= 0');
        }
      } catch (e) {
        debugPrint('Error parsing cart item: $e');
      }
    }

    // Update local cart
    cart.value = Cart(items: localCartItems);
    debugPrint('Updated local cart with ${localCartItems.length} items');
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

  /// Add DomainInfo to cart using the API
  Future<void> addDomainInfoToCart(
    DomainInfo domainInfo, {
    int registrationYears = 1,
  }) async {
    if (!domainInfo.isAvailable) {
      Get.snackbar(
        'Domain Not Available',
        '${domainInfo.domainName} is not available for registration',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    setBusy(true);

    try {
      final price = DomainConverter.getFirstYearPrice(domainInfo);

      final result = await _repository.addToCart(
        domainName: domainInfo.domainName,
        price: price,
        registrationYears: registrationYears,
      );

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
          );
        },
        (success) {
          if (success) {
            // Convert DomainInfo to Domain and add to local cart
            final domain = DomainConverter.domainInfoToDomain(domainInfo);
            addToCart(domain, registrationYears: registrationYears);

            Get.snackbar(
              'Success',
              '${domainInfo.domainName} has been added to your cart',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade100,
              colorText: Colors.green.shade900,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while adding to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      setBusy(false);
    }
  }

  void removeFromCart(String domainName) {
    // Find the cart item by domain name
    final cartItem = cart.value.items.firstWhereOrNull(
      (item) => item.domain.fullDomainName == domainName,
    );

    if (cartItem != null && cartItem.itemId != null) {
      _removeFromCartAPI(cartItem.itemId!, domainName);
    } else {
      Get.snackbar(
        'Error',
        'Could not find item ID for removal',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Remove item from cart via API
  Future<void> _removeFromCartAPI(int itemId, String domainName) async {
    setBusy(true);

    try {
      final result = await _repository.removeFromCart(itemId);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) {
          if (success) {
            // Remove from local cart
            final updatedItems =
                cart.value.items
                    .where((item) => item.domain.fullDomainName != domainName)
                    .toList();

            cart.value = cart.value.copyWith(items: updatedItems);

            // Remove from stored items with IDs
            cartItemsWithIds.removeWhere(
              (item) => item['domain_name'] == domainName,
            );

            Get.snackbar(
              'Removed from Cart',
              '$domainName has been removed from your cart',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while removing item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setBusy(false);
    }
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
    if (cartId.value != null) {
      _clearCartAPI(cartId.value!);
    } else {
      Get.snackbar(
        'Error',
        'Cart ID not available for clearing',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Clear cart via API
  Future<void> _clearCartAPI(int cartIdValue) async {
    setBusy(true);

    try {
      final result = await _repository.clearCart(cartIdValue);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) {
          if (success) {
            // Clear local cart
            cart.value = Cart.empty();
            appliedPromoCode.value = '';
            promoDiscount.value = 0.0;
            promoCodeController.clear();
            cartItemsWithIds.clear();
            this.cartId.value = null;

            Get.snackbar(
              'Cart Cleared',
              'All items have been removed from your cart',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while clearing cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setBusy(false);
    }
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
          'You saved KES ${discount.toStringAsFixed(0)}!',
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

  /// Refresh cart from API
  Future<void> refreshCart() async {
    await fetchCartFromAPI();
  }
}
