import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/profile/views/faqs_page.dart';
import 'package:kenic/features/profile/views/ai_chat_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  final spaceW16 = const SizedBox(width: 16);
  final spaceH4 = const SizedBox(height: 4);

  Widget _buildHelpCard({
    required String title,
    required String subtitle,
    required HeroIcons icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HeroIcon(icon, size: 24, color: AppPallete.kenicRed),
                ),
                spaceW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: title,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        textColor: AppPallete.kenicBlack,
                      ),
                      spaceH4,
                      Inter(
                        text: subtitle,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.greyColor,
                      ),
                    ],
                  ),
                ),
                const HeroIcon(
                  HeroIcons.chevronRight,
                  size: 20,
                  color: AppPallete.greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Help Center',
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
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHelpCard(
                title: 'Frequently Asked Questions',
                subtitle: 'Find answers to common questions',
                icon: HeroIcons.questionMarkCircle,
                onTap: () => Get.to(() => const FAQsPage()),
              ),
              _buildHelpCard(
                title: 'Chat with AI',
                subtitle: 'Get instant help from our AI assistant',
                icon: HeroIcons.chatBubbleBottomCenterText,
                onTap: () => Get.to(() => const AIChatPage()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
