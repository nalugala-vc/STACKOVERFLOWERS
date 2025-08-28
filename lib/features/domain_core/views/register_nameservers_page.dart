import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/domain_core/controllers/domain_controller.dart';

class RegisterNameserversPage extends StatefulWidget {
  final String domainName;
  final List<String> currentNameservers;

  const RegisterNameserversPage({
    super.key,
    required this.domainName,
    required this.currentNameservers,
  });

  @override
  State<RegisterNameserversPage> createState() =>
      _RegisterNameserversPageState();
}

class _RegisterNameserversPageState extends State<RegisterNameserversPage> {
  final controller = Get.find<DomainController>();
  final spaceH8 = const SizedBox(height: 8);
  final spaceH16 = const SizedBox(height: 16);

  // Controllers for Register section
  final nameserverController = TextEditingController();
  final ipAddressController = TextEditingController();

  // Controllers for Modify section
  final modifyNameserverController = TextEditingController();
  final currentIpController = TextEditingController();
  final newIpController = TextEditingController();

  // Controller for Delete section
  final deleteNameserverController = TextEditingController();

  @override
  void dispose() {
    nameserverController.dispose();
    ipAddressController.dispose();
    modifyNameserverController.dispose();
    currentIpController.dispose();
    newIpController.dispose();
    deleteNameserverController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Inter(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: AppPallete.kenicBlack,
        ),
        spaceH8,
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppPallete.greyColor,
              fontSize: 14,
            ),
            filled: true,
            fillColor: readOnly ? const Color(0xFFF5F5F5) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppPallete.kenicRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton({required VoidCallback onPressed}) {
    return Container(
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
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.kenicRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Inter(
            text: 'Save Changes',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBg,
      appBar: AppBar(
        title: Inter(
          text: 'Register Nameservers',
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
          // Register Section
          _buildSection(
            title: 'Register a Nameserver',
            children: [
              _buildInputField(
                label: 'Nameserver',
                hint: 'Enter nameserver (e.g., ns1.example.com)',
                controller: nameserverController,
              ),
              spaceH16,
              _buildInputField(
                label: 'IP Address',
                hint: 'Enter IP address',
                controller: ipAddressController,
              ),
              spaceH20,
              _buildSaveButton(
                onPressed: () {
                  // Handle register nameserver
                  if (nameserverController.text.isEmpty ||
                      ipAddressController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill in all fields',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  // Call your register function here
                },
              ),
            ],
          ),
          spaceH20,
          // Modify Section
          _buildSection(
            title: 'Modify a Nameserver IP',
            children: [
              _buildInputField(
                label: 'Nameserver',
                hint: 'Enter nameserver',
                controller: modifyNameserverController,
              ),
              spaceH16,
              _buildInputField(
                label: 'Current IP Address',
                hint: 'Current IP will be shown here',
                controller: currentIpController,
                readOnly: true,
              ),
              spaceH16,
              _buildInputField(
                label: 'New IP Address',
                hint: 'Enter new IP address',
                controller: newIpController,
              ),
              spaceH20,
              _buildSaveButton(
                onPressed: () {
                  // Handle modify nameserver
                  if (modifyNameserverController.text.isEmpty ||
                      newIpController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill in all fields',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  // Call your modify function here
                },
              ),
            ],
          ),
          spaceH20,
          // Delete Section
          _buildSection(
            title: 'Delete a Nameserver',
            children: [
              _buildInputField(
                label: 'Nameserver',
                hint: 'Enter nameserver to delete',
                controller: deleteNameserverController,
              ),
              spaceH20,
              _buildSaveButton(
                onPressed: () {
                  // Handle delete nameserver
                  if (deleteNameserverController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter a nameserver',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  // Call your delete function here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
