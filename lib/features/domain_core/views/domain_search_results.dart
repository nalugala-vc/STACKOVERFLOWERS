import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/domain_core/controllers/domain_search_controller.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';
import 'package:kenic/features/domain_core/models/domain.dart';

class DomainSearchResults extends StatefulWidget {
  const DomainSearchResults({super.key});

  @override
  State<DomainSearchResults> createState() => _DomainSearchResultsState();
}

class _DomainSearchResultsState extends State<DomainSearchResults> {
  final searchController = Get.find<DomainSearchController>();
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
        title: Inter(
          text: 'Search Results',
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
      body: Obx(() {
        if (searchController.isSearching.value) {
          return _buildLoadingState();
        }

        if (searchController.searchResults.isEmpty &&
            searchController.aiSuggestions.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search query info
              _buildSearchInfo(),
              spaceH20,

              // Main search results
              if (searchController.searchResults.isNotEmpty) ...[
                _buildMainResults(),
                spaceH30,
              ],

              // AI Suggestions
              if (searchController.aiSuggestions.isNotEmpty) ...[
                _buildAISuggestions(),
                spaceH30,
              ],

              // Search tips
              _buildSearchTips(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppPallete.kenicRed),
          const SizedBox(height: 20),
          Inter(
            text: 'Searching domains...',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroIcon(
              HeroIcons.magnifyingGlass,
              size: 80,
              color: AppPallete.greyColor,
            ),
            spaceH20,
            Inter(
              text: 'No results found',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            spaceH10,
            Inter(
              text: 'Try different keywords or check your spelling',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.center,
            ),
            spaceH30,
            RoundedButton(
              onPressed: () => Get.back(),
              label: 'Try Again',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const HeroIcon(
            HeroIcons.informationCircle,
            size: 20,
            color: AppPallete.kenicRed,
          ),
          spaceW10,
          Expanded(
            child: Inter(
              text:
                  'Showing results for "${searchController.searchController.text}"',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textAlignment: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Inter(
          text: 'Your Search Results',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textAlignment: TextAlign.left,
        ),
        spaceH15,
        ...searchController.searchResults.map(
          (domain) => _buildDomainCard(domain),
        ),
      ],
    );
  }

  Widget _buildAISuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppPallete.kenicRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeroIcon(
                    HeroIcons.sparkles,
                    size: 14,
                    color: AppPallete.kenicRed,
                  ),
                  spaceW5,
                  Inter(
                    text: 'AI',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicRed,
                  ),
                ],
              ),
            ),
            spaceW10,
            Inter(
              text: 'We found some creative names for you',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textAlignment: TextAlign.left,
            ),
          ],
        ),
        spaceH15,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: searchController.aiSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = searchController.aiSuggestions[index];
            return _buildSuggestionCard(suggestion);
          },
        ),
      ],
    );
  }

  Widget _buildDomainCard(Domain domain) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              domain.isAvailable
                  ? AppPallete.kenicGreen
                  : AppPallete.greyColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                      text: domain.fullDomainName,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textAlignment: TextAlign.left,
                    ),
                    spaceH5,
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                domain.isAvailable
                                    ? AppPallete.kenicGreen.withOpacity(0.1)
                                    : AppPallete.greyColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Inter(
                            text: domain.isAvailable ? 'Available' : 'Taken',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor:
                                domain.isAvailable
                                    ? AppPallete.kenicGreen
                                    : AppPallete.greyColor,
                          ),
                        ),
                        if (!domain.isAvailable) ...[
                          spaceW10,
                          GestureDetector(
                            onTap:
                                () => Get.toNamed(
                                  '/domain-details',
                                  arguments: domain,
                                ),
                            child: Inter(
                              text: 'View Details',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: AppPallete.kenicRed,
                              underline: true,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Inter(
                    text: '\$${domain.price.toStringAsFixed(2)}',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicRed,
                  ),
                  Inter(
                    text: '/year',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    textColor: AppPallete.greyColor,
                  ),
                ],
              ),
            ],
          ),
          if (domain.isAvailable) ...[
            spaceH15,
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => RoundedButton(
                      onPressed: () {
                        if (cartController.isInCart(domain.fullDomainName)) {
                          Get.toNamed('/cart');
                        } else {
                          cartController.addToCart(domain);
                        }
                      },
                      label:
                          cartController.isInCart(domain.fullDomainName)
                              ? 'In Cart'
                              : 'Add to Cart',
                      height: 40,
                      fontsize: 14,
                      backgroundColor:
                          cartController.isInCart(domain.fullDomainName)
                              ? AppPallete.kenicGreen
                              : AppPallete.kenicRed,
                    ),
                  ),
                ),
                spaceW10,
                GestureDetector(
                  onTap:
                      () => Get.toNamed('/domain-details', arguments: domain),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppPallete.kenicGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: HeroIcon(
                        HeroIcons.informationCircle,
                        size: 20,
                        color: AppPallete.kenicBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(DomainSuggestion suggestion) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              suggestion.isAvailable
                  ? AppPallete.kenicGreen
                  : AppPallete.greyColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Inter(
                text: suggestion.fullDomainName,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
                shouldTruncate: true,
                truncateLength: 15,
              ),
              spaceH5,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      suggestion.isAvailable
                          ? AppPallete.kenicGreen.withOpacity(0.1)
                          : AppPallete.greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Inter(
                  text: suggestion.isAvailable ? 'Available' : 'Taken',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  textColor:
                      suggestion.isAvailable
                          ? AppPallete.kenicGreen
                          : AppPallete.greyColor,
                ),
              ),
            ],
          ),
          if (suggestion.isAvailable) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Inter(
                  text: '\$${suggestion.price.toStringAsFixed(2)}',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicRed,
                  textAlignment: TextAlign.left,
                ),
                spaceH10,
                SizedBox(
                  width: double.infinity,
                  child: RoundedButton(
                    onPressed: () {
                      final domain = Domain(
                        name: suggestion.suggestion,
                        extension: suggestion.extension,
                        isAvailable: suggestion.isAvailable,
                        price: suggestion.price,
                      );
                      cartController.addToCart(domain);
                    },
                    label: 'Add',
                    height: 32,
                    fontsize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchTips() {
    return Container(
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
              const HeroIcon(
                HeroIcons.lightBulb,
                size: 20,
                color: AppPallete.kenicRed,
              ),
              spaceW10,
              Inter(
                text: 'Search Tips',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textAlignment: TextAlign.left,
              ),
            ],
          ),
          spaceH10,
          const _TipItem(tip: 'Try different keywords or variations'),
          const _TipItem(tip: 'Consider alternative extensions like .co.ke'),
          const _TipItem(tip: 'Keep it short and memorable'),
          const _TipItem(tip: 'Avoid hyphens and numbers when possible'),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String tip;

  const _TipItem({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(
              color: AppPallete.greyColor,
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
}
