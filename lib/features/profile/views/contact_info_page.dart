import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  final spaceH8 = const SizedBox(height: 8);
  final spaceH12 = const SizedBox(height: 12);
  final spaceH16 = const SizedBox(height: 16);
  final spaceW8 = const SizedBox(width: 8);
  final spaceW12 = const SizedBox(width: 12);
  final spaceW4 = const SizedBox(width: 4);

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      'Text copied to clipboard',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget _buildContactCard({
    required String title,
    required List<Widget> children,
    Color? borderColor,
    HeroIcons icon = HeroIcons.buildingOffice,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? const Color(0xFFE0E0E0)),
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
          // Header with icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (borderColor ?? AppPallete.kenicRed).withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (borderColor ?? AppPallete.kenicRed).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HeroIcon(
                    icon,
                    size: 24,
                    color: borderColor ?? AppPallete.kenicRed,
                  ),
                ),
                spaceW12,
                Inter(
                  text: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicBlack,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isLink ? AppPallete.kenicRed.withOpacity(0.03) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isLink
                  ? AppPallete.kenicRed.withOpacity(0.1)
                  : Colors.transparent,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppPallete.greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Inter(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              textColor: AppPallete.greyColor,
            ),
          ),
          spaceW12,
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isLink ? AppPallete.kenicRed : AppPallete.kenicBlack,
                  fontFamily: 'Inter',
                  fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          if (onTap != null) ...[
            spaceW8,
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HeroIcon(
                        HeroIcons.clipboard,
                        size: 16,
                        color: AppPallete.kenicRed,
                      ),
                      spaceW4,
                      Inter(
                        text: 'Copy',
                        fontSize: 12,
                        textColor: AppPallete.kenicRed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Contact Information',
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
              // Organization Info
              _buildContactCard(
                title: 'Sponsoring Organization',
                borderColor: AppPallete.kenicRed,
                icon: HeroIcons.buildingOffice2,
                children: [
                  _buildInfoRow(
                    label: 'Organization',
                    value: 'Kenya Network Information Centre (KeNIC)',
                  ),
                  _buildInfoRow(
                    label: 'Address',
                    value:
                        'P.O. Box 1461, Waiyaki Way, CCK Complex\nNairobi 00606, Kenya',
                  ),
                  spaceH12,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => _launchUrl('https://support.marcaria.com'),
                          icon: const HeroIcon(
                            HeroIcons.globeAlt,
                            size: 18,
                            color: AppPallete.kenicRed,
                          ),
                          label: const Text('Marcaria'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPallete.kenicRed,
                            side: const BorderSide(color: AppPallete.kenicRed),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      spaceW12,
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchUrl('https://www.iana.org'),
                          icon: const HeroIcon(
                            HeroIcons.globeAlt,
                            size: 18,
                            color: AppPallete.kenicRed,
                          ),
                          label: const Text('IANA'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPallete.kenicRed,
                            side: const BorderSide(color: AppPallete.kenicRed),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              spaceH20,
              // Administrative Contact
              _buildContactCard(
                title: 'Administrative Contact',
                icon: HeroIcons.userCircle,
                children: [
                  _buildInfoRow(label: 'Name', value: 'Andrew Lewela Mwanyota'),
                  _buildInfoRow(
                    label: 'Email',
                    value: 'admin@kenic.or.ke',
                    isLink: true,
                    onTap: () => _copyToClipboard('admin@kenic.or.ke'),
                  ),
                  _buildInfoRow(
                    label: 'Phone',
                    value:
                        '+254 20 4450059 / +254 20 4450058 / +254 728 518366',
                    isLink: true,
                    onTap: () => _copyToClipboard('+254 20 4450059'),
                  ),
                ],
              ),
              spaceH20,
              // Technical Contact
              _buildContactCard(
                title: 'Technical Contact',
                icon: HeroIcons.wrenchScrewdriver,
                children: [
                  _buildInfoRow(label: 'Name', value: 'Ahmed Landi'),
                  _buildInfoRow(
                    label: 'Email',
                    value: 'tech@kenic.or.ke',
                    isLink: true,
                    onTap: () => _copyToClipboard('tech@kenic.or.ke'),
                  ),
                  _buildInfoRow(
                    label: 'Phone',
                    value:
                        '+254 20 4450059 / +254 20 4450058 / +254 715 275483',
                    isLink: true,
                    onTap: () => _copyToClipboard('+254 20 4450059'),
                  ),
                  _buildInfoRow(label: 'Fax', value: '+254 20 4450087'),
                ],
              ),
              spaceH20,
              // General Enquiries
              _buildContactCard(
                title: 'General Enquiries',
                icon: HeroIcons.chatBubbleLeftRight,
                children: [
                  _buildInfoRow(
                    label: 'Email',
                    value: 'info@kenic.or.ke',
                    isLink: true,
                    onTap: () => _copyToClipboard('info@kenic.or.ke'),
                  ),
                  _buildInfoRow(
                    label: 'Phone',
                    value: '+254 20 4450057 / +254 20 4450058',
                    isLink: true,
                    onTap: () => _copyToClipboard('+254 20 4450057'),
                  ),
                  _buildInfoRow(label: 'Fax', value: '+254 20 4450087'),
                  spaceH12,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => _launchUrl('https://ccnso.icann.org'),
                          icon: const HeroIcon(
                            HeroIcons.globeAlt,
                            size: 18,
                            color: AppPallete.kenicRed,
                          ),
                          label: const Text('ICANN'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPallete.kenicRed,
                            side: const BorderSide(color: AppPallete.kenicRed),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      spaceW12,
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => _launchUrl('https://support.marcaria.com'),
                          icon: const HeroIcon(
                            HeroIcons.globeAlt,
                            size: 18,
                            color: AppPallete.kenicRed,
                          ),
                          label: const Text('Marcaria'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPallete.kenicRed,
                            side: const BorderSide(color: AppPallete.kenicRed),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              spaceH30,
            ],
          ),
        ],
      ),
    );
  }
}
