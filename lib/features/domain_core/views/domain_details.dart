import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/models/domain.dart';

class DomainDetails extends StatefulWidget {
  const DomainDetails({super.key});

  @override
  State<DomainDetails> createState() => _DomainDetailsState();
}

class _DomainDetailsState extends State<DomainDetails> {
  late Domain domain;
  final cartController = Get.find<CartController>();
  final selectedYears = 1.obs;

  @override
  void initState() {
    super.initState();
    domain = Get.arguments as Domain;
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
          text: 'Domain Details',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          Obx(
            () => Stack(
              children: [
                IconButton(
                  onPressed: () => Get.toNamed('/cart'),
                  icon: const HeroIcon(
                    HeroIcons.shoppingBag,
                    size: 24,
                    color: AppPallete.kenicBlack,
                  ),
                ),
                if (cartController.cart.value.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppPallete.kenicRed,
                        shape: BoxShape.circle,
                      ),
                      child: Inter(
                        text: '${cartController.cart.value.itemCount}',
                        fontSize: 10,
                        textColor: AppPallete.kenicWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain Header
            _buildDomainHeader(),
            spaceH30,

            // Pricing Section
            _buildPricingSection(),
            spaceH30,

            // WHOIS Information (if domain is taken)
            if (!domain.isAvailable && domain.whoisInfo != null) ...[
              _buildWhoisSection(),
              spaceH30,
            ],

            // Features & Benefits
            _buildFeaturesSection(),
            spaceH30,

            // Recommendations
            _buildRecommendationsSection(),
          ],
        ),
      ),
      bottomNavigationBar: domain.isAvailable ? _buildBottomBar() : null,
    );
  }

  Widget _buildDomainHeader() {
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      domain.isAvailable
                          ? AppPallete.kenicGreen.withOpacity(0.1)
                          : AppPallete.greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HeroIcon(
                  domain.isAvailable
                      ? HeroIcons.checkCircle
                      : HeroIcons.xCircle,
                  size: 24,
                  color:
                      domain.isAvailable
                          ? AppPallete.kenicGreen
                          : AppPallete.greyColor,
                ),
              ),
              spaceW15,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: domain.fullDomainName,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      textAlignment: TextAlign.left,
                    ),
                    spaceH5,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            domain.isAvailable
                                ? AppPallete.kenicGreen.withOpacity(0.1)
                                : AppPallete.greyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Inter(
                        text:
                            domain.isAvailable
                                ? 'Available for Registration'
                                : 'Already Registered',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor:
                            domain.isAvailable
                                ? AppPallete.kenicGreen
                                : AppPallete.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (domain.description != null) ...[
            spaceH15,
            Inter(
              text: domain.description!,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.left,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
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
                HeroIcons.currencyDollar,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Pricing Information',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
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
                      text: 'Registration Price',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: AppPallete.greyColor,
                      textAlignment: TextAlign.left,
                    ),
                    spaceH5,
                    Inter(
                      text: '\$${domain.price.toStringAsFixed(2)}',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      textColor: AppPallete.kenicRed,
                      textAlignment: TextAlign.left,
                    ),
                    Inter(
                      text: 'per year',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      textColor: AppPallete.greyColor,
                      textAlignment: TextAlign.left,
                    ),
                  ],
                ),
              ),
              if (domain.isAvailable) ...[
                Column(
                  children: [
                    Inter(
                      text: 'Registration Period',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: AppPallete.greyColor,
                    ),
                    spaceH10,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(
                        () => DropdownButton<int>(
                          value: selectedYears.value,
                          underline: const SizedBox.shrink(),
                          items:
                              List.generate(10, (index) => index + 1)
                                  .map(
                                    (year) => DropdownMenuItem<int>(
                                      value: year,
                                      child: Inter(
                                        text:
                                            '$year ${year == 1 ? 'Year' : 'Years'}',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              selectedYears.value = value;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (domain.isAvailable) ...[
            spaceH20,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppPallete.kenicGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Inter(
                    text: 'Total Cost',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  Obx(
                    () => Inter(
                      text:
                          '\$${(domain.price * selectedYears.value).toStringAsFixed(2)}',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      textColor: AppPallete.kenicRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWhoisSection() {
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
                HeroIcons.informationCircle,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'WHOIS Information',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH20,
          _buildWhoisItem('Registrant', domain.whoisInfo!.registrant),
          _buildWhoisItem('Registrar', domain.whoisInfo!.registrarName),
          _buildWhoisItem(
            'Registration Date',
            DateFormat(
              'MMM dd, yyyy',
            ).format(domain.whoisInfo!.registrationDate),
          ),
          _buildWhoisItem(
            'Expiry Date',
            DateFormat('MMM dd, yyyy').format(domain.whoisInfo!.expiryDate),
          ),
          _buildWhoisItem('Status', domain.whoisInfo!.status),
          _buildWhoisItem(
            'Name Servers',
            domain.whoisInfo!.nameServers.join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildWhoisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Inter(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.left,
            ),
          ),
          Expanded(
            child: Inter(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              textAlignment: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {
        'icon': HeroIcons.shieldCheck,
        'title': 'Domain Protection',
        'description': 'WHOIS privacy protection included',
      },
      {
        'icon': HeroIcons.clock,
        'title': 'Auto-Renewal',
        'description': 'Never lose your domain with auto-renewal',
      },
      {
        'icon': HeroIcons.lifebuoy,
        'title': '24/7 Support',
        'description': 'Expert help whenever you need it',
      },
      {
        'icon': HeroIcons.globeAlt,
        'title': 'DNS Management',
        'description': 'Easy DNS record management tools',
      },
    ];

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
                HeroIcons.star,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'What\'s Included',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH20,
          ...features.map(
            (feature) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppPallete.kenicRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: HeroIcon(
                      feature['icon'] as HeroIcons,
                      size: 20,
                      color: AppPallete.kenicRed,
                    ),
                  ),
                  spaceW15,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Inter(
                          text: feature['title'] as String,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textAlignment: TextAlign.left,
                        ),
                        spaceH5,
                        Inter(
                          text: feature['description'] as String,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HeroIcon(
                HeroIcons.lightBulb,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Pro Tips',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH15,
          if (domain.isAvailable) ...[
            _buildTipItem('Register for multiple years to save money'),
            _buildTipItem(
              'Consider getting similar extensions to protect your brand',
            ),
            _buildTipItem('Set up auto-renewal to avoid losing your domain'),
          ] else ...[
            _buildTipItem(
              'Check when this domain expires for potential availability',
            ),
            _buildTipItem('Consider similar domain variations'),
            _buildTipItem(
              'Set up domain monitoring to get notified if it becomes available',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(
              color: AppPallete.kenicRed,
              shape: BoxShape.circle,
            ),
          ),
          spaceW10,
          Expanded(
            child: Inter(
              text: tip,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
                        text: 'Total Cost',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppPallete.greyColor,
                        textAlignment: TextAlign.left,
                      ),
                      Obx(
                        () => Inter(
                          text:
                              '\$${(domain.price * selectedYears.value).toStringAsFixed(2)}',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          textColor: AppPallete.kenicRed,
                          textAlignment: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceW20,
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => RoundedButton(
                      onPressed: () {
                        if (cartController.isInCart(domain.fullDomainName)) {
                          Get.toNamed('/cart');
                        } else {
                          cartController.addToCart(
                            domain,
                            registrationYears: selectedYears.value,
                          );
                        }
                      },
                      label:
                          cartController.isInCart(domain.fullDomainName)
                              ? 'Go to Cart'
                              : 'Register Domain',
                      backgroundColor:
                          cartController.isInCart(domain.fullDomainName)
                              ? AppPallete.kenicGreen
                              : AppPallete.kenicRed,
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
}
