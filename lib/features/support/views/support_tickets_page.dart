import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/empty_widget.dart';
import 'package:kenic/features/support/controllers/ticket_controller.dart';
import 'package:kenic/features/support/models/ticket_models.dart';
import 'package:kenic/features/support/views/create_ticket_page.dart';
import 'package:kenic/features/support/views/ticket_detail_page.dart';

class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage>
    with SingleTickerProviderStateMixin {
  final ticketController = Get.put(TicketController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      // Handle tab changes if needed
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
                  decoration: const BoxDecoration(
                    color: AppPallete.kenicWhite,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
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
                                  HeroIcons.chevronLeft,
                                  size: 20,
                                  color: AppPallete.kenicBlack,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Inter(
                                text: 'Support Tickets',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                textColor: AppPallete.kenicBlack,
                                textAlignment: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  () => ticketController.refreshTickets(),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppPallete.kenicWhite,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppPallete.kenicRed,
                    indicatorWeight: 3,
                    labelColor: AppPallete.kenicRed,
                    unselectedLabelColor: AppPallete.greyColor,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(
                              HeroIcons.chatBubbleLeftRight,
                              size: 16,
                            ),
                            spaceW5,
                            const Text('All'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(HeroIcons.clock, size: 16),
                            spaceW5,
                            const Text('Open'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(HeroIcons.checkCircle, size: 16),
                            spaceW5,
                            const Text('Closed'),
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
            _buildTicketsList(ticketType: 'all'),
            _buildTicketsList(ticketType: 'open'),
            _buildTicketsList(ticketType: 'closed'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateTicketPage()),
        backgroundColor: AppPallete.kenicRed,
        child: const HeroIcon(
          HeroIcons.plus,
          color: AppPallete.kenicWhite,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTicketsList({required String ticketType}) {
    return Obx(() {
      if (ticketController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppPallete.kenicRed),
        );
      }

      List<Ticket> tickets;
      switch (ticketType) {
        case 'all':
          tickets = ticketController.tickets;
          break;
        case 'open':
          tickets = ticketController.openTickets;
          break;
        case 'closed':
          tickets = ticketController.closedTickets;
          break;
        default:
          tickets = [];
      }

      if (tickets.isEmpty) {
        return _buildEmptyState(ticketType);
      }

      return RefreshIndicator(
        onRefresh: () async => ticketController.refreshTickets(),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            return _buildTicketCard(ticket);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(String ticketType) {
    String title;
    String description;

    switch (ticketType) {
      case 'all':
        title = 'No support tickets';
        description = 'You haven\'t created any support tickets yet';
        break;
      case 'open':
        title = 'No open tickets';
        description = 'All your support tickets have been resolved';
        break;
      case 'closed':
        title = 'No closed tickets';
        description = 'All your support tickets are still open';
        break;
      default:
        title = 'No tickets found';
        description = 'Start by creating a new support ticket';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyWidget(title: title, description: description),
            spaceH30,
            ElevatedButton(
              onPressed: () => Get.to(() => const CreateTicketPage()),
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
              child: const Text(
                'Create Ticket',
                style: TextStyle(color: AppPallete.kenicWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Get.to(() => TicketDetailPage(ticket: ticket));
            },
            backgroundColor: AppPallete.kenicRed.withOpacity(0.1),
            foregroundColor: AppPallete.kenicRed,
            icon: Icons.visibility,
            label: 'View',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
          ),
          SlidableAction(
            onPressed: (context) {
              _showDeleteTicketDialog(ticket);
            },
            backgroundColor: Colors.red.withOpacity(0.1),
            foregroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
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
                  // Ticket ID and status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppPallete.kenicRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const HeroIcon(
                          HeroIcons.chatBubbleLeftRight,
                          size: 16,
                          color: AppPallete.kenicRed,
                        ),
                      ),
                      spaceW10,
                      Expanded(
                        child: Inter(
                          text: ticket.tid,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppPallete.kenicBlack,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            ticket.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Inter(
                          text: ticket.status,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: _getStatusColor(ticket.status),
                        ),
                      ),
                    ],
                  ),
                  spaceH12,
                  // Subject
                  Inter(
                    text: ticket.subject,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicBlack,
                  ),
                  spaceH10,
                  // Date and priority
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppPallete.greyColor,
                      ),
                      spaceW5,
                      Inter(
                        text: _formatDate(ticket.date),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.greyColor,
                      ),
                      spaceW20,
                      Icon(
                        Icons.priority_high,
                        size: 14,
                        color: _getPriorityColor(ticket.priority),
                      ),
                      spaceW5,
                      Inter(
                        text: ticket.priority,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        textColor: _getPriorityColor(ticket.priority),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      case 'customer-reply':
        return Colors.blue;
      default:
        return AppPallete.greyColor;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return AppPallete.greyColor;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _showDeleteTicketDialog(Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ticket'),
          content: Text(
            'Are you sure you want to delete ticket ${ticket.tid}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ticketController.deleteTicket(ticket.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
