import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';
import 'package:kenic/features/domain_core/models/user_domain.dart';
import 'package:kenic/features/domain_core/views/domain_settings_page.dart';

class MyDomainsPage extends StatefulWidget {
  const MyDomainsPage({super.key});

  @override
  State<MyDomainsPage> createState() => _MyDomainsPageState();
}

class _MyDomainsPageState extends State<MyDomainsPage>
    with SingleTickerProviderStateMixin {
  final domainController = Get.put(DomainController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      domainController.switchTab(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppPallete.kenicWhite,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppPallete.kenicRed.withOpacity(0.05),
                        AppPallete.kenicWhite,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppPallete.kenicRed,
                                      AppPallete.kenicRed.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const HeroIcon(
                                  HeroIcons.globeAlt,
                                  size: 24,
                                  color: AppPallete.kenicWhite,
                                ),
                              ),
                              spaceW15,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Inter(
                                      text: 'My Domains',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      textColor: AppPallete.kenicBlack,
                                    ),
                                    Inter(
                                      text: 'Manage your domain portfolio',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      textColor: AppPallete.greyColor,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () => domainController.refreshDomains(),
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
                                    HeroIcons.arrowPath,
                                    size: 20,
                                    color: AppPallete.kenicBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceH20,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: AppPallete.kenicRed,
                        width: 2.0,
                      ),
                    ),
                    labelColor: AppPallete.kenicRed,
                    unselectedLabelColor: AppPallete.greyColor,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(HeroIcons.checkCircle, size: 16),
                            spaceW5,
                            const Text('Active'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(
                              HeroIcons.exclamationTriangle,
                              size: 16,
                            ),
                            spaceW5,
                            const Text('Expired'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDomainsList(isExpired: false),
            _buildDomainsList(isExpired: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainsList({required bool isExpired}) {
    return Obx(() {
      if (domainController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppPallete.kenicRed),
        );
      }

      final domains =
          isExpired
              ? domainController.expiredDomains
              : domainController.activeDomains;

      if (domains.isEmpty) {
        return _buildEmptyState(isExpired);
      }

      return RefreshIndicator(
        onRefresh: () async => domainController.refreshDomains(),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: domains.length,
          itemBuilder: (context, index) {
            final domain = domains[index];
            return _buildDomainCard(domain);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(bool isExpired) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPallete.kenicGrey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: HeroIcon(
                isExpired
                    ? HeroIcons.exclamationTriangle
                    : HeroIcons.checkCircle,
                size: 60,
                color: AppPallete.greyColor,
              ),
            ),
            spaceH20,
            Inter(
              text: isExpired ? 'No expired domains' : 'No active domains',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              textColor: AppPallete.kenicBlack,
            ),
            spaceH10,
            Inter(
              text:
                  isExpired
                      ? 'All your domains are active'
                      : 'You haven\'t registered any domains yet',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.center,
            ),
            spaceH30,
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.kenicRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Search Domains'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainCard(UserDomain domain) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Get.to(() => DomainSettingsPage(domain: domain));
            },
            backgroundColor: AppPallete.kenicRed.withOpacity(0.1),
            foregroundColor: AppPallete.kenicRed,
            icon: Icons.settings,
            label: 'Settings',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppPallete.kenicWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPallete.kenicGrey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Domain name and icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppPallete.kenicRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const HeroIcon(
                          HeroIcons.globeAlt,
                          size: 16,
                          color: AppPallete.kenicRed,
                        ),
                      ),
                      spaceW10,
                      Expanded(
                        child: Inter(
                          text: domain.name,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppPallete.kenicBlack,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              domain.isExpired
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HeroIcon(
                              domain.isExpired
                                  ? HeroIcons.exclamationTriangle
                                  : HeroIcons.checkCircle,
                              size: 14,
                              color:
                                  domain.isExpired ? Colors.red : Colors.green,
                            ),
                            spaceW5,
                            Inter(
                              text: domain.isExpired ? 'Expired' : 'Active',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              textColor:
                                  domain.isExpired ? Colors.red : Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH12,
                  // Dates and info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppPallete.kenicGrey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Purchased',
                          DateFormat(
                            'MMM dd, yyyy',
                          ).format(domain.purchaseDate),
                        ),
                        const Divider(height: 16),
                        _buildInfoRow(
                          'Expires',
                          DateFormat('MMM dd, yyyy').format(domain.expiryDate),
                          valueColor: domain.isExpired ? Colors.red : null,
                        ),
                      ],
                    ),
                  ),
                  if (domain.isExpired) ...[
                    spaceH12,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            '/checkout',
                            arguments: {
                              'amount': domain.renewalPrice,
                              'isRenewal': true,
                              'domain': domain.name,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.kenicRed,
                          foregroundColor: AppPallete.kenicWhite,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Renew Now - \$${domain.renewalPrice.toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Inter(text: label, fontSize: 14, textColor: AppPallete.greyColor),
        Inter(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: valueColor ?? AppPallete.kenicBlack,
        ),
      ],
    );
  }
}
