import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/theme/responsive_sizes.dart';
import 'package:kenic/features/domain_core/controllers/domain_search_controller.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late DomainSearchController searchController;
  late CartController cartController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    searchController = Get.put(DomainSearchController());
    cartController = Get.put(CartController());
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    Get.delete<DomainSearchController>();
    Get.delete<CartController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Hero Section
          SliverAppBar(
            expandedHeight: ResponsiveSizes.getHeroHeight(context),
            floating: false,
            pinned: true,
            backgroundColor: AppPallete.kenicWhite,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(context),
            ),
            title: _buildAppBarTitle(),
            actions: [_buildCartIcon()],
          ),

          // Promotional Section
          SliverToBoxAdapter(child: _buildPromotionalSection()),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppPallete.kenicWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(ResponsiveSizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceH20,
                    _buildExtensionCards(),
                    spaceH40,
                    _buildTrendingSection(),
                    spaceH40,
                    _buildRecentSearches(),
                    spaceH60,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return FadeTransition(
      opacity: _fadeController,
      child: Row(
        children: [
          Container(
            height: ResponsiveSizes.size40,
            width: ResponsiveSizes.size65,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(right: ResponsiveSizes.size16),
        child: Stack(
          children: [
            IconButton(
              onPressed: () => Get.toNamed('/cart'),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppPallete.kenicWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const HeroIcon(
                  HeroIcons.shoppingBag,
                  size: 20,
                  color: AppPallete.kenicBlack,
                ),
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
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppPallete.kenicRed.withOpacity(0.05),
            AppPallete.kenicWhite,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // World Map Background
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(top: ResponsiveSizes.size80),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/wrld.png'),
                  fit: BoxFit.contain,
                  opacity: 0.15,
                ),
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppPallete.kenicWhite.withOpacity(0.8),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),

          // Hero Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveSizes.size24),
                  child: Column(
                    children: [
                      // Main Title
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Inter(
                              text: 'Find Your Perfect',
                              fontSize: ResponsiveSizes.size32,
                              fontWeight: FontWeight.w300,
                              textAlignment: TextAlign.center,
                              textColor: AppPallete.kenicBlack,
                            ),
                            Inter(
                              text: 'Domain Name',
                              fontSize: ResponsiveSizes.size36,
                              fontWeight: FontWeight.bold,
                              textAlignment: TextAlign.center,
                              textColor: AppPallete.kenicRed,
                            ),
                            spaceH15,
                            Inter(
                              text:
                                  'Establish your digital presence with premium domains\nfrom Kenya and beyond',
                              fontSize: ResponsiveSizes.size16,
                              fontWeight: FontWeight.normal,
                              textColor: AppPallete.greyColor,
                              textAlignment: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      spaceH40,

                      // Enhanced Search Bar
                      _buildSearchBar(),
                      spaceH25,

                      // Quick Stats
                      _buildQuickStats(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppPallete.kenicWhite,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Search input field
              Expanded(
                child: TextField(
                  controller: searchController.searchController,
                  decoration: InputDecoration(
                    filled: false,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search for your perfect domain...',
                    hintStyle: TextStyle(
                      color: AppPallete.greyColor.withOpacity(0.7),
                      fontSize: ResponsiveSizes.size16,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppPallete.kenicRed,
                            AppPallete.kenicRed.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: HeroIcon(
                        HeroIcons.magnifyingGlass,
                        size: ResponsiveSizes.size20,
                        color: AppPallete.kenicWhite,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                  ),
                  onSubmitted: (value) async {
                    if (value.trim().isNotEmpty) {
                      final fullDomain = searchController.getFullDomainName(
                        value.trim(),
                      );
                      await searchController.searchDomains(fullDomain);
                      if (mounted) {
                        Get.toNamed('/search-results');
                      }
                    }
                  },
                ),
              ),

              // Domain extension dropdown
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Obx(
                  () => PopupMenuButton<String>(
                    onSelected: (String extension) {
                      searchController.selectDomainExtension(extension);
                    },
                    itemBuilder: (BuildContext context) {
                      return searchController.domainExtensions.map((
                        extensionData,
                      ) {
                        return PopupMenuItem<String>(
                          value: extensionData.extension,
                          child: SizedBox(
                            width: 280,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Inter(
                                  text: extensionData.extension,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppPallete.kenicRed,
                                ),
                                spaceH5,
                                Inter(
                                  text: extensionData.description,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppPallete.greyColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppPallete.kenicRed.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Inter(
                            text:
                                searchController.selectedDomainExtension.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: AppPallete.kenicRed,
                          ),
                          spaceW5,
                          const HeroIcon(
                            HeroIcons.chevronDown,
                            size: 16,
                            color: AppPallete.kenicRed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Search button
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    final query = searchController.searchController.text.trim();
                    if (query.isNotEmpty) {
                      final fullDomain = searchController.getFullDomainName(
                        query,
                      );
                      await searchController.searchDomains(fullDomain);
                      if (mounted) {
                        Get.toNamed('/search-results');
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppPallete.kenicBlack,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                        searchController.isSearching.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppPallete.kenicWhite,
                              ),
                            )
                            : const HeroIcon(
                              HeroIcons.arrowRight,
                              size: 20,
                              color: AppPallete.kenicWhite,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Domain Suggestions
        Obx(() {
          if (searchController.hasSuggestions) {
            return Container(
              margin: EdgeInsets.only(top: ResponsiveSizes.size8),
              decoration: BoxDecoration(
                color: AppPallete.kenicWhite,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchController.suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = searchController.suggestions[index];
                  return ListTile(
                    leading: Icon(
                      suggestion.isAvailable
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: suggestion.isAvailable ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      suggestion.domainName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      suggestion.isAvailable ? 'Available' : 'Not Available',
                      style: TextStyle(
                        color:
                            suggestion.isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing:
                        suggestion.bestRegistrationPrice != null
                            ? Text(
                              suggestion.bestRegistrationPrice!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppPallete.kenicRed,
                              ),
                            )
                            : null,
                    onTap: () async {
                      final domainName = suggestion.domainName;
                      searchController.searchController.text = domainName;
                      searchController.suggestions.clear();
                      await searchController.searchDomains(domainName);
                      if (mounted) {
                        Get.toNamed('/search-results');
                      }
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('1M+', 'Domains', HeroIcons.globeAlt),
        Container(width: 1, height: 30, color: AppPallete.kenicGrey),
        _buildStatItem('24/7', 'Support', HeroIcons.chatBubbleLeftRight),
        Container(width: 1, height: 30, color: AppPallete.kenicGrey),
        _buildStatItem('99.9%', 'Uptime', HeroIcons.shieldCheck),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, HeroIcons icon) {
    return Column(
      children: [
        HeroIcon(icon, size: 20, color: AppPallete.kenicRed),
        spaceH5,
        Inter(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textColor: AppPallete.kenicBlack,
        ),
        Inter(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          textColor: AppPallete.greyColor,
        ),
      ],
    );
  }

  Widget _buildPromotionalSection() {
    return Container(
      margin: EdgeInsets.all(ResponsiveSizes.size24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain Search Suggestion Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.kenicGrey.withOpacity(0.8),
                  AppPallete.kenicWhite,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ResponsiveSizes.size24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Search Available Domains',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        textColor: AppPallete.kenicBlack,
                      ),
                      spaceH10,
                      Inter(
                        text: 'Check domain availability instantly',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.greyColor,
                      ),
                      spaceH20,
                      Container(
                        decoration: BoxDecoration(
                          color: AppPallete.kenicBlack,
                          borderRadius: BorderRadius.circular(
                            ResponsiveSizes.size12,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Navigate to domain search
                          },
                          icon: const HeroIcon(
                            HeroIcons.arrowRight,
                            size: 20,
                            color: AppPallete.kenicWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spaceW20,
                // Domain suggestion mockup
                Container(
                  padding: EdgeInsets.all(ResponsiveSizes.size16),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicWhite,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.size16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Search bar mockup
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSizes.size12,
                          vertical: ResponsiveSizes.size8,
                        ),
                        decoration: BoxDecoration(
                          color: AppPallete.kenicGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSizes.size8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Inter(
                              text: 'kenic-domains',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: AppPallete.kenicBlack,
                            ),
                            spaceW5,
                            const HeroIcon(
                              HeroIcons.magnifyingGlass,
                              size: 12,
                              color: AppPallete.greyColor,
                            ),
                          ],
                        ),
                      ),
                      spaceH12,
                      // Domain suggestions
                      Column(
                        children: [
                          _buildDomainSuggestion('kenic-domains.ke', true),
                          spaceH5,
                          _buildDomainSuggestion('kenic-domains.co.ke', false),
                          spaceH5,
                          _buildDomainSuggestion('kenic-domains.or.ke', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          spaceH30,

          // Special Offer Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.kenicRed,
                  AppPallete.kenicRed.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ResponsiveSizes.size24),
              boxShadow: [
                BoxShadow(
                  color: AppPallete.kenicRed.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: '.co.ke for',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textColor: AppPallete.kenicWhite,
                      ),
                      Inter(
                        text: 'KES 999/1st year',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textColor: AppPallete.kenicWhite,
                      ),
                      spaceH10,
                      Inter(
                        text: 'Get your Kenyan domain today',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.kenicWhite.withOpacity(0.9),
                      ),
                      spaceH20,
                      Container(
                        decoration: BoxDecoration(
                          color: AppPallete.kenicWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Navigate to .co.ke domains
                          },
                          icon: const HeroIcon(
                            HeroIcons.arrowRight,
                            size: 20,
                            color: AppPallete.kenicRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spaceW20,
                // Kenya flag colors accent
                Container(
                  width: ResponsiveSizes.size80,
                  height: ResponsiveSizes.size80,
                  decoration: BoxDecoration(
                    color: AppPallete.kenicWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ResponsiveSizes.size16),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveSizes.size8),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicWhite,
                        borderRadius: BorderRadius.circular(
                          ResponsiveSizes.size12,
                        ),
                      ),
                      child: Inter(
                        text: '.co.ke',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textColor: AppPallete.kenicRed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainSuggestion(String domain, bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppPallete.kenicGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Inter(
            text: domain,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            textColor: AppPallete.kenicBlack,
          ),
          spaceW8,
          if (isAvailable)
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppPallete.kenicGreen,
                shape: BoxShape.circle,
              ),
              child: const HeroIcon(
                HeroIcons.check,
                size: 8,
                color: AppPallete.kenicWhite,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExtensionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Inter(
              text: 'Popular Extensions',
              fontSize: ResponsiveSizes.size22,
              fontWeight: FontWeight.bold,
              textColor: AppPallete.kenicBlack,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Inter(
                text: 'View All',
                fontSize: ResponsiveSizes.size14,
                fontWeight: FontWeight.w600,
                textColor: AppPallete.kenicRed,
              ),
            ),
          ],
        ),
        spaceH20,
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                searchController.availableExtensions.take(8).map((extension) {
                  final isSelected = searchController.selectedExtensions
                      .contains(extension);
                  return GestureDetector(
                    onTap: () => searchController.toggleExtension(extension),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppPallete.kenicRed
                                : AppPallete.kenicWhite,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppPallete.kenicRed
                                  : AppPallete.kenicGrey,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isSelected
                                    ? AppPallete.kenicRed.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Inter(
                            text: extension,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor:
                                isSelected
                                    ? AppPallete.kenicWhite
                                    : AppPallete.kenicBlack,
                          ),
                          spaceW8,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppPallete.kenicWhite.withOpacity(0.2)
                                      : AppPallete.kenicRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Inter(
                              text: 'KES ${_getPriceForExtension(extension)}',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              textColor:
                                  isSelected
                                      ? AppPallete.kenicWhite
                                      : AppPallete.kenicRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppPallete.kenicRed, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: HeroIcon(
                HeroIcons.fire,
                size: ResponsiveSizes.size20,
                color: AppPallete.kenicWhite,
              ),
            ),
            spaceW12,
            Inter(
              text: 'Trending Now',
              fontSize: ResponsiveSizes.size22,
              fontWeight: FontWeight.bold,
              textColor: AppPallete.kenicBlack,
            ),
          ],
        ),
        spaceH20,
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                searchController.trendingKeywords.take(6).map((keyword) {
                  return GestureDetector(
                    onTap: () => searchController.searchFromKeyword(keyword),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSizes.size16,
                        vertical: ResponsiveSizes.size10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppPallete.kenicWhite,
                            AppPallete.kenicGrey.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppPallete.kenicGrey.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HeroIcon(
                            HeroIcons.hashtag,
                            size: 16,
                            color: AppPallete.kenicRed,
                          ),
                          spaceW5,
                          Inter(
                            text: keyword,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: AppPallete.kenicBlack,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearches() {
    return Obx(() {
      if (searchController.recentSearches.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HeroIcon(
                HeroIcons.clock,
                size: 20,
                color: AppPallete.greyColor,
              ),
              spaceW10,
              Inter(
                text: 'Recent Searches',
                fontSize: ResponsiveSizes.size18,
                fontWeight: FontWeight.w600,
                textColor: AppPallete.kenicBlack,
              ),
            ],
          ),
          spaceH15,
          ...searchController.recentSearches.take(3).map((search) {
            return Container(
              margin: EdgeInsets.only(bottom: ResponsiveSizes.size8),
              decoration: BoxDecoration(
                color: AppPallete.kenicGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSizes.size16,
                  vertical: ResponsiveSizes.size5,
                ),
                leading: HeroIcon(
                  HeroIcons.magnifyingGlass,
                  size: ResponsiveSizes.size18,
                  color: AppPallete.greyColor,
                ),
                title: Inter(
                  text: search,
                  fontSize: ResponsiveSizes.size15,
                  fontWeight: FontWeight.w500,
                  textColor: AppPallete.kenicBlack,
                ),
                trailing: HeroIcon(
                  HeroIcons.arrowRight,
                  size: ResponsiveSizes.size16,
                  color: AppPallete.greyColor,
                ),
                onTap: () => searchController.searchFromKeyword(search),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  double _getPriceForExtension(String extension) {
    switch (extension) {
      case '.ke':
        return 999;
      case '.co.ke':
        return 999;
      case '.or.ke':
        return 999;
      case '.ac.ke':
        return 1349;
      case '.sc.ke':
        return 6.50;
      case '.go.ke':
        return 1000;
      case '.ne.ke':
        return 800;
      case '.me.ke':
        return 700;
      case '.com':
        return 1299;
      case '.net':
        return 14.99;
      case '.org':
        return 13.99;
      case '.info':
        return 11.99;
      default:
        return 15.99;
    }
  }
}
