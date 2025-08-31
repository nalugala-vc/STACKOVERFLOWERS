import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/empty_widget.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';
import 'package:kenic/features/domain_core/models/cart.dart';

class CartCheckout extends StatefulWidget {
  const CartCheckout({super.key});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout>
    with WidgetsBindingObserver {
  final cartController = Get.find<CartController>();
  final domainController = Get.find<DomainController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Fetch user details when page loads
    _refreshUserDetails();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh user details when app becomes active again
      _refreshUserDetails();
    }
  }

  Future<void> _refreshUserDetails() async {
    await domainController.refreshWhmcsUserDetails();
  }

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
            onPressed: () async {
              await cartController.refreshCart();
              await _refreshUserDetails();
            },
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
          onRefresh: () async {
            await cartController.refreshCart();
            await _refreshUserDetails();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Completion Check
                _buildProfileCompletionCheck(),
                // Only add spacing if the profile widget is shown
                Obx(() {
                  final userDetails = domainController.whmcsUserDetails.value;
                  final isLoading = domainController.isLoadingUserDetails.value;
                  final showWidget =
                      isLoading ||
                      userDetails == null ||
                      !userDetails.isComplete;
                  return showWidget ? spaceH20 : const SizedBox.shrink();
                }),
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
            EmptyWidget(
              title: 'Your cart is empty',
              description:
                  'Start searching for domains to add them to your cart',
            ),

            spaceH30,
            RoundedButton(
              onPressed: () => Get.offAllNamed('/main'),
              label: 'Search Domains',
              fontsize: 16,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCompletionCheck() {
    return Obx(() {
      final userDetails = domainController.whmcsUserDetails.value;
      final isLoading = domainController.isLoadingUserDetails.value;

      // If loading, show loading indicator
      if (isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(color: AppPallete.kenicRed),
          ),
        );
      }

      // If user details are null, show unknown status
      if (userDetails == null) {
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
                    HeroIcons.exclamationTriangle,
                    size: 20,
                    color: Colors.orange,
                  ),
                  spaceW10,
                  Inter(
                    text: 'Profile Status Unknown',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textAlignment: TextAlign.left,
                  ),
                ],
              ),
              spaceH10,
              Inter(
                text:
                    'Unable to verify your profile status. Please complete your profile to continue.',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                textColor: AppPallete.greyColor,
                textAlignment: TextAlign.left,
              ),
              spaceH10,
              RoundedButton(
                onPressed:
                    () =>
                        Get.offAllNamed('/main', arguments: {'initialTab': 3}),
                label: 'Complete Profile',
                fontsize: 16,
                width: double.infinity,
              ),
            ],
          ),
        );
      }

      final isComplete = userDetails.isComplete;

      // If profile is complete, don't show the widget at all
      if (isComplete) {
        return const SizedBox.shrink();
      }

      // Only show the widget if profile is incomplete
      final missingFields = userDetails.missingFields;

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
          border: Border.all(
            color: AppPallete.kenicRed.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HeroIcon(
                  HeroIcons.exclamationTriangle,
                  size: 20,
                  color: Colors.orange,
                ),
                spaceW10,
                Inter(
                  text: 'Profile Incomplete',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textAlignment: TextAlign.left,
                  textColor: Colors.orange,
                ),
              ],
            ),
            spaceH10,
            Inter(
              text:
                  'Please complete the following fields before placing an order:',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.left,
            ),
            spaceH10,
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  missingFields
                      .take(6)
                      .map(
                        (field) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppPallete.kenicRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppPallete.kenicRed.withOpacity(0.3),
                            ),
                          ),
                          child: Inter(
                            text: field,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: AppPallete.kenicRed,
                          ),
                        ),
                      )
                      .toList(),
            ),
            if (missingFields.length > 6)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Inter(
                  text: '... and ${missingFields.length - 6} more',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  textColor: AppPallete.greyColor,
                ),
              ),
            spaceH10,
            RoundedButton(
              onPressed:
                  () => Get.offAllNamed('/main', arguments: {'initialTab': 3}),
              label: 'Complete Profile',
              fontsize: 16,
              width: double.infinity,
              backgroundColor: AppPallete.kenicRed,
            ),
          ],
        ),
      );
    });
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
