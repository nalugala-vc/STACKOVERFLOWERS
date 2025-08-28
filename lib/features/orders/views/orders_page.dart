import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/orders/controllers/orders_controller.dart';
import 'package:kenic/features/orders/models/models.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final ordersController = Get.put(OrdersController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      ordersController.switchTab(_tabController.index);
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
                                  HeroIcons.clipboardDocumentList,
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
                                      text: 'My Orders',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      textColor: AppPallete.kenicBlack,
                                    ),

                                    Inter(
                                      text: 'Track your domain orders',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      textColor: AppPallete.greyColor,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () => ordersController.refreshOrders(),
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
                            const HeroIcon(
                              HeroIcons.exclamationTriangle,
                              size: 16,
                            ),
                            spaceW5,
                            const Text('Unpaid'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(HeroIcons.checkCircle, size: 16),
                            spaceW5,
                            const Text('Paid'),
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
            _buildOrdersList(isUnpaidTab: true),
            _buildOrdersList(isUnpaidTab: false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList({required bool isUnpaidTab}) {
    return Obx(() {
      if (ordersController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppPallete.kenicRed),
        );
      }

      final orders =
          isUnpaidTab
              ? ordersController.unpaidOrders
              : ordersController.paidOrders;

      if (orders.isEmpty) {
        return _buildEmptyState(isUnpaidTab);
      }

      return RefreshIndicator(
        onRefresh: () => ordersController.refreshOrders(),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount:
              orders.length + (ordersController.isPaginating.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == orders.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: AppPallete.kenicRed),
                ),
              );
            }

            final order = orders[index];
            return _buildOrderCard(order);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(bool isUnpaidTab) {
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
                isUnpaidTab
                    ? HeroIcons.exclamationTriangle
                    : HeroIcons.checkCircle,
                size: 60,
                color: AppPallete.greyColor,
              ),
            ),
            spaceH20,
            Inter(
              text: isUnpaidTab ? 'No unpaid orders' : 'No paid orders',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              textColor: AppPallete.kenicBlack,
            ),
            spaceH10,
            Inter(
              text:
                  isUnpaidTab
                      ? 'All your orders are paid and active'
                      : 'You haven\'t completed any payments yet',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              textColor: AppPallete.greyColor,
              textAlignment: TextAlign.center,
            ),
            spaceH30,
            RoundedButton(
              onPressed: () => Get.offAllNamed('/main'),
              label: 'Browse Domains',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    final statusColor = ordersController.getStatusColor(order.status);

    return GestureDetector(
      onTap: () => ordersController.payOrder(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppPallete.kenicWhite,
          borderRadius: BorderRadius.circular(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Order ID, Status and Pay button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Order #${order.id}',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: AppPallete.kenicBlack,
                      ),
                      spaceH5,
                      Inter(
                        text: ordersController.formatDateWithTime(
                          order.createdAt,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.greyColor,
                      ),
                    ],
                  ),
                ),
                if (order.isPendingPayment)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppPallete.kenicRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HeroIcon(
                          HeroIcons.creditCard,
                          size: 14,
                          color: AppPallete.kenicRed,
                        ),
                        spaceW5,
                        Inter(
                          text: 'Pay Now',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor: AppPallete.kenicRed,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            spaceH12,

            // Status and Price
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeroIcon(
                        order.isPaid ? HeroIcons.checkCircle : HeroIcons.clock,
                        size: 14,
                        color: statusColor,
                      ),
                      spaceW5,
                      Inter(
                        text: order.status.displayName,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: statusColor,
                      ),
                    ],
                  ),
                ),
                spaceW10,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HeroIcon(
                        HeroIcons.globeAlt,
                        size: 14,
                        color: AppPallete.kenicRed,
                      ),
                      spaceW5,
                      Inter(
                        text:
                            '${order.items.length} ${order.items.length == 1 ? 'domain' : 'domains'}',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppPallete.kenicBlack,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Inter(
                  text: ordersController.formatCurrency(
                    order.totalAmount,
                    order.currency,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textColor: AppPallete.kenicRed,
                ),
              ],
            ),
            spaceH12,

            // Domain items
            ...order.items.map((item) => _buildDomainItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainItem(OrderDomainItem item) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const HeroIcon(
            HeroIcons.globeAlt,
            size: 16,
            color: AppPallete.kenicRed,
          ),
          spaceW10,
          Expanded(
            child: Inter(
              text: item.domainName,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppPallete.kenicBlack,
            ),
          ),
          Inter(
            text: ordersController.formatCurrency(item.price, item.currency),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppPallete.greyColor,
          ),
        ],
      ),
    );
  }
}
