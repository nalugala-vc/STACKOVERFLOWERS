import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';
import 'package:kenic/features/domain_core/models/user_domain.dart';
import 'package:kenic/features/domain_core/views/edit_nameservers_page.dart';
import 'package:kenic/features/domain_core/views/register_nameservers_page.dart';
import 'package:kenic/core/utils/widgets/custom_dialogs.dart';
import 'package:kenic/core/utils/widgets/ai_info_bottom_sheet.dart';

class DomainSettingsPage extends StatefulWidget {
  final UserDomain domain;

  const DomainSettingsPage({super.key, required this.domain});

  @override
  State<DomainSettingsPage> createState() => _DomainSettingsPageState();
}

class _DomainSettingsPageState extends State<DomainSettingsPage> {
  late DomainController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DomainController>();
    // Fetch nameservers when page loads
    controller.fetchDomainNameservers(widget.domain.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: widget.domain.domainName,
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
          // Domain Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.domain.isExpired
                      ? const Color(0xFFE57373)
                      : const Color(0xFF81C784),
                  widget.domain.isExpired
                      ? const Color(0xFFEF5350)
                      : const Color(0xFF66BB6A),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: HeroIcon(
                        widget.domain.isExpired
                            ? HeroIcons.exclamationTriangle
                            : HeroIcons.checkCircle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    spaceW15,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Inter(
                            text:
                                widget.domain.isExpired ? 'Expired' : 'Active',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.white,
                          ),
                          Inter(
                            text:
                                widget.domain.isExpired
                                    ? 'Domain needs renewal'
                                    : 'Domain is active and working',
                            fontSize: 14,
                            textColor: Colors.white.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                spaceH20,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildStatusRow(
                        'Purchased',
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(widget.domain.purchaseDate),
                        textColor: Colors.white,
                      ),
                      const Divider(height: 16, color: Colors.white24),
                      _buildStatusRow(
                        'Next Due',
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(widget.domain.nextDueDate),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                if (widget.domain.isExpired) ...[
                  spaceH20,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          '/checkout',
                          arguments: {
                            'amount': widget.domain.renewalPrice,
                            'isRenewal': true,
                            'domain': widget.domain.domainName,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Renew Now - \$${widget.domain.renewalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          spaceH20,
          // Nameservers Section
          _buildSection(
            title: 'Nameservers',
            icon: HeroIcons.serverStack,
            showInfoIcon: true,
            onInfoTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder:
                    (context) => AIInfoBottomSheet(
                      title: 'Nameservers',
                      initialQuestion: 'What is a nameserver?',
                      domainContext:
                          'Domain: ${widget.domain.domainName}. Nameservers are DNS servers that translate domain names to IP addresses.',
                    ),
              );
            },
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.kenicWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() {
                  final nameservers = controller.getNameservers(
                    widget.domain.id,
                  );

                  if (controller.isLoadingNameservers.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppPallete.kenicRed,
                      ),
                    );
                  }

                  if (nameservers.isEmpty) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPallete.kenicGrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const HeroIcon(
                            HeroIcons.serverStack,
                            size: 40,
                            color: AppPallete.greyColor,
                          ),
                        ),
                        spaceH10,
                        Inter(
                          text: 'No nameservers found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppPallete.greyColor,
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      ...nameservers.map(
                        (ns) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppPallete.kenicRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const HeroIcon(
                                  HeroIcons.serverStack,
                                  size: 16,
                                  color: AppPallete.kenicRed,
                                ),
                              ),
                              spaceW10,
                              Expanded(
                                child: Inter(
                                  text: ns,
                                  fontSize: 14,
                                  textAlignment: TextAlign.left,
                                  textColor: AppPallete.kenicBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceH10,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => EditNameserversPage(
                                domainName: widget.domain.domainName,
                                domainId: widget.domain.id,
                                currentNameservers: nameservers,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.kenicWhite,
                            foregroundColor: AppPallete.kenicRed,
                            elevation: 0,
                            side: const BorderSide(
                              color: AppPallete.kenicRed,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Edit Nameservers'),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          spaceH20,
          // Private Nameservers Section
          _buildSection(
            title: 'Private Nameservers',
            icon: HeroIcons.lockClosed,
            showInfoIcon: true,
            onInfoTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder:
                    (context) => AIInfoBottomSheet(
                      title: 'Private Nameservers',
                      initialQuestion: 'What is a private nameserver?',
                      domainContext:
                          'Domain: ${widget.domain.domainName}. Private nameservers are custom DNS servers that you control.',
                    ),
              );
            },
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.kenicWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.domain.privateNameservers.isEmpty)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const HeroIcon(
                              HeroIcons.exclamationTriangle,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ),
                          spaceW10,
                          Inter(
                            text: 'No private nameservers configured',
                            fontSize: 14,
                            textColor: AppPallete.greyColor,
                          ),
                        ],
                      )
                    else
                      ...widget.domain.privateNameservers.map(
                        (ns) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppPallete.kenicRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const HeroIcon(
                                  HeroIcons.lockClosed,
                                  size: 16,
                                  color: AppPallete.kenicRed,
                                ),
                              ),
                              spaceW10,
                              Expanded(
                                child: Inter(
                                  text: ns,
                                  fontSize: 14,
                                  textColor: AppPallete.kenicBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    spaceH10,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(
                            () => RegisterNameserversPage(
                              domainName: widget.domain.domainName,
                              currentNameservers:
                                  widget.domain.privateNameservers,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.kenicWhite,
                          foregroundColor: AppPallete.kenicRed,
                          elevation: 0,
                          side: const BorderSide(
                            color: AppPallete.kenicRed,
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Edit Private Nameservers'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          spaceH20,
          // Security Section
          _buildSection(
            title: 'Security',
            icon: HeroIcons.shieldCheck,
            showInfoIcon: true,
            onInfoTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder:
                    (context) => AIInfoBottomSheet(
                      title: 'Domain Security',
                      initialQuestion: 'What is a registrar lock and EPP code?',
                      domainContext:
                          'Domain: ${widget.domain.domainName}. These are security features to protect your domain from unauthorized transfers.',
                    ),
              );
            },
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.kenicWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Registrar Lock
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppPallete.kenicGrey.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppPallete.kenicRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const HeroIcon(
                              HeroIcons.lockClosed,
                              size: 20,
                              color: AppPallete.kenicRed,
                            ),
                          ),
                          spaceW15,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Inter(
                                      text: 'Registrar Lock',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textAlignment: TextAlign.left,
                                      textColor: AppPallete.kenicBlack,
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder:
                                              (context) => AIInfoBottomSheet(
                                                title: 'Registrar Lock',
                                                initialQuestion:
                                                    'What is a registrar lock?',
                                                domainContext:
                                                    'Domain: ${widget.domain.domainName}. A registrar lock prevents unauthorized domain transfers.',
                                              ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppPallete.kenicRed
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const HeroIcon(
                                          HeroIcons.informationCircle,
                                          size: 14,
                                          color: AppPallete.kenicRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Inter(
                                  text: 'Prevent unauthorized domain transfers',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  textAlignment: TextAlign.left,
                                  textColor: AppPallete.greyColor,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: widget.domain.registrarLock,
                            onChanged:
                                (value) => controller.toggleRegistrarLock(
                                  widget.domain.domainName,
                                ),
                            activeColor: AppPallete.kenicRed,
                          ),
                        ],
                      ),
                    ),
                    spaceH12,
                    // EPP Code
                    InkWell(
                      onTap: () async {
                        final eppCode = await controller.fetchDomainEppCode(
                          widget.domain.id,
                        );
                        if (eppCode != null) {
                          CustomDialogs.showEppCodeDialog(context, eppCode);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppPallete.kenicWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppPallete.kenicGrey.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppPallete.kenicRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const HeroIcon(
                                HeroIcons.key,
                                size: 20,
                                color: AppPallete.kenicRed,
                              ),
                            ),
                            spaceW15,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Inter(
                                        text: 'EPP Code',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppPallete.kenicBlack,
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder:
                                                (context) => AIInfoBottomSheet(
                                                  title: 'EPP Code',
                                                  initialQuestion:
                                                      'What is an EPP code?',
                                                  domainContext:
                                                      'Domain: ${widget.domain.domainName}. An EPP code is an authorization code required for domain transfers.',
                                                ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppPallete.kenicRed
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const HeroIcon(
                                            HeroIcons.informationCircle,
                                            size: 14,
                                            color: AppPallete.kenicRed,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Inter(
                                    text:
                                        'Get authorization code for domain transfer',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    textAlignment: TextAlign.left,
                                    textColor: AppPallete.greyColor,
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              if (controller.isLoadingEppCode.value) {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppPallete.kenicRed,
                                  ),
                                );
                              }
                              return const HeroIcon(
                                HeroIcons.chevronRight,
                                size: 20,
                                color: AppPallete.kenicBlack,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          spaceH30,
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required HeroIcons icon,
    required List<Widget> children,
    bool showInfoIcon = false,
    VoidCallback? onInfoTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPallete.kenicRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HeroIcon(icon, size: 16, color: AppPallete.kenicRed),
                ),
                spaceW10,
                Expanded(
                  child: Inter(
                    text: title,
                    fontSize: 18,
                    textAlignment: TextAlign.left,
                    fontWeight: FontWeight.w600,
                    textColor: AppPallete.kenicBlack,
                  ),
                ),
                if (showInfoIcon && onInfoTap != null)
                  InkWell(
                    onTap: onInfoTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppPallete.kenicRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const HeroIcon(
                        HeroIcons.informationCircle,
                        size: 18,
                        color: AppPallete.kenicRed,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ...List.generate(children.length * 2 - 1, (index) {
            if (index.isEven) {
              return children[index ~/ 2];
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  color: Color(0xFFE0E0E0),
                  thickness: 1,
                  height: 1,
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    String label,
    String value, {
    required Color textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Inter(text: label, fontSize: 14, textColor: textColor.withOpacity(0.8)),
        Inter(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: textColor,
        ),
      ],
    );
  }
}
