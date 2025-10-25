import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calculation_model.dart';

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(HistoryState.initial());

  void addCalculation(CalculationHistory calculation) {
    state = state.copyWith(
      calculations: [calculation, ...state.calculations],
    );
  }

  void updateCalculation(CalculationHistory calculation) {
    state = state.copyWith(
      calculations: state.calculations.map((c) => c.id == calculation.id ? calculation : c).toList(),
    );
  }

  void deleteCalculation(String calculationId) {
    state = state.copyWith(
      calculations: state.calculations.where((c) => c.id != calculationId).toList(),
    );
  }

  void clearHistory() {
    state = state.copyWith(calculations: []);
  }

  void clearHistoryByType(CalculationType type) {
    state = state.copyWith(
      calculations: state.calculations.where((c) => c.type != type).toList(),
    );
  }

  void clearHistoryByDateRange(DateTime startDate, DateTime endDate) {
    state = state.copyWith(
      calculations: state.calculations.where((c) {
        return c.timestamp.isBefore(startDate) || c.timestamp.isAfter(endDate);
      }).toList(),
    );
  }

  void setFilter(HistoryFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSortBy(HistorySortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<CalculationHistory> getCalculationsByType(CalculationType type) {
    return state.calculations.where((c) => c.type == type).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<CalculationHistory> getCalculationsByDateRange(DateTime startDate, DateTime endDate) {
    return state.calculations.where((c) {
      return c.timestamp.isAfter(startDate) && c.timestamp.isBefore(endDate);
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<CalculationHistory> getRecentCalculations({int limit = 10}) {
    final sortedCalculations = List<CalculationHistory>.from(state.calculations)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return sortedCalculations.take(limit).toList();
  }

  List<CalculationHistory> getFavoriteCalculations() {
    return state.calculations.where((c) => c.isFavorite).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<CalculationHistory> searchCalculations(String query) {
    if (query.isEmpty) return state.calculations;
    
    final lowercaseQuery = query.toLowerCase();
    return state.calculations.where((calculation) {
      return calculation.expression.toLowerCase().contains(lowercaseQuery) ||
             calculation.result.toLowerCase().contains(lowercaseQuery) ||
             calculation.type.name.toLowerCase().contains(lowercaseQuery);
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<CalculationHistory> getFilteredCalculations() {
    List<CalculationHistory> filtered = state.calculations;
    
    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = searchCalculations(state.searchQuery);
    }
    
    // Apply type filter
    if (state.filter != HistoryFilter.all) {
      switch (state.filter) {
        case HistoryFilter.basic:
          filtered = filtered.where((c) => c.type == CalculationType.basic).toList();
          break;
        case HistoryFilter.scientific:
          filtered = filtered.where((c) => c.type == CalculationType.scientific).toList();
          break;
        case HistoryFilter.algebra:
          filtered = filtered.where((c) => c.type == CalculationType.algebra).toList();
          break;
        case HistoryFilter.geometry:
          filtered = filtered.where((c) => c.type == CalculationType.geometry).toList();
          break;
        case HistoryFilter.finance:
          filtered = filtered.where((c) => c.type == CalculationType.finance).toList();
          break;
        case HistoryFilter.health:
          filtered = filtered.where((c) => c.type == CalculationType.health).toList();
          break;
        case HistoryFilter.converter:
          filtered = filtered.where((c) => c.type == CalculationType.unitConverter || c.type == CalculationType.currencyConverter).toList();
          break;
        case HistoryFilter.favorites:
          filtered = filtered.where((c) => c.isFavorite).toList();
          break;
        case HistoryFilter.all:
          break;
      }
    }
    
    // Apply sorting
    switch (state.sortBy) {
      case HistorySortBy.date:
        filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case HistorySortBy.type:
        filtered.sort((a, b) => a.type.name.compareTo(b.type.name));
        break;
      case HistorySortBy.expression:
        filtered.sort((a, b) => a.expression.compareTo(b.expression));
        break;
      case HistorySortBy.result:
        filtered.sort((a, b) => a.result.compareTo(b.result));
        break;
    }
    
    return filtered;
  }

  Map<String, dynamic> getHistoryStats() {
    final total = state.calculations.length;
    final favorites = state.calculations.where((c) => c.isFavorite).length;
    
    // Count by type
    final typeCount = <String, int>{};
    for (final calculation in state.calculations) {
      typeCount[calculation.type.name] = (typeCount[calculation.type.name] ?? 0) + 1;
    }
    
    // Most used type
    String mostUsedType = 'None';
    int maxCount = 0;
    typeCount.forEach((type, count) {
      if (count > maxCount) {
        maxCount = count;
        mostUsedType = type;
      }
    });
    
    // Recent activity (last 7 days)
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentCount = state.calculations.where((c) => c.timestamp.isAfter(weekAgo)).length;
    
    return {
      'total': total,
      'favorites': favorites,
      'typeCount': typeCount,
      'mostUsedType': mostUsedType,
      'recentCount': recentCount,
    };
  }

  Map<String, int> getCalculationsByTypeCount() {
    final typeCount = <String, int>{};
    for (final calculation in state.calculations) {
      typeCount[calculation.type.name] = (typeCount[calculation.type.name] ?? 0) + 1;
    }
    return typeCount;
  }

  Map<String, int> getCalculationsByDate() {
    final dateCount = <String, int>{};
    for (final calculation in state.calculations) {
      final dateKey = '${calculation.timestamp.year}-${calculation.timestamp.month.toString().padLeft(2, '0')}-${calculation.timestamp.day.toString().padLeft(2, '0')}';
      dateCount[dateKey] = (dateCount[dateKey] ?? 0) + 1;
    }
    return dateCount;
  }

  Map<String, int> getCalculationsByHour() {
    final hourCount = <String, int>{};
    for (final calculation in state.calculations) {
      final hourKey = calculation.timestamp.hour.toString().padLeft(2, '0');
      hourCount[hourKey] = (hourCount[hourKey] ?? 0) + 1;
    }
    return hourCount;
  }

  void toggleFavorite(String calculationId) {
    final calculation = state.calculations.firstWhere((c) => c.id == calculationId);
    final updatedCalculation = calculation.copyWith(isFavorite: !calculation.isFavorite);
    updateCalculation(updatedCalculation);
  }

  // Tag functionality removed as CalculationHistory model doesn't have tags property
}

class HistoryState {
  final List<CalculationHistory> calculations;
  final HistoryFilter filter;
  final HistorySortBy sortBy;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const HistoryState({
    required this.calculations,
    required this.filter,
    required this.sortBy,
    required this.searchQuery,
    required this.isLoading,
    this.error,
  });

  factory HistoryState.initial() {
    return const HistoryState(
      calculations: [],
      filter: HistoryFilter.all,
      sortBy: HistorySortBy.date,
      searchQuery: '',
      isLoading: false,
      error: null,
    );
  }

  HistoryState copyWith({
    List<CalculationHistory>? calculations,
    HistoryFilter? filter,
    HistorySortBy? sortBy,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return HistoryState(
      calculations: calculations ?? this.calculations,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

enum HistoryFilter {
  all,
  basic,
  scientific,
  algebra,
  geometry,
  finance,
  health,
  converter,
  favorites,
}

enum HistorySortBy {
  date,
  type,
  expression,
  result,
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});
