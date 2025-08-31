import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/support/controllers/ticket_controller.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final ticketController = Get.find<TicketController>();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Create Support Ticket',
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
      ),
      body: Stack(
        children: [
          // Background design
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.kenicRed.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.kenicRed.withOpacity(0.05),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppPallete.kenicRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const HeroIcon(
                            HeroIcons.chatBubbleLeftRight,
                            size: 32,
                            color: AppPallete.kenicRed,
                          ),
                        ),
                        spaceH20,
                        Inter(
                          text: 'Create Support Ticket',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          textColor: AppPallete.kenicBlack,
                          textAlignment: TextAlign.center,
                        ),
                        spaceH10,
                        Inter(
                          text:
                              'Describe your issue and we\'ll help you resolve it',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          textColor: AppPallete.greyColor,
                          textAlignment: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  spaceH20,
                  // Subject field
                  Inter(
                    text: 'Subject',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicBlack,
                  ),
                  spaceH10,
                  AuthField(
                    controller: subjectController,
                    hintText: 'Enter ticket subject',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Subject is required';
                      }
                      return null;
                    },
                  ),
                  spaceH20,
                  // Message field
                  Inter(
                    text: 'Message',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicBlack,
                  ),
                  spaceH10,
                  Container(
                    decoration: BoxDecoration(
                      color: AppPallete.kenicWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppPallete.kenicGrey.withOpacity(0.2),
                      ),
                    ),
                    child: TextFormField(
                      controller: messageController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Describe your issue in detail...',
                        hintStyle: TextStyle(
                          color: AppPallete.greyColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Message is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Message must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  spaceH30,
                  // Submit button
                  Obx(
                    () => RoundedButton(
                      onPressed:
                          ticketController.isCreatingTicket.value
                              ? () {}
                              : _submitTicket,
                      label: 'Create Ticket',
                      fontsize: 16,
                      backgroundColor: AppPallete.kenicRed,
                      isLoading: ticketController.isCreatingTicket.value,
                    ),
                  ),
                  spaceH20,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      final success = await ticketController.createTicket(
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
      );

      if (success) {
        // Refresh tickets before going back
        await ticketController.refreshTickets();
        Get.back();
      }
    }
  }
}
