import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_search_controller.dart';
import 'package:kenic/features/domain_core/controllers/cart_controller.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final searchController = Get.put(DomainSearchController());
  final cartController = Get.put(CartController());
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
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
            expandedHeight: MediaQuery.of(context).size.height * 0.60,
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
                padding: const EdgeInsets.all(24),
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
            height: 40,
            width: 65,
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
        margin: const EdgeInsets.only(right: 16),
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
              margin: const EdgeInsets.only(top: 80),
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Main Title
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Inter(
                              text: 'Find Your Perfect',
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              textAlignment: TextAlign.center,
                              textColor: AppPallete.kenicBlack,
                            ),
                            Inter(
                              text: 'Domain Name',
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              textAlignment: TextAlign.center,
                              textColor: AppPallete.kenicRed,
                            ),
                            spaceH15,
                            Inter(
                              text:
                                  'Establish your digital presence with premium domains\nfrom Kenya and beyond',
                              fontSize: 16,
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
    return Container(
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
      child: TextField(
        controller: searchController.searchController,
        decoration: InputDecoration(
          hintText: 'Search for your perfect domain...',
          hintStyle: TextStyle(
            color: AppPallete.greyColor.withOpacity(0.7),
            fontSize: 16,
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
            child: const HeroIcon(
              HeroIcons.magnifyingGlass,
              size: 20,
              color: AppPallete.kenicWhite,
            ),
          ),
          suffixIcon: Obx(
            () => GestureDetector(
              onTap: () {
                final query = searchController.searchController.text.trim();
                if (query.isNotEmpty) {
                  searchController.searchDomains(query);
                  Get.toNamed('/search-results');
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            searchController.searchDomains(value.trim());
            Get.toNamed('/search-results');
          }
        },
      ),
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
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Inter(
            text: 'Domains',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            textColor: AppPallete.kenicBlack,
          ),
          spaceH10,
          Inter(
            text: 'Find your perfect domain name',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            textColor: AppPallete.greyColor,
          ),
          spaceH30,

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
              borderRadius: BorderRadius.circular(24),
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
                          borderRadius: BorderRadius.circular(12),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicWhite,
                    borderRadius: BorderRadius.circular(16),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppPallete.kenicGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
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
                          _buildDomainSuggestion('kenic-domains.com', true),
                          spaceH5,
                          _buildDomainSuggestion('kenic-domains.co.ke', false),
                          spaceH5,
                          _buildDomainSuggestion('kenic-domains.org', false),
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
              borderRadius: BorderRadius.circular(24),
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
                        text: '.co.ke for \$8.50/1st year',
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppPallete.kenicWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicWhite,
                        borderRadius: BorderRadius.circular(12),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              textColor: AppPallete.kenicBlack,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Inter(
                text: 'View All',
                fontSize: 14,
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
                              text: '\$${_getPriceForExtension(extension)}',
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
              child: const HeroIcon(
                HeroIcons.fire,
                size: 20,
                color: AppPallete.kenicWhite,
              ),
            ),
            spaceW12,
            Inter(
              text: 'Trending Now',
              fontSize: 22,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textColor: AppPallete.kenicBlack,
              ),
            ],
          ),
          spaceH15,
          ...searchController.recentSearches.take(3).map((search) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppPallete.kenicGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const HeroIcon(
                  HeroIcons.magnifyingGlass,
                  size: 18,
                  color: AppPallete.greyColor,
                ),
                title: Inter(
                  text: search,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textColor: AppPallete.kenicBlack,
                ),
                trailing: const HeroIcon(
                  HeroIcons.arrowRight,
                  size: 16,
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
        return 5.00;
      case '.co.ke':
        return 8.50;
      case '.or.ke':
        return 6.00;
      case '.ac.ke':
        return 7.50;
      case '.sc.ke':
        return 6.50;
      case '.go.ke':
        return 10.00;
      case '.ne.ke':
        return 8.00;
      case '.me.ke':
        return 7.00;
      case '.com':
        return 12.99;
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
