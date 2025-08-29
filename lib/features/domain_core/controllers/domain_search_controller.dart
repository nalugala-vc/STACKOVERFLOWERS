import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/features/domain_core/models/models.dart';
import 'package:kenic/features/domain_core/repository/domain_search_repository.dart';

class DomainSearchController extends GetxController {
  static DomainSearchController get instance => Get.find();

  // Repository
  final DomainSearchRepository _repository = DomainSearchRepository();

  // Controllers
  final searchController = TextEditingController();

  // Observable variables
  final searchTerm = ''.obs;
  final searchResult = Rxn<DomainSearch>();
  final suggestions = <DomainSuggestionResponse>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;
  final errorMessage = ''.obs;

  // Extension management
  final selectedExtensions = <String>['.com', '.co.ke', '.or.ke'].obs;
  final availableExtensions = [
    '.ke',
    '.co.ke',
    '.or.ke',
    '.ac.ke',
    '.go.ke',
    '.ne.ke',
    '.sc.ke',
    '.go.ke',
  ];

  // Selected domain extension for dropdown
  final selectedDomainExtension = '.co.ke'.obs;
  final domainExtensions = [
    DomainExtension('.ke', 'For any Kenyan entity, general use'),
    DomainExtension('.co.ke', 'Companies, businesses, and commercial entities'),
    DomainExtension('.or.ke', 'Non-profit organizations, NGOs, CBOs'),
    DomainExtension('.ac.ke', 'Accredited higher learning institutions'),
    DomainExtension('.sc.ke', 'Primary and secondary schools'),
    DomainExtension('.go.ke', 'Government institutions only'),
    DomainExtension('.ne.ke', 'Network providers, ISPs'),
    DomainExtension('.me.ke', 'Personal domains for individuals'),
    DomainExtension('.mobi.ke', 'Mobile content/services'),
    DomainExtension('.info.ke', 'Information services/resources'),
  ];

  // Trending and recent
  final trendingKeywords =
      <String>[
        'tech',
        'business',
        'shop',
        'online',
        'digital',
        'kenya',
        'app',
        'web',
        'store',
        'service',
      ].obs;
  final recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTrendingKeywords();
    loadRecentSearches();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadTrendingKeywords() {
    // Mock trending keywords - in real app, this would come from API
    trendingKeywords.value = [
      'tech',
      'business',
      'shop',
      'online',
      'digital',
      'kenya',
      'app',
      'web',
      'store',
      'service',
    ];
  }

  void loadRecentSearches() {
    // In real app, load from shared preferences or API
    recentSearches.value = [];
  }

  // Extension dropdown methods
  void selectDomainExtension(String extension) {
    selectedDomainExtension.value = extension;
  }

  String getFullDomainName(String domainName) {
    // If domain already has extension, return as is
    if (domainName.contains('.')) {
      return domainName;
    }
    // Otherwise append selected extension
    return '$domainName${selectedDomainExtension.value}';
  }

  // ==================== DOMAIN SEARCH ====================
  Future<void> searchDomains(String term) async {
    if (term.trim().isEmpty) {
      searchResult.value = null;
      return;
    }

    isSearching.value = true;
    errorMessage.value = '';
    searchTerm.value = term.trim();

    try {
      // Add to recent searches
      if (!recentSearches.contains(term)) {
        recentSearches.insert(0, term);
        if (recentSearches.length > 10) {
          recentSearches.removeLast();
        }
      }

      final result = await _repository.searchDomains(searchTerm: term.trim());

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          searchResult.value = null;
        },
        (domainSearch) {
          searchResult.value = domainSearch;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      searchResult.value = null;
    } finally {
      isSearching.value = false;
    }
  }

  // ==================== UTILITY METHODS ====================
  void clearSearch() {
    searchController.clear();
    searchTerm.value = '';
    searchResult.value = null;
    suggestions.clear();
    errorMessage.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }

  void clearSuggestions() {
    suggestions.clear();
  }

  bool get hasSearchResults => searchResult.value != null;
  bool get hasSuggestions => suggestions.isNotEmpty;
  bool get hasError => errorMessage.value.isNotEmpty;

  // Extension management methods
  void toggleExtension(String extension) {
    if (selectedExtensions.contains(extension)) {
      if (selectedExtensions.length > 1) {
        selectedExtensions.remove(extension);
      }
    } else {
      selectedExtensions.add(extension);
    }
  }

  // Search from keyword
  void searchFromKeyword(String keyword) {
    searchController.text = keyword;
    searchDomains(keyword);
  }
}
