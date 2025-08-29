import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/features/domain_core/models/cart.dart';
import 'package:kenic/features/domain_core/models/domain.dart';
import 'package:kenic/features/domain_core/models/models.dart';
import 'package:kenic/features/domain_core/models/order.dart';

import 'package:kenic/features/domain_core/repository/cart_repository.dart';
import 'package:kenic/features/domain_core/repository/order_repository.dart';
import 'package:kenic/features/domain_core/utils/domain_converter.dart';

class CartController extends BaseController {
  static CartController get instance => Get.find();

  // Repositories
  final CartRepository _cartRepository = CartRepository();
  final OrderRepository _orderRepository = OrderRepository();

  final cart = Cart.empty().obs;
  final selectedPaymentMethod = PaymentMethod.mpesa.obs;
  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final promoDiscount = 0.0.obs;
  final isProcessingPayment = false.obs;
  final isAddingToCart = false.obs;

  // API data
  final cartId = Rxn<int>();
  final cartItemsWithIds = <Map<String, dynamic>>[].obs;
  final orderId = Rxn<int>();

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
      final result = await _cartRepository.getCart();

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
    } else {
      // Try to find cart ID in items if not at root level
      final items = cartData['items'] as List<dynamic>?;
      if (items?.isNotEmpty == true) {
        final firstItem = items!.first as Map<String, dynamic>;
        final cartIdFromItem = firstItem['cart_id'] as int?;
        if (cartIdFromItem != null) {
          cartId.value = cartIdFromItem;
          debugPrint('Cart ID from item: $cartIdFromItem');
        }
      }
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
          final domainParts = domainName.split('.');
          final domain = Domain(
            name: domainParts.first, // Extract SLD
            extension:
                domainParts.length > 1
                    ? '.${domainParts.sublist(1).join('.')}'
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
  /// Returns true if the item was successfully added to cart
  Future<bool> addDomainInfoToCart(
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
      return false;
    }

    isAddingToCart.value = true;
    setBusy(true);

    try {
      final price = DomainConverter.getFirstYearPrice(domainInfo);

      final result = await _cartRepository.addToCart(
        domainName: domainInfo.domainName,
        price: price,
        registrationYears: registrationYears,
      );

      return result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
          );
          return false;
        },
        (success) async {
          if (success) {
            try {
              // Fetch cart to get the updated cart ID
              await fetchCartFromAPI();

              // Note: fetchCartFromAPI already updates the local cart from the API response,
              // so we don't need to manually add the domain again
              debugPrint(
                'Domain ${domainInfo.domainName} successfully added via API and cart updated',
              );

              // Show success message and navigation options
              Get.snackbar(
                'Added to Cart',
                '${domainInfo.domainName} has been added to your cart',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade900,
                duration: const Duration(seconds: 4),
                mainButton: TextButton(
                  onPressed: () => Get.toNamed('/cart'),
                  child: const Text(
                    'VIEW CART',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );

              return true;
            } catch (e) {
              debugPrint('Error updating local cart: $e');
              return false;
            }
          }
          return false;
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
      return false;
    } finally {
      isAddingToCart.value = false;
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
      final result = await _cartRepository.removeFromCart(itemId);

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
      final result = await _cartRepository.clearCart(cartIdValue);

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

  void _saveCart() {
    // In real app, save to shared preferences or sync with backend
  }

  void _clearCartAndNavigateToConfirmation(Map<String, dynamic>? paymentData) {
    // Clear cart
    cart.value = Cart.empty();
    appliedPromoCode.value = '';
    promoDiscount.value = 0.0;
    promoCodeController.clear();
    cartItemsWithIds.clear();
    cartId.value = null;
    orderId.value = null;

    // Navigate to confirmation page
    Get.offAllNamed('/payment-confirmation', arguments: paymentData);
  }

  Future<void> _launchPaymentUrl(String url, String paymentReference) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // After launching URL, start polling for payment status
        _startPaymentStatusPolling(paymentReference);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch payment page',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to launch payment page',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<void> _startPaymentStatusPolling(String paymentReference) async {
    // Poll every 5 seconds for 2 minutes
    const maxAttempts = 24; // 2 minutes = 24 * 5 seconds
    int attempts = 0;

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 5));

      final result = await _orderRepository.queryPayment(
        paymentReference: paymentReference,
      );

      final success = result.fold((failure) => false, (response) {
        if (response.success &&
            response.data?.status.toLowerCase() == 'success') {
          _clearCartAndNavigateToConfirmation(response.data?.toJson());
          return true;
        }
        return false;
      });

      if (success) break;
      attempts++;
    }

    if (attempts >= maxAttempts) {
      Get.snackbar(
        'Payment Status',
        'Please check your email for payment confirmation',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool isInCart(String domainName) {
    // Normalize the domain name to ensure consistent comparison
    final normalizedDomainName = domainName.toLowerCase().trim();

    // Debug: Log what we're checking
    debugPrint('🔍 Checking if "$normalizedDomainName" is in cart...');
    debugPrint('📦 Cart contains ${cart.value.items.length} items:');
    for (final item in cart.value.items) {
      final cartDomainName = item.domain.fullDomainName.toLowerCase().trim();
      debugPrint('   - "$cartDomainName"');
    }

    // Check using normalized domain names
    final result = cart.value.items.any(
      (item) =>
          item.domain.fullDomainName.toLowerCase().trim() ==
          normalizedDomainName,
    );

    debugPrint(
      '✅ Result: "$normalizedDomainName" ${result ? "IS" : "IS NOT"} in cart',
    );
    return result;
  }

  CartItem? getCartItem(String domainName) {
    return cart.value.findItem(domainName);
  }

  /// Refresh cart from API
  Future<void> refreshCart() async {
    await fetchCartFromAPI();
  }

  /// Create order from cart
  Future<void> createOrder() async {
    if (cart.value.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add domains to your cart before creating an order.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setBusy(true);

    try {
      final result = await _orderRepository.createOrder();

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
        (response) {
          if (response.success && response.data != null) {
            orderId.value = response.data!.id;
            Get.toNamed('/checkout-page');
          } else {
            Get.snackbar(
              'Error',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while creating the order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      setBusy(false);
    }
  }

  /// Process payment for the order
  Future<void> processPayment({
    String? phoneNumber,
    String? cardNumber,
    String? cvv,
    String? expiryMonth,
    String? expiryYear,
  }) async {
    if (orderId.value == null) {
      Get.snackbar(
        'Error',
        'No active order found. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isProcessingPayment.value = true;
    setBusy(true);

    try {
      final result = await _orderRepository.payOrder(
        orderId: orderId.value!,
        paymentMethod: selectedPaymentMethod.value,
        phoneNumber: phoneNumber,
        cardDetails:
            selectedPaymentMethod.value == PaymentMethod.card
                ? CardPaymentDetails(
                  cardNumber: cardNumber ?? '',
                  cvv: cvv ?? '',
                  expiryMonth: expiryMonth ?? '',
                  expiryYear: expiryYear ?? '',
                )
                : null,
      );

      result.fold(
        (failure) {
          Get.snackbar(
            'Payment Failed',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
          );
        },
        (response) {
          if (response.success) {
            if (selectedPaymentMethod.value == PaymentMethod.card &&
                response.data?.paymentUrl != null) {
              // For card payments, launch the payment URL
              final paymentUrl = response.data?.paymentUrl;
              final paymentRef = response.data?.paymentReference;

              if (paymentUrl != null && paymentRef != null) {
                _launchPaymentUrl(paymentUrl, paymentRef);
              } else {
                Get.snackbar(
                  'Error',
                  'Payment URL not available',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.red.shade900,
                );
              }
            } else {
              // For other payment methods, proceed to confirmation
              _clearCartAndNavigateToConfirmation(response.data?.toJson());
            }
          } else {
            Get.snackbar(
              'Payment Failed',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.red.shade900,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while processing payment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isProcessingPayment.value = false;
      setBusy(false);
    }
  }
}
