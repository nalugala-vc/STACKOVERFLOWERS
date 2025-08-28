import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/models/cart.dart';

class CartCheckout extends StatefulWidget {
  const CartCheckout({super.key});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
      appBar: AppBar(
        backgroundColor: AppPallete.kenicWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            size: 24,
            color: AppPallete.kenicBlack,
          ),
        ),
        title: Inter(text: 'Cart', fontSize: 18, fontWeight: FontWeight.w600),
        actions: [
          IconButton(
            onPressed: () => cartController.refreshCart(),
            icon: const HeroIcon(
              HeroIcons.arrowPath,
              size: 20,
              color: AppPallete.kenicBlack,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppPallete.kenicRed),
          );
        }

        if (cartController.cart.value.isEmpty) {
          return _buildEmptyCart();
        }

        return RefreshIndicator(
          onRefresh: () => cartController.refreshCart(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Items
                _buildCartItems(),
                spaceH30,
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.cart.value.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildCreateOrderButton();
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroIcon(
              HeroIcons.shoppingBag,
              size: 80,
              color: AppPallete.greyColor,
            ),
            spaceH20,
            Inter(
              text: 'Your cart is empty',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            spaceH10,
            Inter(
              text: 'Start searching for domains to add them to your cart',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.center,
            ),
            spaceH30,
            RoundedButton(
              onPressed: () => Get.offAllNamed('/home'),
              label: 'Search Domains',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HeroIcon(
                HeroIcons.shoppingBag,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Your Domains',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
              const Spacer(),
              Inter(
                text:
                    '${cartController.cart.value.itemCount} ${cartController.cart.value.itemCount == 1 ? 'item' : 'items'}',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppPallete.greyColor,
              ),
              spaceW10,
              if (cartController.cart.value.isNotEmpty)
                GestureDetector(
                  onTap: () => _showClearCartDialog(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppPallete.kenicRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const HeroIcon(
                      HeroIcons.trash,
                      size: 16,
                      color: AppPallete.kenicRed,
                    ),
                  ),
                ),
            ],
          ),
          spaceH20,
          if (cartController.cart.value.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const HeroIcon(
                      HeroIcons.shoppingBag,
                      size: 40,
                      color: AppPallete.greyColor,
                    ),
                    spaceH10,
                    Inter(
                      text: 'No items in cart',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppPallete.greyColor,
                    ),
                  ],
                ),
              ),
            )
          else
            ...cartController.cart.value.items.map(
              (item) => _buildCartItem(item),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: item.domain.fullDomainName,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textAlignment: TextAlign.left,
                    ),
                    spaceH5,
                    Inter(
                      text:
                          '${item.registrationYears} ${item.registrationYears == 1 ? 'year' : 'years'} registration',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      textColor: AppPallete.greyColor,
                      textAlignment: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Inter(
                    text: 'KES ${item.totalPrice.toStringAsFixed(0)}',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicRed,
                  ),
                  Inter(
                    text: 'KES ${item.domain.price.toStringAsFixed(0)}/year',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    textColor: AppPallete.greyColor,
                  ),
                ],
              ),
            ],
          ),
          spaceH15,
          Row(
            children: [
              // Registration Years Selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppPallete.kenicWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Inter(
                      text: 'Years: ',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    DropdownButton<int>(
                      value: item.registrationYears,
                      underline: const SizedBox.shrink(),
                      items:
                          List.generate(10, (index) => index + 1)
                              .map(
                                (year) => DropdownMenuItem<int>(
                                  value: year,
                                  child: Inter(
                                    text: '$year',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          cartController.updateRegistrationYears(
                            item.domain.fullDomainName,
                            value,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Remove Button
              GestureDetector(
                onTap:
                    () => cartController.removeFromCart(
                      item.domain.fullDomainName,
                    ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const HeroIcon(
                    HeroIcons.trash,
                    size: 16,
                    color: AppPallete.kenicRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateOrderButton() {
    final cart = cartController.cart.value;
    double subtotal = cart.subtotal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Subtotal',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppPallete.greyColor,
                        textAlignment: TextAlign.left,
                      ),
                      Inter(
                        text: 'KES ${subtotal.toStringAsFixed(0)}',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textColor: AppPallete.kenicRed,
                        textAlignment: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                spaceW20,
                Expanded(
                  flex: 2,
                  child: RoundedButton(
                    onPressed: () => cartController.createOrder(),
                    label: 'Create Order',
                    isLoading: cartController.isLoading.value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all items from your cart? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cartController.clearCart();
              },
              style: TextButton.styleFrom(foregroundColor: AppPallete.kenicRed),
              child: const Text('Clear Cart'),
            ),
          ],
        );
      },
    );
  }
}
