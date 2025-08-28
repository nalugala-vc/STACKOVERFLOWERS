import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';
import 'package:kenic/features/domain_core/models/user_domain.dart';

class DomainSettingsPage extends StatelessWidget {
  final UserDomain domain;

  const DomainSettingsPage({super.key, required this.domain});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DomainController>();

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Domain Settings',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            title: 'Domain Information',
            children: [
              _buildInfoRow('Domain Name', domain.name),
              _buildInfoRow(
                'Expiry Date',
                domain.expiryDate.toString().split(' ')[0],
              ),
              _buildInfoRow(
                'Status',
                domain.isExpired ? 'Expired' : 'Active',
                valueColor: domain.isExpired ? Colors.red : Colors.green,
              ),
            ],
          ),
          spaceH20,
          _buildSection(
            title: 'Nameservers',
            children: [
              ...domain.nameservers.map((ns) => _buildInfoRow('', ns)),
              TextButton(
                onPressed: () {
                  // Show nameserver edit dialog
                  controller.updateNameservers(domain.name, domain.nameservers);
                },
                child: Text('Edit Nameservers'),
              ),
            ],
          ),
          spaceH20,
          _buildSection(
            title: 'Private Nameservers',
            children: [
              if (domain.privateNameservers.isEmpty)
                Inter(
                  text: 'No private nameservers configured',
                  fontSize: 14,
                  textColor: AppPallete.greyColor,
                )
              else
                ...domain.privateNameservers.map((ns) => _buildInfoRow('', ns)),
              TextButton(
                onPressed: () {
                  // Show private nameserver edit dialog
                  controller.updatePrivateNameservers(
                    domain.name,
                    domain.privateNameservers,
                  );
                },
                child: Text('Edit Private Nameservers'),
              ),
            ],
          ),
          spaceH20,
          _buildSection(
            title: 'Security',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Inter(
                  text: 'Registrar Lock',
                  fontSize: 16,
                  textColor: AppPallete.kenicBlack,
                ),
                subtitle: Inter(
                  text: 'Prevent unauthorized domain transfers',
                  fontSize: 14,
                  textColor: AppPallete.greyColor,
                ),
                trailing: Switch(
                  value: domain.registrarLock,
                  onChanged:
                      (value) => controller.toggleRegistrarLock(domain.name),
                  activeColor: AppPallete.kenicRed,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Inter(
                  text: 'EPP Code',
                  fontSize: 16,
                  textColor: AppPallete.kenicBlack,
                ),
                subtitle: Inter(
                  text: 'Get authorization code for domain transfer',
                  fontSize: 14,
                  textColor: AppPallete.greyColor,
                ),
                trailing: IconButton(
                  icon: HeroIcon(
                    HeroIcons.chevronRight,
                    color: AppPallete.kenicBlack,
                  ),
                  onPressed: () => controller.getEppCode(domain.name),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(12),
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
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textColor: AppPallete.kenicBlack,
          ),
          spaceH20,
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (label.isNotEmpty)
            Inter(text: label, fontSize: 14, textColor: AppPallete.greyColor),
          Inter(
            text: value,
            fontSize: 14,
            textColor: valueColor ?? AppPallete.kenicBlack,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
