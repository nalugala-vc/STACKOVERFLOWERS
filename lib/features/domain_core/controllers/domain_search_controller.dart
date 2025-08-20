import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';
import 'package:kenic/features/domain_core/models/domain.dart';

class DomainSearchController extends BaseController {
  static DomainSearchController get instance => Get.find();

  final searchController = TextEditingController();
  final searchResults = <Domain>[].obs;
  final aiSuggestions = <DomainSuggestion>[].obs;
  final trendingKeywords = <String>[].obs;
  final recentSearches = <String>[].obs;
  final isSearching = false.obs;
  final selectedExtensions = <String>['.com', '.co.ke', '.or.ke'].obs;

  final availableExtensions = [
    '.com',
    '.co.ke',
    '.or.ke',
    '.ac.ke',
    '.go.ke',
    '.ne.ke',
    '.sc.ke',
    '.net',
    '.org',
    '.info',
  ];

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

  Future<void> searchDomains(String query) async {
    if (query.trim().isEmpty) return;

    isSearching.value = true;
    setBusy(true);

    try {
      // Add to recent searches
      if (!recentSearches.contains(query)) {
        recentSearches.insert(0, query);
        if (recentSearches.length > 10) {
          recentSearches.removeLast();
        }
      }

      // Mock search results - in real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 1500));

      final results = <Domain>[];
      final suggestions = <DomainSuggestion>[];

      // Generate results for selected extensions
      for (String extension in selectedExtensions) {
        final isAvailable = _mockAvailabilityCheck(query + extension);
        final price = _getPriceForExtension(extension);

        results.add(
          Domain(
            name: query,
            extension: extension,
            isAvailable: isAvailable,
            price: price,
            description:
                isAvailable
                    ? 'Available for registration'
                    : 'Already registered',
            whoisInfo: isAvailable ? null : _mockWhoisInfo(),
          ),
        );
      }

      // Generate AI suggestions
      suggestions.addAll(await _generateAISuggestions(query));

      searchResults.value = results;
      aiSuggestions.value = suggestions;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search domains. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
      setBusy(false);
    }
  }

  Future<List<DomainSuggestion>> _generateAISuggestions(String query) async {
    // Mock AI suggestions - in real app, this would be an AI service call
    final suggestions = <DomainSuggestion>[];
    final variations = [
      '${query}hub',
      '${query}pro',
      'my$query',
      '${query}zone',
      'get$query',
      '${query}live',
      '${query}plus',
      'i$query',
    ];

    for (String variation in variations.take(6)) {
      for (String extension in ['.com', '.co.ke', '.net']) {
        suggestions.add(
          DomainSuggestion(
            keyword: query,
            suggestion: variation,
            extension: extension,
            price: _getPriceForExtension(extension),
            isAvailable: _mockAvailabilityCheck(variation + extension),
            type: 'ai_generated',
          ),
        );
      }
    }

    return suggestions.where((s) => s.isAvailable).take(8).toList();
  }

  bool _mockAvailabilityCheck(String domain) {
    // Mock availability - in real app, this would be an API call
    final hash = domain.hashCode;
    return hash % 3 != 0; // ~66% availability rate
  }

  double _getPriceForExtension(String extension) {
    switch (extension) {
      case '.com':
        return 12.99;
      case '.co.ke':
        return 8.50;
      case '.or.ke':
        return 6.00;
      case '.ac.ke':
        return 7.50;
      case '.go.ke':
        return 10.00;
      case '.ne.ke':
        return 6.50;
      case '.sc.ke':
        return 8.00;
      case '.net':
        return 14.99;
      case '.org':
        return 13.99;
      case '.info':
        return 11.99;
      default:
        return 15.99;
    }
  }

  WhoisInfo _mockWhoisInfo() {
    return WhoisInfo(
      registrant: 'Private Registration',
      registrarName: 'Kenya Network Information Centre',
      registrationDate: DateTime.now().subtract(const Duration(days: 365)),
      expiryDate: DateTime.now().add(const Duration(days: 365)),
      nameServers: ['ns1.example.com', 'ns2.example.com'],
      status: 'Active',
    );
  }

  void toggleExtension(String extension) {
    if (selectedExtensions.contains(extension)) {
      if (selectedExtensions.length > 1) {
        selectedExtensions.remove(extension);
      }
    } else {
      selectedExtensions.add(extension);
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    aiSuggestions.clear();
  }

  void searchFromKeyword(String keyword) {
    searchController.text = keyword;
    searchDomains(keyword);
  }
}
