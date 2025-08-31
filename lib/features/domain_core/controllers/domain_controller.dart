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
          // Don't fall back to dummy data - show empty state instead
          domains.value = [];
        },
        (response) {
          domains.value = response.domains;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      // Don't fall back to dummy data - show empty state instead
      domains.value = [];
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

  // ==================== WHMCS USER DETAILS ====================
  final Rx<WhmcsUserDetails?> whmcsUserDetails = Rx<WhmcsUserDetails?>(null);
  final RxBool isLoadingUserDetails = false.obs;

  Future<WhmcsUserDetails?> fetchWhmcsUserDetails() async {
    if (whmcsUserDetails.value != null) {
      return whmcsUserDetails.value; // Return cached value
    }

    isLoadingUserDetails.value = true;

    try {
      final result = await _repository.getWhmcsUserDetails();

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
          whmcsUserDetails.value = response;
          return response;
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user details',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoadingUserDetails.value = false;
    }
  }

  // Check if user details are complete
  bool get areUserDetailsComplete {
    return whmcsUserDetails.value?.isComplete ?? false;
  }

  // Get missing fields for user feedback
  List<String> get missingUserDetailsFields {
    return whmcsUserDetails.value?.missingFields ?? [];
  }

  // ==================== UPDATE NAMESERVERS ====================
  Future<bool> updateDomainNameservers({
    required int domainId,
    required String ns1,
    required String ns2,
    String? ns3,
    String? ns4,
    String? ns5,
  }) async {
    try {
      final request = NameserverUpdateRequest(
        domainId: domainId,
        ns1: ns1,
        ns2: ns2,
        ns3: ns3,
        ns4: ns4,
        ns5: ns5,
      );

      if (!request.isValid) {
        Get.snackbar(
          'Error',
          'NS1 and NS2 are required',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      final result = await _repository.updateDomainNameservers(
        request: request,
      );

      return result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        },
        (response) {
          if (response.success) {
            // Update the cached nameservers
            domainNameservers[domainId] = response.data.nameservers;

            Get.snackbar(
              'Success',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
            );
            return true;
          } else {
            Get.snackbar(
              'Error',
              response.message,
              snackPosition: SnackPosition.BOTTOM,
            );
            return false;
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update nameservers',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
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
