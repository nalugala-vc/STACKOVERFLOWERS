import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/support/controllers/ticket_controller.dart';
import 'package:kenic/features/support/models/ticket_models.dart';

class TicketDetailPage extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailPage({super.key, required this.ticket});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final ticketController = Get.find<TicketController>();
  final TextEditingController replyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load the full ticket details
    ticketController.getTicket(widget.ticket.id);
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Ticket ${widget.ticket.tid}',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: AppPallete.kenicBlack,
        ),
        backgroundColor: AppPallete.kenicWhite,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(HeroIcons.chevronLeft, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (widget.ticket.status.toLowerCase() != 'closed')
            IconButton(
              icon: HeroIcon(
                HeroIcons.checkCircle,
                color: AppPallete.kenicBlack,
              ),
              onPressed: () => _showCloseTicketDialog(),
            ),
        ],
      ),
      body: Obx(() {
        final ticket = ticketController.selectedTicket.value ?? widget.ticket;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket header
              _buildTicketHeader(ticket),
              spaceH20,
              // Ticket details
              _buildTicketDetails(ticket),
              spaceH20,
              // Replies section
              _buildRepliesSection(ticket),
              spaceH20,
              // Reply form (only if ticket is not closed)
              if (ticket.status.toLowerCase() != 'closed') _buildReplyForm(),
              spaceH20,
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTicketHeader(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  color: AppPallete.kenicRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const HeroIcon(
                  HeroIcons.chatBubbleLeftRight,
                  size: 24,
                  color: AppPallete.kenicRed,
                ),
              ),
              spaceW15,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: ticket.tid,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      textColor: AppPallete.kenicBlack,
                    ),
                    Inter(
                      text: ticket.subject,
                      fontSize: 16,
                      textAlignment: TextAlign.left,
                      fontWeight: FontWeight.w600,
                      textColor: AppPallete.kenicBlack,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Inter(
                  text: ticket.status,
                  fontSize: 12,
                  textAlignment: TextAlign.left,
                  fontWeight: FontWeight.w600,
                  textColor: _getStatusColor(ticket.status),
                ),
              ),
            ],
          ),
          spaceH15,
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppPallete.greyColor),
              spaceW5,
              Inter(
                text: _formatDate(ticket.date),
                fontSize: 14,
                textAlignment: TextAlign.left,
                fontWeight: FontWeight.normal,
                textColor: AppPallete.greyColor,
              ),
              spaceW20,
              Icon(
                Icons.priority_high,
                size: 16,
                color: _getPriorityColor(ticket.priority),
              ),
              spaceW5,
              Inter(
                text: ticket.priority,
                textAlignment: TextAlign.left,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                textColor: _getPriorityColor(ticket.priority),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Inter(
            text: 'Ticket Details',
            fontSize: 18,
            textAlignment: TextAlign.left,
            fontWeight: FontWeight.bold,
            textColor: AppPallete.kenicBlack,
          ),
          spaceH15,
          _buildDetailRow('Department', ticket.deptname),
          _buildDetailRow('Created by', ticket.name),
          _buildDetailRow('Email', ticket.email),
          _buildDetailRow('Last Reply', _formatDate(ticket.lastreply)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Inter(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textAlignment: TextAlign.left,
              textColor: AppPallete.greyColor,
            ),
          ),
          Expanded(
            child: Inter(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              textAlignment: TextAlign.left,
              textColor: AppPallete.kenicBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepliesSection(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Inter(
            text: 'Conversation',
            fontSize: 18,
            textAlignment: TextAlign.left,
            fontWeight: FontWeight.bold,
            textColor: AppPallete.kenicBlack,
          ),
          spaceH15,
          // Show the original ticket message first
          _buildReplyItem(
            TicketReply(
              replyid: '0',
              userid: ticket.userid,
              contactid: ticket.contactid,
              name: ticket.name,
              email: ticket.email,
              requestorName: ticket.requestorName,
              requestorEmail: ticket.requestorEmail,
              requestorType: ticket.requestorType,
              date: ticket.date,
              message: ticket.subject, // Use subject as initial message
              attachment: ticket.attachment,
              attachments: ticket.attachments,
              attachmentsRemoved: ticket.attachmentsRemoved,
              admin: ticket.admin,
            ),
          ),
          // Show additional replies if available
          if (ticket.replies != null && ticket.replies!.isNotEmpty)
            ...ticket.replies!.map((reply) => _buildReplyItem(reply)),
        ],
      ),
    );
  }

  Widget _buildReplyItem(TicketReply reply) {
    final isAdmin = reply.admin.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isAdmin
                ? AppPallete.kenicRed.withOpacity(0.05)
                : AppPallete.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isAdmin
                  ? AppPallete.kenicRed.withOpacity(0.2)
                  : AppPallete.kenicGrey.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isAdmin
                          ? AppPallete.kenicRed.withOpacity(0.1)
                          : AppPallete.kenicGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: HeroIcon(
                  isAdmin ? HeroIcons.userGroup : HeroIcons.user,
                  size: 16,
                  color: isAdmin ? AppPallete.kenicRed : AppPallete.kenicBlack,
                ),
              ),
              spaceW10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inter(
                      text: reply.name,
                      fontSize: 14,
                      textAlignment: TextAlign.left,
                      fontWeight: FontWeight.w600,
                      textColor: AppPallete.kenicBlack,
                    ),
                    Inter(
                      text: _formatDate(reply.date),
                      fontSize: 12,
                      textAlignment: TextAlign.left,
                      fontWeight: FontWeight.normal,
                      textColor: AppPallete.greyColor,
                    ),
                  ],
                ),
              ),
              if (isAdmin)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Inter(
                    text: 'Support',
                    textAlignment: TextAlign.left,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicRed,
                  ),
                ),
            ],
          ),
          spaceH12,
          Inter(
            text: reply.message,
            fontSize: 14,
            textAlignment: TextAlign.left,
            fontWeight: FontWeight.normal,
            textColor: AppPallete.kenicBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildReplyForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Inter(
              text: 'Add Reply',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textColor: AppPallete.kenicBlack,
            ),
            spaceH15,
            Container(
              decoration: BoxDecoration(
                color: AppPallete.scaffoldBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppPallete.kenicGrey.withOpacity(0.2),
                ),
              ),
              child: TextFormField(
                controller: replyController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Type your reply...',
                  hintStyle: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Reply message is required';
                  }
                  if (value.trim().length < 5) {
                    return 'Reply must be at least 5 characters';
                  }
                  return null;
                },
              ),
            ),
            spaceH15,
            Obx(
              () => RoundedButton(
                onPressed:
                    ticketController.isReplying.value ? () {} : _submitReply,
                label: 'Send Reply',
                fontsize: 16,
                backgroundColor: AppPallete.kenicRed,
                isLoading: ticketController.isReplying.value,
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
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _submitReply() async {
    if (_formKey.currentState!.validate()) {
      final success = await ticketController.replyToTicket(
        ticketId: widget.ticket.id,
        message: replyController.text.trim(),
      );

      if (success) {
        replyController.clear();
        // Wait a moment for the API to process, then refresh
        await Future.delayed(const Duration(milliseconds: 500));
        await ticketController.getTicket(widget.ticket.id);
      }
    }
  }

  void _showCloseTicketDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Close Ticket'),
          content: Text(
            'Are you sure you want to close ticket ${widget.ticket.tid}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ticketController.closeTicket(widget.ticket.id);
              },
              style: TextButton.styleFrom(foregroundColor: AppPallete.kenicRed),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
