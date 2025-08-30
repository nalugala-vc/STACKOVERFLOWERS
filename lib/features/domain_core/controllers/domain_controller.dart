import 'package:get/get.dart';
import 'package:kenic/core/utils/widgets/custom_dialogs.dart';
import 'package:kenic/features/domain_core/models/user_domain.dart';
import 'package:kenic/features/domain_core/repository/user_domains_repository.dart';

class DomainController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<UserDomain> domains = <UserDomain>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxString errorMessage = ''.obs;

  // New observables for nameservers and EPP code
  final RxMap<int, List<String>> domainNameservers = <int, List<String>>{}.obs;
  final RxMap<int, String> domainEppCodes = <int, String>{}.obs;
  final RxBool isLoadingNameservers = false.obs;
  final RxBool isLoadingEppCode = false.obs;

  final UserDomainsRepository _repository = UserDomainsRepository();

  @override
  void onInit() {
    super.onInit();
    fetchDomains();
  }

  Future<void> fetchDomains() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.getUserDomains();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          // Fallback to dummy data for development
          domains.value = UserDomain.getDummyDomains();
        },
        (response) {
          domains.value = response.domains;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      // Fallback to dummy data for development
      domains.value = UserDomain.getDummyDomains();
    } finally {
      isLoading.value = false;
    }
  }

  List<UserDomain> get activeDomains =>
      domains.where((domain) => domain.isActive).toList();

  List<UserDomain> get expiredDomains =>
      domains.where((domain) => domain.isExpired).toList();

  List<UserDomain> get pendingDomains =>
      domains.where((domain) => domain.isPending).toList();

  void switchTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> refreshDomains() async {
    await fetchDomains();
  }

  // ==================== NAMESERVERS ====================
  Future<void> fetchDomainNameservers(int domainId) async {
    if (domainNameservers.containsKey(domainId)) {
      return; // Already fetched
    }

    isLoadingNameservers.value = true;

    try {
      final result = await _repository.getDomainNameservers(domainId: domainId);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (response) {
          if (response.success) {
            domainNameservers[domainId] = response.data.nameservers;
          } else {
            Get.snackbar(
              'Error',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch nameservers',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingNameservers.value = false;
    }
  }

  List<String> getNameservers(int domainId) {
    return domainNameservers[domainId] ?? [];
  }

  // ==================== EPP CODE ====================
  Future<String?> fetchDomainEppCode(int domainId) async {
    if (domainEppCodes.containsKey(domainId)) {
      return domainEppCodes[domainId];
    }

    isLoadingEppCode.value = true;

    try {
      final result = await _repository.getDomainEppCode(domainId: domainId);

      return result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        },
        (response) {
          if (response.success) {
            domainEppCodes[domainId] = response.data;
            return response.data;
          } else {
            Get.snackbar(
              'Error',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
            );
            return null;
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch EPP code',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoadingEppCode.value = false;
    }
  }

  String? getEppCode(int domainId) {
    return domainEppCodes[domainId];
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

  Future<void> showTransferDialog(String domainName) async {
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
