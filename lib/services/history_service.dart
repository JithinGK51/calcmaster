import 'package:flutter/foundation.dart';
import '../models/calculation_model.dart';
import '../services/storage_service.dart';

class HistoryService {
  static const int _maxHistorySize = 1000; // Maximum number of calculations to store
  
  // Save calculation to history
  static Future<void> saveCalculation({
    required String expression,
    required String result,
    required CalculationType type,
    String? category,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final calculation = CalculationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        expression: expression,
        result: result,
        type: type,
        timestamp: DateTime.now(),
        category: category,
        metadata: metadata,
        isFavorite: false,
      );
      
      // Save to storage
      await StorageService.saveCalculation(calculation);
      
      // Clean up old calculations if we exceed the limit
      await _cleanupOldCalculations();
      
      if (kDebugMode) {
        print('Calculation saved to history: $expression = $result');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving calculation to history: $e');
      }
    }
  }
  
  // Save basic calculator calculation
  static Future<void> saveBasicCalculation(String expression, String result) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.basic,
      category: 'Basic Calculator',
    );
  }
  
  // Save scientific calculator calculation
  static Future<void> saveScientificCalculation(String expression, String result) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.scientific,
      category: 'Scientific Calculator',
    );
  }
  
  // Save algebra calculation
  static Future<void> saveAlgebraCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.algebra,
      category: category ?? 'Algebra',
      metadata: {'solver_type': 'equation_solver'},
    );
  }
  
  // Save geometry calculation
  static Future<void> saveGeometryCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.geometry,
      category: category ?? 'Geometry',
    );
  }
  
  // Save statistics calculation
  static Future<void> saveStatisticsCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.statistics,
      category: category ?? 'Statistics',
    );
  }
  
  // Save finance calculation
  static Future<void> saveFinanceCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.finance,
      category: category ?? 'Finance',
    );
  }
  
  // Save health calculation
  static Future<void> saveHealthCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.health,
      category: category ?? 'Health',
    );
  }
  
  // Save unit converter calculation
  static Future<void> saveUnitConverterCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.unitConverter,
      category: category ?? 'Unit Converter',
    );
  }
  
  // Save currency converter calculation
  static Future<void> saveCurrencyConverterCalculation(String expression, String result, {String? category}) async {
    await saveCalculation(
      expression: expression,
      result: result,
      type: CalculationType.currencyConverter,
      category: category ?? 'Currency Converter',
    );
  }
  
  // Get all calculations
  static List<CalculationHistory> getAllCalculations() {
    return StorageService.getAllCalculations();
  }
  
  // Get calculations by type
  static List<CalculationHistory> getCalculationsByType(CalculationType type) {
    final allCalculations = getAllCalculations();
    return allCalculations.where((calc) => calc.type == type).toList();
  }
  
  // Get calculations by category
  static List<CalculationHistory> getCalculationsByCategory(String category) {
    final allCalculations = getAllCalculations();
    return allCalculations.where((calc) => calc.category == category).toList();
  }
  
  // Get calculations by date range
  static List<CalculationHistory> getCalculationsByDateRange(DateTime startDate, DateTime endDate) {
    final allCalculations = getAllCalculations();
    return allCalculations.where((calc) {
      return calc.timestamp.isAfter(startDate) && calc.timestamp.isBefore(endDate);
    }).toList();
  }
  
  // Get recent calculations
  static List<CalculationHistory> getRecentCalculations({int limit = 50}) {
    final allCalculations = getAllCalculations();
    return allCalculations.take(limit).toList();
  }
  
  // Get favorite calculations
  static List<CalculationHistory> getFavoriteCalculations() {
    final allCalculations = getAllCalculations();
    return allCalculations.where((calc) => calc.isFavorite).toList();
  }
  
  // Search calculations
  static List<CalculationHistory> searchCalculations(String query) {
    final allCalculations = getAllCalculations();
    final lowercaseQuery = query.toLowerCase();
    
    return allCalculations.where((calc) {
      return calc.expression.toLowerCase().contains(lowercaseQuery) ||
             calc.result.toLowerCase().contains(lowercaseQuery) ||
             (calc.category?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
  
  // Delete calculation
  static Future<void> deleteCalculation(String id) async {
    await StorageService.deleteCalculation(id);
  }
  
  // Delete calculations by type
  static Future<void> deleteCalculationsByType(CalculationType type) async {
    final calculations = getCalculationsByType(type);
    for (final calc in calculations) {
      await deleteCalculation(calc.id);
    }
  }
  
  // Delete calculations by date range
  static Future<void> deleteCalculationsByDateRange(DateTime startDate, DateTime endDate) async {
    final calculations = getCalculationsByDateRange(startDate, endDate);
    for (final calc in calculations) {
      await deleteCalculation(calc.id);
    }
  }
  
  // Clear all history
  static Future<void> clearAllHistory() async {
    await StorageService.clearAllCalculations();
  }
  
  // Toggle favorite status
  static Future<void> toggleFavorite(String id) async {
    final allCalculations = getAllCalculations();
    final calculation = allCalculations.firstWhere((calc) => calc.id == id);
    
    final updatedCalculation = calculation.copyWith(
      isFavorite: !calculation.isFavorite,
    );
    
    await StorageService.saveCalculation(updatedCalculation);
  }
  
  // Get calculation statistics
  static Map<String, dynamic> getCalculationStatistics() {
    final allCalculations = getAllCalculations();
    
    if (allCalculations.isEmpty) {
      return {
        'totalCalculations': 0,
        'calculationsByType': {},
        'calculationsByCategory': {},
        'mostUsedCategory': null,
        'averageCalculationsPerDay': 0.0,
        'totalFavorites': 0,
      };
    }
    
    // Count by type
    final calculationsByType = <CalculationType, int>{};
    for (final calc in allCalculations) {
      calculationsByType[calc.type] = (calculationsByType[calc.type] ?? 0) + 1;
    }
    
    // Count by category
    final calculationsByCategory = <String, int>{};
    for (final calc in allCalculations) {
      final category = calc.category ?? 'Unknown';
      calculationsByCategory[category] = (calculationsByCategory[category] ?? 0) + 1;
    }
    
    // Find most used category
    String? mostUsedCategory;
    int maxCount = 0;
    for (final entry in calculationsByCategory.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostUsedCategory = entry.key;
      }
    }
    
    // Calculate average calculations per day
    final firstCalculation = allCalculations.last.timestamp;
    final lastCalculation = allCalculations.first.timestamp;
    final daysDiff = lastCalculation.difference(firstCalculation).inDays;
    final averagePerDay = daysDiff > 0 ? allCalculations.length / daysDiff : 0.0;
    
    // Count favorites
    final totalFavorites = allCalculations.where((calc) => calc.isFavorite).length;
    
    return {
      'totalCalculations': allCalculations.length,
      'calculationsByType': calculationsByType,
      'calculationsByCategory': calculationsByCategory,
      'mostUsedCategory': mostUsedCategory,
      'averageCalculationsPerDay': averagePerDay,
      'totalFavorites': totalFavorites,
    };
  }
  
  // Clean up old calculations to maintain performance
  static Future<void> _cleanupOldCalculations() async {
    final allCalculations = getAllCalculations();
    
    if (allCalculations.length > _maxHistorySize) {
      // Keep only the most recent calculations
      final calculationsToKeep = allCalculations.take(_maxHistorySize).toList();
      final calculationsToDelete = allCalculations.skip(_maxHistorySize).toList();
      
      // Delete old calculations
      for (final calc in calculationsToDelete) {
        await deleteCalculation(calc.id);
      }
      
      if (kDebugMode) {
        print('Cleaned up ${calculationsToDelete.length} old calculations');
      }
    }
  }
  
  // Export calculations to different formats
  static Future<String> exportToCSV({CalculationType? type, String? category}) async {
    List<CalculationHistory> calculations;
    
    if (type != null) {
      calculations = getCalculationsByType(type);
    } else if (category != null) {
      calculations = getCalculationsByCategory(category);
    } else {
      calculations = getAllCalculations();
    }
    
    final buffer = StringBuffer();
    buffer.writeln('ID,Expression,Result,Type,Category,Timestamp,Favorite');
    
    for (final calc in calculations) {
      buffer.writeln('${calc.id},"${calc.expression}","${calc.result}",${calc.type.name},"${calc.category ?? ''}",${calc.timestamp.toIso8601String()},${calc.isFavorite}');
    }
    
    return buffer.toString();
  }
  
  // Export calculations to JSON
  static Future<String> exportToJSON({CalculationType? type, String? category}) async {
    List<CalculationHistory> calculations;
    
    if (type != null) {
      calculations = getCalculationsByType(type);
    } else if (category != null) {
      calculations = getCalculationsByCategory(category);
    } else {
      calculations = getAllCalculations();
    }
    
    final jsonList = calculations.map((calc) => {
      'id': calc.id,
      'expression': calc.expression,
      'result': calc.result,
      'type': calc.type.name,
      'category': calc.category,
      'timestamp': calc.timestamp.toIso8601String(),
      'favorite': calc.isFavorite,
      'metadata': calc.metadata,
    }).toList();
    
    return jsonList.toString();
  }
}
