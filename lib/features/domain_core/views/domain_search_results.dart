import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_search_controller.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/models/models.dart';

class DomainSearchResults extends StatelessWidget {
  const DomainSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<DomainSearchController>();

    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: domain.isAvailable ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              domain.isAvailable ? Colors.green.shade200 : Colors.red.shade200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                domain.isAvailable ? Icons.check_circle : Icons.cancel,
                color: domain.isAvailable ? Colors.green : Colors.red,
                size: 32,
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
                    Inter(
                      text: domain.status,
                      fontSize: 16,
                      textColor:
                          domain.isAvailable
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          spaceH20,
          if (domain.kePricing != null) ...[
            _buildPricingInfo(domain.kePricing!),
          ],
          spaceH20,
          if (domain.isAvailable) ...[
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                final cartController = Get.find<CartController>();
                final isInCart = cartController.isInCart(domain.domainName);

                return ElevatedButton(
                  onPressed:
                      isInCart
                          ? null
                          : () => cartController.addDomainInfoToCart(domain),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isInCart ? Colors.grey.shade400 : AppPallete.kenicRed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isInCart ? 'Already in Cart' : 'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(DomainInfo suggestion) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            suggestion.isAvailable ? Icons.check_circle : Icons.cancel,
            color: suggestion.isAvailable ? Colors.green : Colors.red,
            size: 24,
          ),
          spaceW15,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Inter(
                  text: suggestion.domainName,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicBlack,
                ),
                Inter(
                  text: suggestion.status,
                  fontSize: 14,
                  textColor:
                      suggestion.isAvailable
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                ),
              ],
            ),
          ),
          if (suggestion.isAvailable) ...[
            Obx(() {
              final cartController = Get.find<CartController>();
              final isInCart = cartController.isInCart(suggestion.domainName);

              return IconButton(
                onPressed:
                    isInCart
                        ? null
                        : () => cartController.addDomainInfoToCart(suggestion),
                icon: Icon(
                  isInCart ? Icons.check_circle : Icons.add_shopping_cart,
                  color: isInCart ? Colors.green : AppPallete.kenicRed,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingInfo(KePricing pricing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Inter(
            text: 'Pricing (${pricing.currency})',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textColor: AppPallete.kenicBlack,
          ),
          spaceH15,
          Row(
            children: [
              Expanded(
                child: _buildPriceItem(
                  'Registration',
                  pricing.registrationPrice,
                ),
              ),
              Expanded(child: _buildPriceItem('Renewal', pricing.renewalPrice)),
              Expanded(
                child: _buildPriceItem('Transfer', pricing.transferPrice),
              ),
            ],
          ),
          spaceH15,
          Inter(
            text: 'Available for ${pricing.availableYears.join(', ')} years',
            fontSize: 14,
            textColor: AppPallete.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, String price) {
    return Column(
      children: [
        Inter(text: label, fontSize: 12, textColor: AppPallete.greyColor),
        spaceH5,
        Inter(
          text: price,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          textColor: AppPallete.kenicRed,
        ),
      ],
    );
  }
}
