import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_search_controller.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/models/models.dart';

class DomainSearchResults extends StatefulWidget {
  const DomainSearchResults({super.key});

  @override
  State<DomainSearchResults> createState() => _DomainSearchResultsState();
}

class _DomainSearchResultsState extends State<DomainSearchResults> {
  int selectedYears = 1;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<DomainSearchController>();

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppPallete.kenicWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
        title: Inter(
          text: 'Search Results',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: AppPallete.kenicBlack,
        ),
      ),
      body: Obx(() {
        if (searchController.isSearching.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppPallete.kenicRed),
          );
        }

        if (searchController.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppPallete.greyColor,
                ),
                spaceH20,
                Inter(
                  text: 'Error',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicBlack,
                ),
                spaceH10,
                Inter(
                  text: searchController.errorMessage.value,
                  fontSize: 16,
                  textColor: AppPallete.greyColor,
                  textAlignment: TextAlign.center,
                ),
                spaceH30,
                ElevatedButton(
                  onPressed: () => searchController.clearError(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.kenicRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        if (!searchController.hasSearchResults) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: AppPallete.greyColor),
                spaceH20,
                Inter(
                  text: 'No Results Found',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicBlack,
                ),
                spaceH10,
                Inter(
                  text: 'Try searching for a different domain name',
                  fontSize: 16,
                  textColor: AppPallete.greyColor,
                  textAlignment: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final searchResult = searchController.searchResult.value!;
        final mainDomain = searchResult.domain;
        final suggestions = searchResult.suggestions;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Domain Result
              _buildMainDomainCard(mainDomain),
              spaceH30,

              // Suggestions
              if (suggestions.isNotEmpty) ...[
                Inter(
                  text: 'Alternative Domains',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicBlack,
                ),
                spaceH20,
                ...suggestions.map(
                  (suggestion) => _buildSuggestionCard(suggestion),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMainDomainCard(DomainInfo domain) {
    return Container(
      key: null,
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain name and status
          Row(
            children: [
              Container(
                key: null,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      domain.isAvailable
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  domain.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: domain.isAvailable ? Colors.green : Colors.red,
                  size: 24,
                ),
              ),
              spaceW15,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: domain.domainName,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      textColor: AppPallete.kenicBlack,
                    ),
                    spaceH5,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            domain.isAvailable
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Inter(
                        text:
                            domain.isAvailable
                                ? 'Domain is available'
                                : 'Domain is not available',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor:
                            domain.isAvailable
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          spaceH20,

          // Pricing info
          if (domain.pricing != null) ...[
            _buildPricingInfo(domain.pricing),
            spaceH20,
          ],

          // Action buttons
          if (domain.isAvailable) ...[
            Obx(() {
              final cartController = Get.find<CartController>();
              final isInCart = cartController.isInCart(domain.domainName);

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      final isLoading = cartController.isAddingToCart.value;

                      return ElevatedButton(
                        onPressed:
                            isInCart || isLoading
                                ? null
                                : () async {
                                  await cartController.addDomainInfoToCart(
                                    domain,
                                    registrationYears: selectedYears,
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isInCart ? Colors.green : AppPallete.kenicRed,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor:
                              isInCart
                                  ? Colors.green
                                  : AppPallete.kenicRed.withOpacity(0.6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(
                                isInCart
                                    ? Icons.check
                                    : Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                            spaceW10,
                            Text(
                              isLoading
                                  ? 'Adding to Cart...'
                                  : isInCart
                                  ? 'Already in Cart'
                                  : 'Add to Cart',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  if (isInCart) ...[
                    spaceH15,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicGrey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.offAllNamed('/main'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color: AppPallete.kenicRed.withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(
                                Icons.search,
                                size: 18,
                                color: AppPallete.kenicRed,
                              ),
                              label: const Text(
                                'Search More',
                                style: TextStyle(
                                  color: AppPallete.kenicRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          spaceW12,
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Get.toNamed('/cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPallete.kenicRed,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'View Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(DomainInfo suggestion) {
    return Container(
      key: null,
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                key: null,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      suggestion.isAvailable
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  suggestion.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: suggestion.isAvailable ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
              spaceW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: suggestion.domainName,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: AppPallete.kenicBlack,
                    ),
                    spaceH5,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            suggestion.isAvailable
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Inter(
                        text:
                            suggestion.isAvailable
                                ? 'Domain is available'
                                : 'Domain is not available',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor:
                            suggestion.isAvailable
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              if (suggestion.isAvailable) ...[
                Obx(() {
                  final cartController = Get.find<CartController>();
                  final isInCart = cartController.isInCart(
                    suggestion.domainName,
                  );

                  final isLoading = cartController.isAddingToCart.value;

                  return TextButton(
                    onPressed:
                        isInCart || isLoading
                            ? null
                            : () async {
                              await cartController.addDomainInfoToCart(
                                suggestion,
                                registrationYears: selectedYears,
                              );
                            },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isInCart
                              ? Colors.green.withOpacity(0.1)
                              : AppPallete.kenicRed.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor:
                          isInCart
                              ? Colors.green.withOpacity(0.1)
                              : AppPallete.kenicRed.withOpacity(0.05),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              color: AppPallete.kenicRed,
                              strokeWidth: 2,
                            ),
                          )
                        else
                          Icon(
                            isInCart ? Icons.check : Icons.add,
                            size: 16,
                            color:
                                isInCart ? Colors.green : AppPallete.kenicRed,
                          ),
                        spaceW5,
                        Inter(
                          text:
                              isLoading
                                  ? 'Adding...'
                                  : isInCart
                                  ? 'Added'
                                  : 'Add',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor:
                              isInCart ? Colors.green : AppPallete.kenicRed,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
          if (suggestion.pricing != null) ...[
            spaceH15,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Inter(
                  text: 'Registration Price',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppPallete.greyColor,
                ),
                Inter(
                  text:
                      'KES ${(suggestion.pricing?['1']?.register.firstOrNull?.price ?? 0).toStringAsFixed(2)}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicRed,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingInfo(Map<String, PeriodPricing> pricing) {
    // Get registration price for selected year
    final yearPricing = pricing[selectedYears.toString()];
    final renewalPrice = yearPricing?.renew.firstOrNull?.price ?? 0;
    final transferPrice = yearPricing?.transfer.firstOrNull?.price ?? 0;

    // Get price for selected number of years
    final selectedYearPrice = yearPricing?.register.firstOrNull?.price ?? 0;

    return Container(
      key: null,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicGrey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                key: null,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppPallete.kenicRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: AppPallete.kenicRed,
                ),
              ),
              spaceW12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Inter(
                    text: 'Pricing Details',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicBlack,
                  ),
                  spaceH5,
                  Inter(
                    text: 'KES ${selectedYearPrice.toStringAsFixed(2)}',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textColor: AppPallete.kenicRed,
                  ),
                ],
              ),
            ],
          ),
          spaceH15,
          // Year selector
          Row(
            children: [
              Inter(
                text: 'Registration Period:',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppPallete.greyColor,
              ),
              spaceW12,
              Container(
                key: null,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppPallete.kenicGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<int>(
                  value: selectedYears,
                  underline: const SizedBox(),
                  items:
                      List.generate(10, (index) => index + 1)
                          .map(
                            (year) => DropdownMenuItem(
                              value: year,
                              child: Text(
                                '$year ${year == 1 ? 'year' : 'years'}',
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedYears = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          spaceH20,
          // Pricing details
          _buildPriceRow(
            'Renewal Price',
            'KES ${renewalPrice.toStringAsFixed(2)}',
          ),
          spaceH12,
          _buildPriceRow(
            'Transfer Price',
            'KES ${transferPrice.toStringAsFixed(2)}',
          ),
          spaceH15,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppPallete.kenicGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppPallete.greyColor,
                ),
                spaceW8,
                Inter(
                  text: 'Prices shown include all applicable fees',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppPallete.greyColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String price, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Inter(
          text: label,
          fontSize: isHighlighted ? 16 : 14,
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
          textColor:
              isHighlighted ? AppPallete.kenicBlack : AppPallete.greyColor,
        ),
        Container(
          padding:
              isHighlighted
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                  : null,
          decoration:
              isHighlighted
                  ? BoxDecoration(
                    color: AppPallete.kenicRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  )
                  : null,
          child: Inter(
            text: price,
            fontSize: isHighlighted ? 18 : 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            textColor: AppPallete.kenicRed,
          ),
        ),
      ],
    );
  }
}
