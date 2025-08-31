import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/domain_core/models/payment.dart';

class PaymentConfirmation extends StatefulWidget {
  const PaymentConfirmation({super.key});

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation>
    with TickerProviderStateMixin {
  late Map<String, dynamic> receipt;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args == null) {
      Get.offAllNamed('/home');
      return;
    }
    receipt = args as Map<String, dynamic>;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  // Extract domains from the order items
  List<String> get _purchasedDomains {
    try {
      debugPrint('Extracting domains from receipt: $receipt');
      final order = receipt['order'] as Map<String, dynamic>?;
      debugPrint('Order data: $order');

      if (order != null) {
        final items = order['items'] as List<dynamic>?;
        debugPrint('Order items: $items');

        if (items != null) {
          final domains =
              items
                  .map((item) => item['domain_name'] as String? ?? '')
                  .where((domain) => domain.isNotEmpty)
                  .toList();
          debugPrint('Extracted domains: $domains');
          return domains;
        }
      }
      debugPrint('No domains found in receipt');
      return [];
    } catch (e) {
      debugPrint('Error extracting domains: $e');
      return [];
    }
  }

  // Extract domain details with years
  List<Map<String, dynamic>> get _domainDetails {
    try {
      final order = receipt['order'] as Map<String, dynamic>?;
      if (order != null) {
        final items = order['items'] as List<dynamic>?;
        if (items != null) {
          return items
              .map(
                (item) => {
                  'domain_name': item['domain_name'] as String? ?? '',
                  'number_of_years': item['number_of_years'] as int? ?? 1,
                  'price': item['price'] as String? ?? '0.00',
                  'status': item['status'] as String? ?? 'pending',
                },
              )
              .where(
                (domain) =>
                    (domain['domain_name'] as String?)?.isNotEmpty == true,
              )
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error extracting domain details: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              spaceH40,
              // Success Animation
              _buildSuccessHeader(),
              spaceH40,

              // Receipt Details
              _buildReceiptCard(),
              spaceH30,

              // Transaction Details
              _buildTransactionDetails(),
              spaceH30,

              // // Domain List
              // _buildDomainsList(),
              // spaceH40,

              // Action Buttons
              _buildActionButtons(),
              spaceH20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppPallete.kenicGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: HeroIcon(
                    HeroIcons.checkCircle,
                    size: 60,
                    color: AppPallete.kenicGreen,
                  ),
                ),
              ),
            );
          },
        ),
        spaceH20,
        Inter(
          text: 'Payment Successful!',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          textColor: AppPallete.kenicGreen,
        ),
        spaceH10,
        Inter(
          text: 'Your domain registration is complete',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          textColor: AppPallete.greyColor,
          textAlignment: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Receipt Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.kenicRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 64,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                spaceW15,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'KENIC',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        textAlignment: TextAlign.left,
                      ),
                      Inter(
                        text: 'Domain Registration',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.greyColor,
                        textAlignment: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          spaceH20,

          // Receipt Info
          _buildReceiptRow('Receipt #', receipt['id']?.toString() ?? 'N/A'),
          _buildReceiptRow('Date', _formatDate(receipt['created_at'])),
          _buildReceiptRow(
            'Payment Method',
            _formatPaymentMethod(receipt['payment_method']),
          ),
          _buildReceiptRow(
            'Status',
            receipt['status'] ?? 'N/A',
            valueColor: AppPallete.kenicGreen,
          ),

          const Divider(color: AppPallete.kenicGrey, thickness: 1),

          _buildReceiptRow(
            'Total Amount',
            'KES ${receipt['amount']?.toString() ?? '0'}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    Color? valueColor,
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
            text: value,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            textColor:
                valueColor ??
                (isTotal ? AppPallete.kenicRed : AppPallete.kenicBlack),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
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
                HeroIcons.documentText,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Transaction Details',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH20,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.kenicGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Inter(
                  text: 'Transaction ID',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppPallete.greyColor,
                  textAlignment: TextAlign.left,
                ),
                spaceH5,
                Row(
                  children: [
                    Expanded(
                      child: Inter(
                        text: receipt['transaction_id']?.toString() ?? 'N/A',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textAlignment: TextAlign.left,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Copy to clipboard functionality
                        Get.snackbar(
                          'Copied',
                          'Transaction ID copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const HeroIcon(
                        HeroIcons.clipboard,
                        size: 20,
                        color: AppPallete.kenicRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          spaceH15,
          _buildInfoCard(
            'What happens next?',
            'Your domains are now registered and active. You will receive confirmation emails with setup instructions.',
            HeroIcons.informationCircle,
            AppPallete.kenicRed,
          ),
        ],
      ),
    );
  }

  Widget _buildDomainsList() {
    final domainDetails = _domainDetails;

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
                HeroIcons.globeAlt,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Your New Domains',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH20,
          if (domainDetails.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPallete.kenicGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Inter(
                  text: 'No domains found in this order',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textColor: AppPallete.greyColor,
                  textAlignment: TextAlign.center,
                ),
              ),
            )
          else
            ...domainDetails.map(
              (domain) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.kenicGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HeroIcon(
                        HeroIcons.checkCircle,
                        size: 16,
                        color: AppPallete.kenicGreen,
                      ),
                    ),
                    spaceW15,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Inter(
                            text: domain['domain_name'] as String,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textAlignment: TextAlign.left,
                          ),
                          spaceH5,
                          Row(
                            children: [
                              Inter(
                                text:
                                    '${domain['number_of_years']} year${domain['number_of_years'] > 1 ? 's' : ''} registration',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                textColor: AppPallete.kenicGreen,
                                textAlignment: TextAlign.left,
                              ),
                              spaceW10,
                              Inter(
                                text: 'KES ${domain['price']}',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: AppPallete.kenicRed,
                                textAlignment: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const HeroIcon(
                      HeroIcons.arrowTopRightOnSquare,
                      size: 16,
                      color: AppPallete.greyColor,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String description,
    HeroIcons icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroIcon(icon, size: 20, color: color),
          spaceW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Inter(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textAlignment: TextAlign.left,
                ),
                spaceH5,
                Inter(
                  text: description,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  textColor: AppPallete.greyColor,
                  textAlignment: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        RoundedButton(
          onPressed:
              () => Get.offAllNamed('/main', arguments: {'initialTab': 1}),
          label: 'Go to My Domains',
          fontsize: 16,
        ),
        spaceH15,
        Row(
          children: [
            Expanded(
              child: RoundedButton(
                onPressed:
                    () =>
                        Get.offAllNamed('/main', arguments: {'initialTab': 0}),
                label: 'Search More',
                backgroundColor: AppPallete.kenicGrey,
                textColor: AppPallete.kenicBlack,
                fontsize: 14,
              ),
            ),
            spaceW15,
            Expanded(
              child: RoundedButton(
                onPressed: _shareReceipt,
                label: 'Share Receipt',
                backgroundColor: AppPallete.kenicGrey,
                textColor: AppPallete.kenicBlack,
                fontsize: 14,
              ),
            ),
          ],
        ),
        spaceH20,
        // Support section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPallete.kenicGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const HeroIcon(
                HeroIcons.lifebuoy,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: 'Need Help?',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textAlignment: TextAlign.left,
                    ),
                    Inter(
                      text: 'Our support team is here 24/7',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      textColor: AppPallete.greyColor,
                      textAlignment: TextAlign.left,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/support'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicRed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Inter(
                    text: 'Contact',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatPaymentMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'mpesa':
        return 'M-Pesa';
      case 'card':
        return 'Credit/Debit Card';
      case 'airtelmoney':
        return 'Airtel Money';
      default:
        return method ?? 'N/A';
    }
  }

  void _shareReceipt() {
    // Implement share functionality
    Get.snackbar(
      'Share Receipt',
      'Receipt sharing functionality would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
