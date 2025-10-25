import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vault_item_model.dart';
import '../core/privacy_manager.dart';

class VaultNotifier extends StateNotifier<VaultState> {
  VaultNotifier() : super(VaultState.initial());

  void addVaultItem(VaultItem item) {
    state = state.copyWith(
      items: [...state.items, item],
    );
  }

  void updateVaultItem(VaultItem item) {
    state = state.copyWith(
      items: state.items.map((i) => i.id == item.id ? item : i).toList(),
    );
  }

  void deleteVaultItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != itemId).toList(),
    );
  }

  void setVaultLocked(bool isLocked) {
    state = state.copyWith(isLocked: isLocked);
  }

  void setVaultAuthenticated(bool isAuthenticated) {
    state = state.copyWith(isAuthenticated: isAuthenticated);
  }

  void setVaultPIN(String pin) {
    state = state.copyWith(pin: pin);
  }

  void setVaultBiometricEnabled(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }

  void setVaultPattern(String pattern) {
    state = state.copyWith(pattern: pattern);
  }

  void setVaultDecoyPIN(String decoyPin) {
    state = state.copyWith(decoyPin: decoyPin);
  }

  void setVaultAutoLock(bool autoLock) {
    state = state.copyWith(autoLock: autoLock);
  }

  void setVaultAutoLockMinutes(int minutes) {
    state = state.copyWith(autoLockMinutes: minutes);
  }

  void setVaultShowDecoy(bool showDecoy) {
    state = state.copyWith(showDecoy: showDecoy);
  }

  void setVaultFilter(VaultFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setVaultSortBy(VaultSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void setVaultSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<VaultItem> getItemsByAlbum(String album) {
    return state.items.where((item) => item.album == album).toList();
  }

  List<VaultItem> getItemsByType(VaultItemType type) {
    return state.items.where((item) => item.type == type).toList();
  }

  List<VaultItem> getRecentItems({int limit = 10}) {
    final sortedItems = List<VaultItem>.from(state.items)
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    
    return sortedItems.take(limit).toList();
  }

  List<VaultItem> getLargeItems({int minSizeMB = 10}) {
    final minSizeBytes = minSizeMB * 1024 * 1024;
    return state.items.where((item) => item.fileSize > minSizeBytes).toList()
      ..sort((a, b) => b.fileSize.compareTo(a.fileSize));
  }

  List<VaultItem> getOldItems({int daysOld = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    return state.items.where((item) => item.dateAdded.isBefore(cutoffDate)).toList()
      ..sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
  }

  Map<String, dynamic> getVaultStats() {
    final totalItems = state.items.length;
    final totalSize = state.items.fold(0, (sum, item) => sum + item.fileSize);
    final albumCount = state.items.map((item) => item.album).toSet().length;
    final typeCount = state.items.map((item) => item.type).toSet().length;
    
    return {
      'totalItems': totalItems,
      'totalSize': totalSize,
      'totalSizeFormatted': PrivacyManager.formatFileSize(totalSize),
      'albumCount': albumCount,
      'typeCount': typeCount,
    };
  }

  Map<String, int> getStorageUsageByAlbum() {
    final usage = <String, int>{};
    
    for (final item in state.items) {
      final album = item.album ?? 'Uncategorized';
      usage[album] = (usage[album] ?? 0) + item.fileSize;
    }
    
    return usage;
  }

  Map<String, int> getStorageUsageByType() {
    final usage = <String, int>{};
    
    for (final item in state.items) {
      usage[item.type.name] = (usage[item.type.name] ?? 0) + item.fileSize;
    }
    
    return usage;
  }

  List<VaultItem> searchItems(String query) {
    if (query.isEmpty) return state.items;
    
    final lowercaseQuery = query.toLowerCase();
    return state.items.where((item) {
      return item.originalName.toLowerCase().contains(lowercaseQuery) ||
             (item.album ?? '').toLowerCase().contains(lowercaseQuery) ||
             item.type.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<VaultItem> getFilteredItems() {
    List<VaultItem> filtered = state.items;
    
    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = searchItems(state.searchQuery);
    }
    
    // Apply category filter
    if (state.filter != VaultFilter.all) {
      switch (state.filter) {
        case VaultFilter.images:
          filtered = filtered.where((item) => item.type == 'image').toList();
          break;
        case VaultFilter.videos:
          filtered = filtered.where((item) => item.type == 'video').toList();
          break;
        case VaultFilter.documents:
          filtered = filtered.where((item) => item.type == 'document').toList();
          break;
        case VaultFilter.audio:
          filtered = filtered.where((item) => item.type == 'audio').toList();
          break;
        case VaultFilter.archives:
          filtered = filtered.where((item) => item.type == 'archive').toList();
          break;
        case VaultFilter.other:
          filtered = filtered.where((item) => item.type == 'other').toList();
          break;
        case VaultFilter.all:
          break;
      }
    }
    
    // Apply sorting
    switch (state.sortBy) {
      case VaultSortBy.name:
        filtered.sort((a, b) => a.originalName.compareTo(b.originalName));
        break;
      case VaultSortBy.size:
        filtered.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
      case VaultSortBy.dateAdded:
        filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
      case VaultSortBy.category:
        filtered.sort((a, b) => (a.album ?? '').compareTo(b.album ?? ''));
        break;
      case VaultSortBy.type:
        filtered.sort((a, b) => a.type.name.compareTo(b.type.name));
        break;
    }
    
    return filtered;
  }

  void clearVault() {
    state = state.copyWith(items: []);
  }

  void importItems(List<VaultItem> items) {
    state = state.copyWith(
      items: [...state.items, ...items],
    );
  }

  void exportItems(List<String> itemIds) {
    // This would typically trigger a file export process
    // For now, we'll just log the items to be exported
    // final itemsToExport = state.items.where((item) => itemIds.contains(item.id)).toList(); // Commented out as not currently used
    // Implementation would handle the actual export
  }

  Map<String, dynamic> getVaultSecurityScore() {
    return {
      'hasPin': state.pin.isNotEmpty,
      'hasBiometric': state.biometricEnabled,
      'hasPattern': state.pattern.isNotEmpty,
      'hasDecoyPin': state.decoyPin.isNotEmpty,
      'autoLock': state.autoLock,
      'score': _calculateSecurityScore(),
    };
  }

  double _calculateSecurityScore() {
    double score = 0;
    
    if (state.pin.isNotEmpty) score += 30;
    if (state.biometricEnabled) score += 40;
    if (state.pattern.isNotEmpty) score += 20;
    if (state.decoyPin.isNotEmpty) score += 10;
    if (state.autoLock) score += 10;
    
    return score.clamp(0, 100);
  }
}

class VaultState {
  final List<VaultItem> items;
  final bool isLocked;
  final bool isAuthenticated;
  final String pin;
  final bool biometricEnabled;
  final String pattern;
  final String decoyPin;
  final bool autoLock;
  final int autoLockMinutes;
  final bool showDecoy;
  final VaultFilter filter;
  final VaultSortBy sortBy;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const VaultState({
    required this.items,
    required this.isLocked,
    required this.isAuthenticated,
    required this.pin,
    required this.biometricEnabled,
    required this.pattern,
    required this.decoyPin,
    required this.autoLock,
    required this.autoLockMinutes,
    required this.showDecoy,
    required this.filter,
    required this.sortBy,
    required this.searchQuery,
    required this.isLoading,
    this.error,
  });

  factory VaultState.initial() {
    return const VaultState(
      items: [],
      isLocked: true,
      isAuthenticated: false,
      pin: '',
      biometricEnabled: false,
      pattern: '',
      decoyPin: '',
      autoLock: true,
      autoLockMinutes: 5,
      showDecoy: false,
      filter: VaultFilter.all,
      sortBy: VaultSortBy.dateAdded,
      searchQuery: '',
      isLoading: false,
      error: null,
    );
  }

  VaultState copyWith({
    List<VaultItem>? items,
    bool? isLocked,
    bool? isAuthenticated,
    String? pin,
    bool? biometricEnabled,
    String? pattern,
    String? decoyPin,
    bool? autoLock,
    int? autoLockMinutes,
    bool? showDecoy,
    VaultFilter? filter,
    VaultSortBy? sortBy,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return VaultState(
      items: items ?? this.items,
      isLocked: isLocked ?? this.isLocked,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      pin: pin ?? this.pin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pattern: pattern ?? this.pattern,
      decoyPin: decoyPin ?? this.decoyPin,
      autoLock: autoLock ?? this.autoLock,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      showDecoy: showDecoy ?? this.showDecoy,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

enum VaultFilter {
  all,
  images,
  videos,
  documents,
  audio,
  archives,
  other,
}

enum VaultSortBy {
  name,
  size,
  dateAdded,
  category,
  type,
}

final vaultProvider = StateNotifierProvider<VaultNotifier, VaultState>((ref) {
  return VaultNotifier();
});
