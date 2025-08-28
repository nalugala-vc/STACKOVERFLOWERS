import 'package:get/get.dart';
import 'package:kenic/core/utils/widgets/custom_dialogs.dart';
import 'package:kenic/features/domain_core/models/user_domain.dart';

class DomainController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<UserDomain> domains = <UserDomain>[].obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDomains();
  }

  void fetchDomains() {
    isLoading.value = true;
    // Simulating API call with dummy data
    Future.delayed(const Duration(seconds: 1), () {
      domains.value = UserDomain.getDummyDomains();
      isLoading.value = false;
    });
  }

  List<UserDomain> get activeDomains =>
      domains.where((domain) => !domain.isExpired).toList();

  List<UserDomain> get expiredDomains =>
      domains.where((domain) => domain.isExpired).toList();

  void switchTab(int index) {
    selectedTabIndex.value = index;
  }

  void refreshDomains() {
    fetchDomains();
  }

  void toggleRegistrarLock(String domainName) {
    // In real implementation, this would make an API call
    // For now, we'll just show a success message
    Get.snackbar(
      'Success',
      'Registrar lock status updated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> getEppCode(String domainName) async {
    // In real implementation, this would make an API call
    // For now, we'll just show the transfer dialog
    Get.back(); // Close the settings page first
    await Future.delayed(const Duration(milliseconds: 300));
    CustomDialogs.showTransferDomainDialog(Get.context!, domainName);
  }

  void updateNameservers(String domainName, List<String> nameservers) {
    // In real implementation, this would make an API call
    // For now, we'll just show a success message
    Get.snackbar(
      'Success',
      'Nameservers updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updatePrivateNameservers(String domainName, List<String> nameservers) {
    // In real implementation, this would make an API call
    // For now, we'll just show a success message
    Get.snackbar(
      'Success',
      'Private nameservers updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
