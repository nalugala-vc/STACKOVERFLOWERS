import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/country_dropdown.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/features/profile/controllers/personal_information_controller.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  late PersonalInformationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PersonalInformationController>();
    // Refresh form data when page is visited to ensure latest data is loaded
    controller.refreshFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
      appBar: AppBar(
        backgroundColor: AppPallete.kenicWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
        title: Inter(
          text: 'Personal Information',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textColor: AppPallete.kenicBlack,
        ),
        centerTitle: true,
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              spaceH20,
              _buildBasicInfoSection(controller),
              spaceH30,
              _buildSectionTitle('Address Information'),
              spaceH20,
              _buildAddressSection(controller),
              spaceH30,
              _buildSectionTitle('Company Information (Optional)'),
              spaceH20,
              _buildCompanySection(controller),
              spaceH40,
              _buildUpdateButton(controller),
              spaceH20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Inter(
      text: title,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      textColor: AppPallete.kenicBlack,
    );
  }

  Widget _buildBasicInfoSection(PersonalInformationController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AuthField(
                  hintText: 'First Name',
                  controller: controller.firstNameController,
                ),
              ),
              spaceW15,
              Expanded(
                child: AuthField(
                  hintText: 'Last Name',
                  controller: controller.lastNameController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(PersonalInformationController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          AuthField(
            hintText: 'Address Line 1',
            controller: controller.address1Controller,
          ),
          spaceH15,
          Row(
            children: [
              Expanded(
                child: AuthField(
                  hintText: 'City',
                  controller: controller.cityController,
                ),
              ),
              spaceW15,
              Expanded(
                child: AuthField(
                  hintText: 'State/Province',
                  controller: controller.stateController,
                ),
              ),
            ],
          ),
          spaceH15,
          Row(
            children: [
              Expanded(
                child: AuthField(
                  hintText: 'Postal Code',
                  controller: controller.postcodeController,
                ),
              ),
              spaceW15,
              Expanded(
                child: Obx(
                  () => CountryDropdown(
                    selectedCountry: controller.selectedCountry.value,
                    onChanged: controller.setCountry,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySection(PersonalInformationController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.kenicWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Inter(
                  text: 'Include Company Information',
                  fontSize: 14,
                  textColor: AppPallete.kenicBlack,
                ),
              ),
              Obx(
                () => Switch(
                  value: controller.isCompanyNameVisible.value,
                  onChanged: (value) => controller.toggleCompanyName(),
                  activeColor: AppPallete.kenicRed,
                ),
              ),
            ],
          ),
          Obx(
            () =>
                controller.isCompanyNameVisible.value
                    ? Column(
                      children: [
                        spaceH15,
                        AuthField(
                          hintText: 'Company Name',
                          controller: controller.companyNameController,
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(PersonalInformationController controller) {
    return Column(
      children: [
        Obx(
          () =>
              controller.errorMessage.value.isNotEmpty
                  ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Inter(
                      text: controller.errorMessage.value,
                      fontSize: 14,
                      textColor: Colors.red,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
        SizedBox(
          width: double.infinity,
          child: RoundedButton(
            onPressed: () => _handleUpdate(controller),
            label: 'Update Information',
            isLoading: controller.isLoading.value,
            fontsize: 16,
          ),
        ),
      ],
    );
  }

  Future<void> _handleUpdate(PersonalInformationController controller) async {
    final result = await controller.updateUserDetails();

    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (success) {
        Get.snackbar(
          'Success',
          success,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate back after successful update
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      },
    );
  }
}
