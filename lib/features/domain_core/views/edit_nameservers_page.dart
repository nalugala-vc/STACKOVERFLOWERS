import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';

class EditNameserversPage extends StatefulWidget {
  final String domainName;
  final int domainId;
  final List<String> currentNameservers;

  const EditNameserversPage({
    super.key,
    required this.domainName,
    required this.domainId,
    required this.currentNameservers,
  });

  @override
  State<EditNameserversPage> createState() => _EditNameserversPageState();
}

class _EditNameserversPageState extends State<EditNameserversPage> {
  final controller = Get.find<DomainController>();
  bool useCustomNameservers = false;
  final List<TextEditingController> nameserverControllers = [];
  final defaultNameservers = ['ns1.kenic.com', 'ns2.kenic.com'];
  final spaceW12 = const SizedBox(width: 12);
  final spaceH16 = const SizedBox(height: 16);
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    useCustomNameservers = !_isUsingDefaultNameservers();
    // Initialize controllers with current nameservers
    for (int i = 0; i < 5; i++) {
      nameserverControllers.add(
        TextEditingController(
          text:
              i < widget.currentNameservers.length
                  ? widget.currentNameservers[i]
                  : '',
        ),
      );
    }
  }

  bool _isUsingDefaultNameservers() {
    if (widget.currentNameservers.length != defaultNameservers.length)
      return false;
    for (int i = 0; i < defaultNameservers.length; i++) {
      if (widget.currentNameservers[i] != defaultNameservers[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    for (var controller in nameserverControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveNameservers() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      final List<String> nameservers;
      if (useCustomNameservers) {
        nameservers =
            nameserverControllers
                .map((c) => c.text.trim())
                .where((text) => text.isNotEmpty)
                .toList();
        if (nameservers.length < 2) {
          Get.snackbar(
            'Error',
            'At least NS1 and NS2 are required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      } else {
        nameservers = defaultNameservers;
      }

      // Use the new API method
      final success = await controller.updateDomainNameservers(
        domainId: widget.domainId,
        ns1: nameservers[0],
        ns2: nameservers[1],
        ns3: nameservers.length > 2 ? nameservers[2] : null,
        ns4: nameservers.length > 3 ? nameservers[3] : null,
        ns5: nameservers.length > 4 ? nameservers[4] : null,
      );

      if (success) {
        // Show success message in the UI
        Get.snackbar(
          'Success',
          'Nameservers updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Close the page after showing success message
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
      }
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Edit Nameservers',
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
          // Info text at the top
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.kenicWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
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
                    HeroIcons.informationCircle,
                    color: AppPallete.kenicRed,
                    size: 20,
                  ),
                ),
                spaceW12,
                Expanded(
                  child: Inter(
                    text:
                        'Nameserver changes may take up to 48 hours to propagate globally',
                    fontSize: 14,
                    textColor: AppPallete.greyColor,
                  ),
                ),
              ],
            ),
          ),
          spaceH20,
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPallete.kenicWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Inter(
                  text: 'Nameserver Configuration',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: AppPallete.kenicBlack,
                ),
                spaceH20,
                // Option Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        !useCustomNameservers
                            ? const Color(0xFFF5F5F5)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          !useCustomNameservers
                              ? AppPallete.kenicRed
                              : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: useCustomNameservers,
                            onChanged: (value) {
                              setState(() {
                                useCustomNameservers = value!;
                              });
                            },
                            activeColor: AppPallete.kenicRed,
                          ),
                          Expanded(
                            child: Inter(
                              text: 'Use Default Nameservers',
                              fontSize: 16,
                              fontWeight:
                                  !useCustomNameservers
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              textColor: AppPallete.kenicBlack,
                            ),
                          ),
                        ],
                      ),
                      if (!useCustomNameservers) ...[
                        spaceH10,
                        ...defaultNameservers.map(
                          (ns) => Padding(
                            padding: const EdgeInsets.only(left: 40, bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppPallete.kenicRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const HeroIcon(
                                    HeroIcons.serverStack,
                                    size: 14,
                                    color: AppPallete.kenicRed,
                                  ),
                                ),
                                spaceW10,
                                Inter(
                                  text: ns,
                                  fontSize: 14,
                                  textColor: AppPallete.kenicBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                spaceH16,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        useCustomNameservers
                            ? const Color(0xFFF5F5F5)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          useCustomNameservers
                              ? AppPallete.kenicRed
                              : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: useCustomNameservers,
                            onChanged: (value) {
                              setState(() {
                                useCustomNameservers = value!;
                              });
                            },
                            activeColor: AppPallete.kenicRed,
                          ),
                          Expanded(
                            child: Inter(
                              text: 'Use Custom Nameservers',
                              fontSize: 16,
                              fontWeight:
                                  useCustomNameservers
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              textColor: AppPallete.kenicBlack,
                            ),
                          ),
                        ],
                      ),
                      if (useCustomNameservers) ...[
                        spaceH16,
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextFormField(
                              controller: nameserverControllers[index],
                              decoration: InputDecoration(
                                hintText: 'Nameserver ${index + 1}',
                                hintStyle: const TextStyle(
                                  color: AppPallete.greyColor,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppPallete.kenicRed,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: const HeroIcon(
                                    HeroIcons.serverStack,
                                    size: 20,
                                    color: AppPallete.greyColor,
                                  ),
                                ),
                              ),
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
          spaceH20,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppPallete.kenicRed.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveNameservers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.kenicRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    isSaving
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Inter(
                          text: 'Save Changes',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
