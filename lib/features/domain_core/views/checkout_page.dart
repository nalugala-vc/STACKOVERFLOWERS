import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/models/cart.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final cartController = Get.find<CartController>();
  final phoneController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  static const double vatRate = 0.16; // 16% VAT

  @override
  void dispose() {
    phoneController.dispose();
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
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
        title: Inter(
          text: 'Checkout',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppPallete.kenicRed),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              _buildOrderSummary(),
              spaceH30,

              // Promo Code
              _buildPromoSection(),
              spaceH30,

              // Payment Methods
              _buildPaymentMethods(),
              spaceH30,

              // Payment Details
              _buildPaymentDetails(),
              spaceH100,
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.cart.value.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildCheckoutButton();
      }),
    );
  }

  Widget _buildOrderSummary() {
    final cart = cartController.cart.value;
    double subtotal = cart.subtotal;
    double vat = subtotal * vatRate;
    double total = subtotal + vat - cart.discount;

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
                HeroIcons.calculator,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Order Summary',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH20,
          _buildSummaryRow('Subtotal', 'KES ${subtotal.toStringAsFixed(0)}'),
          if (cart.discount > 0)
            _buildSummaryRow(
              'Discount',
              '-KES ${cart.discount.toStringAsFixed(0)}',
              isDiscount: true,
            ),
          _buildSummaryRow('VAT (16%)', 'KES ${vat.toStringAsFixed(0)}'),
          const Divider(color: AppPallete.kenicGrey, thickness: 1),
          _buildSummaryRow(
            'Total',
            'KES ${total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
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
                HeroIcons.ticket,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Promo Code',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH15,
          Obx(() {
            if (cartController.appliedPromoCode.value.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.kenicGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const HeroIcon(
                      HeroIcons.checkCircle,
                      size: 20,
                      color: AppPallete.kenicGreen,
                    ),
                    spaceW10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Inter(
                            text:
                                'Promo code applied: ${cartController.appliedPromoCode.value}',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: AppPallete.kenicGreen,
                            textAlignment: TextAlign.left,
                          ),
                          Inter(
                            text:
                                'You saved KES ${cartController.promoDiscount.value.toStringAsFixed(0)}',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            textColor: AppPallete.kenicGreen,
                            textAlignment: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cartController.removePromoCode(),
                      child: const HeroIcon(
                        HeroIcons.xMark,
                        size: 16,
                        color: AppPallete.kenicGreen,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Row(
              children: [
                Expanded(
                  child: AuthField(
                    controller: cartController.promoCodeController,
                    hintText: 'Enter promo code',
                  ),
                ),
                spaceW10,
                RoundedButton(
                  onPressed:
                      () => cartController.applyPromoCode(
                        cartController.promoCodeController.text,
                      ),
                  label: 'Apply',
                  width: 80,
                  height: 48,
                  fontsize: 14,
                  isLoading: cartController.isLoading.value,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
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
                HeroIcons.creditCard,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Payment Method',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH20,
          ...PaymentMethod.values.map(
            (method) => _buildPaymentMethodOption(method),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(PaymentMethod method) {
    final isSelected = cartController.selectedPaymentMethod.value == method;
    final methodData = _getPaymentMethodData(method);

    return GestureDetector(
      onTap: () => cartController.setPaymentMethod(method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppPallete.kenicRed.withOpacity(0.1)
                  : AppPallete.kenicGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppPallete.kenicRed : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPallete.kenicWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(methodData['icon']!, height: 24, width: 24),
            ),
            spaceW15,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Inter(
                    text: methodData['name']!,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textAlignment: TextAlign.left,
                  ),
                  Inter(
                    text: methodData['description']!,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    textColor: AppPallete.greyColor,
                    textAlignment: TextAlign.left,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const HeroIcon(
                HeroIcons.checkCircle,
                size: 20,
                color: AppPallete.kenicRed,
              ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getPaymentMethodData(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.mpesa:
        return {
          'name': 'M-Pesa',
          'description': 'Pay with your M-Pesa mobile money',
          'icon': 'assets/logo.png', // Replace with M-Pesa icon
        };
      case PaymentMethod.card:
        return {
          'name': 'Credit/Debit Card',
          'description': 'Pay with Visa, Mastercard, or American Express',
          'icon': 'assets/logo.png', // Replace with card icon
        };
      case PaymentMethod.airtelMoney:
        return {
          'name': 'Airtel Money',
          'description': 'Pay with your Airtel Money wallet',
          'icon': 'assets/logo.png', // Replace with Airtel Money icon
        };
    }
  }

  Widget _buildPaymentDetails() {
    return Obx(() {
      switch (cartController.selectedPaymentMethod.value) {
        case PaymentMethod.mpesa:
        case PaymentMethod.airtelMoney:
          return _buildMobilePaymentDetails();
        case PaymentMethod.card:
          return _buildCardPaymentDetails();
      }
    });
  }

  Widget _buildMobilePaymentDetails() {
    final isAirtel =
        cartController.selectedPaymentMethod.value == PaymentMethod.airtelMoney;

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
          Inter(
            text: isAirtel ? 'Airtel Money Details' : 'M-Pesa Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlignment: TextAlign.left,
          ),
          spaceH20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Inter(
                text: 'Phone Number',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              spaceH10,
              AuthField(
                controller: phoneController,
                hintText: '+254 700 000 000',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          spaceH15,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppPallete.kenicGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const HeroIcon(
                  HeroIcons.informationCircle,
                  size: 16,
                  color: AppPallete.greyColor,
                ),
                spaceW10,
                Expanded(
                  child: Inter(
                    text:
                        isAirtel
                            ? 'You will receive a payment prompt on your phone'
                            : 'You will receive an M-Pesa STK push notification',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    textColor: AppPallete.greyColor,
                    textAlignment: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPaymentDetails() {
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
          Inter(
            text: 'Card Details',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlignment: TextAlign.left,
          ),
          spaceH20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Inter(
                text: 'Card Holder Name',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              spaceH10,
              AuthField(controller: cardHolderController, hintText: 'John Doe'),
            ],
          ),
          spaceH20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Inter(
                text: 'Card Number',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              spaceH10,
              AuthField(
                controller: cardNumberController,
                hintText: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          spaceH20,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: 'Expiry Date',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    spaceH10,
                    AuthField(
                      controller: expiryController,
                      hintText: 'MM/YY',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              spaceW20,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: 'CVV',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    spaceH10,
                    AuthField(
                      controller: cvvController,
                      hintText: '123',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    final cart = cartController.cart.value;
    double subtotal = cart.subtotal;
    double vat = subtotal * vatRate;
    double total = subtotal + vat - cart.discount;

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
                        text: 'Total Amount',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppPallete.greyColor,
                        textAlignment: TextAlign.left,
                      ),
                      Inter(
                        text: 'KES ${total.toStringAsFixed(0)}',
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
                  child: Obx(
                    () => RoundedButton(
                      onPressed: _processPayment,
                      label: 'Complete Payment',
                      isLoading: cartController.isProcessingPayment.value,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String amount, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Inter(
            text: label,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            textColor: isTotal ? AppPallete.kenicBlack : AppPallete.greyColor,
          ),
          Inter(
            text: amount,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            textColor:
                isDiscount
                    ? AppPallete.kenicGreen
                    : isTotal
                    ? AppPallete.kenicRed
                    : AppPallete.kenicBlack,
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    // Validate payment details
    if (!_validatePaymentDetails()) return;

    final paymentDetails = _createPaymentDetails();
    final receipt = await cartController.processPayment(paymentDetails);

    if (receipt != null) {
      Get.toNamed('/payment-confirmation', arguments: receipt);
    }
  }

  bool _validatePaymentDetails() {
    switch (cartController.selectedPaymentMethod.value) {
      case PaymentMethod.mpesa:
      case PaymentMethod.airtelMoney:
        if (phoneController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please enter your phone number',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
        break;
      case PaymentMethod.card:
        if (cardHolderController.text.trim().isEmpty ||
            cardNumberController.text.trim().isEmpty ||
            expiryController.text.trim().isEmpty ||
            cvvController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please fill in all card details',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
        break;
    }
    return true;
  }

  PaymentDetails _createPaymentDetails() {
    switch (cartController.selectedPaymentMethod.value) {
      case PaymentMethod.mpesa:
      case PaymentMethod.airtelMoney:
        return PaymentDetails(
          method: cartController.selectedPaymentMethod.value,
          phoneNumber: phoneController.text.trim(),
        );
      case PaymentMethod.card:
        return PaymentDetails(
          method: PaymentMethod.card,
          cardNumber: cardNumberController.text.trim(),
          cardHolderName: cardHolderController.text.trim(),
          expiryDate: expiryController.text.trim(),
          cvv: cvvController.text.trim(),
        );
    }
  }
}
