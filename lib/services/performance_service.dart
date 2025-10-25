import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PerformanceService {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<Duration>> _performanceHistory = {};
  static final Map<String, int> _operationCounts = {};
  static final Map<String, Duration> _totalTimes = {};
  static bool _isEnabled = true;
  static const int _maxHistorySize = 100;

  // Enable/disable performance monitoring
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (kDebugMode) {
      print('Performance monitoring ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  // Start timing an operation
  static void startTimer(String operationName) {
    if (!_isEnabled) return;
    
    _timers[operationName] = Stopwatch()..start();
    
    if (kDebugMode) {
      print('Started timer for: $operationName');
    }
  }

  // Stop timing an operation and record the result
  static Duration? stopTimer(String operationName) {
    if (!_isEnabled) return null;
    
    final timer = _timers.remove(operationName);
    if (timer == null) {
      if (kDebugMode) {
        print('No timer found for: $operationName');
      }
      return null;
    }
    
    timer.stop();
    final duration = timer.elapsed;
    
    // Record performance data
    _recordPerformance(operationName, duration);
    
    if (kDebugMode) {
      print('Timer stopped for $operationName: ${duration.inMilliseconds}ms');
    }
    
    return duration;
  }

  // Record performance data
  static void _recordPerformance(String operationName, Duration duration) {
    // Add to history
    _performanceHistory.putIfAbsent(operationName, () => []);
    _performanceHistory[operationName]!.add(duration);
    
    // Keep only recent history
    if (_performanceHistory[operationName]!.length > _maxHistorySize) {
      _performanceHistory[operationName]!.removeAt(0);
    }
    
    // Update counters
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;
    _totalTimes[operationName] = (_totalTimes[operationName] ?? Duration.zero) + duration;
  }

  // Measure execution time of a function
  static Future<T> measureAsync<T>(String operationName, Future<T> Function() operation) async {
    startTimer(operationName);
    try {
      final result = await operation();
      stopTimer(operationName);
      return result;
    } catch (e) {
      stopTimer(operationName);
      rethrow;
    }
  }

  // Measure execution time of a synchronous function
  static T measure<T>(String operationName, T Function() operation) {
    startTimer(operationName);
    try {
      final result = operation();
      stopTimer(operationName);
      return result;
    } catch (e) {
      stopTimer(operationName);
      rethrow;
    }
  }

  // Get performance statistics for an operation
  static Map<String, dynamic>? getPerformanceStats(String operationName) {
    if (!_performanceHistory.containsKey(operationName)) {
      return null;
    }
    
    final history = _performanceHistory[operationName]!;
    final count = _operationCounts[operationName] ?? 0;
    final totalTime = _totalTimes[operationName] ?? Duration.zero;
    
    if (history.isEmpty) {
      return null;
    }
    
    // Calculate statistics
    final durations = history.map((d) => d.inMicroseconds).toList();
    durations.sort();
    
    final min = Duration(microseconds: durations.first);
    final max = Duration(microseconds: durations.last);
    final avg = Duration(microseconds: durations.reduce((a, b) => a + b) ~/ durations.length);
    
    // Median
    Duration median;
    if (durations.length % 2 == 0) {
      final mid1 = durations[durations.length ~/ 2 - 1];
      final mid2 = durations[durations.length ~/ 2];
      median = Duration(microseconds: (mid1 + mid2) ~/ 2);
    } else {
      median = Duration(microseconds: durations[durations.length ~/ 2]);
    }
    
    // 95th percentile
    final p95Index = (durations.length * 0.95).floor();
    final p95 = Duration(microseconds: durations[p95Index]);
    
    return {
      'operationName': operationName,
      'count': count,
      'totalTime': totalTime,
      'averageTime': avg,
      'minTime': min,
      'maxTime': max,
      'medianTime': median,
      'p95Time': p95,
      'operationsPerSecond': count / (totalTime.inSeconds > 0 ? totalTime.inSeconds : 1),
    };
  }

  // Get all performance statistics
  static Map<String, Map<String, dynamic>> getAllPerformanceStats() {
    final stats = <String, Map<String, dynamic>>{};
    
    for (final operationName in _performanceHistory.keys) {
      final operationStats = getPerformanceStats(operationName);
      if (operationStats != null) {
        stats[operationName] = operationStats;
      }
    }
    
    return stats;
  }

  // Get slowest operations
  static List<Map<String, dynamic>> getSlowestOperations({int limit = 10}) {
    final allStats = getAllPerformanceStats();
    final sortedStats = allStats.values.toList()
      ..sort((a, b) => (b['averageTime'] as Duration).compareTo(a['averageTime'] as Duration));
    
    return sortedStats.take(limit).toList();
  }

  // Get most frequent operations
  static List<Map<String, dynamic>> getMostFrequentOperations({int limit = 10}) {
    final allStats = getAllPerformanceStats();
    final sortedStats = allStats.values.toList()
      ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    
    return sortedStats.take(limit).toList();
  }

  // Clear performance data
  static void clearPerformanceData() {
    _timers.clear();
    _performanceHistory.clear();
    _operationCounts.clear();
    _totalTimes.clear();
    
    if (kDebugMode) {
      print('Performance data cleared');
    }
  }

  // Clear performance data for a specific operation
  static void clearOperationData(String operationName) {
    _timers.remove(operationName);
    _performanceHistory.remove(operationName);
    _operationCounts.remove(operationName);
    _totalTimes.remove(operationName);
    
    if (kDebugMode) {
      print('Performance data cleared for: $operationName');
    }
  }

  // Log performance summary
  static void logPerformanceSummary() {
    if (!_isEnabled || !kDebugMode) return;
    
    final stats = getAllPerformanceStats();
    if (stats.isEmpty) {
      print('No performance data available');
      return;
    }
    
    print('\n=== Performance Summary ===');
    print('Total operations tracked: ${stats.length}');
    
    final slowest = getSlowestOperations(limit: 5);
    print('\nSlowest operations:');
    for (final stat in slowest) {
      print('  ${stat['operationName']}: ${stat['averageTime'].inMilliseconds}ms avg (${stat['count']} calls)');
    }
    
    final mostFrequent = getMostFrequentOperations(limit: 5);
    print('\nMost frequent operations:');
    for (final stat in mostFrequent) {
      print('  ${stat['operationName']}: ${stat['count']} calls (${stat['averageTime'].inMilliseconds}ms avg)');
    }
    
    print('========================\n');
  }

  // Memory usage monitoring
  static void logMemoryUsage() {
    if (!kDebugMode) return;
    
    try {
      // This is a simplified memory logging - in a real app you might use
      // platform-specific memory monitoring
      print('Memory usage logged at: ${DateTime.now()}');
    } catch (e) {
      print('Error logging memory usage: $e');
    }
  }

  // CPU usage monitoring (simplified)
  static void logCPUUsage() {
    if (!kDebugMode) return;
    
    try {
      // This is a placeholder for CPU monitoring
      // In a real app, you might use platform-specific APIs
      print('CPU usage logged at: ${DateTime.now()}');
    } catch (e) {
      print('Error logging CPU usage: $e');
    }
  }

  // Performance recommendations
  static List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final stats = getAllPerformanceStats();
    
    for (final stat in stats.values) {
      final avgTime = stat['averageTime'] as Duration;
      final count = stat['count'] as int;
      final operationName = stat['operationName'] as String;
      
      // Slow operations
      if (avgTime.inMilliseconds > 1000) {
        recommendations.add('Consider optimizing "$operationName" - average time: ${avgTime.inMilliseconds}ms');
      }
      
      // Frequent operations
      if (count > 100) {
        recommendations.add('Consider caching results for "$operationName" - called $count times');
      }
      
      // High variance operations
      final minTime = stat['minTime'] as Duration;
      final maxTime = stat['maxTime'] as Duration;
      if (maxTime.inMilliseconds > minTime.inMilliseconds * 10) {
        recommendations.add('High variance in "$operationName" performance - consider investigation');
      }
    }
    
    return recommendations;
  }

  // Export performance data
  static Map<String, dynamic> exportPerformanceData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'enabled': _isEnabled,
      'statistics': getAllPerformanceStats(),
      'recommendations': getPerformanceRecommendations(),
      'summary': {
        'totalOperations': _performanceHistory.length,
        'totalCalls': _operationCounts.values.fold(0, (a, b) => a + b),
        'totalTime': _totalTimes.values.fold(Duration.zero, (a, b) => a + b),
      },
    };
  }

  // Initialize performance monitoring
  static void initialize() {
    if (kDebugMode) {
      print('Performance monitoring initialized');
      
      // Log performance summary periodically in debug mode
      Timer.periodic(const Duration(minutes: 5), (timer) {
        logPerformanceSummary();
      });
    }
  }

  // Dispose performance monitoring
  static void dispose() {
    clearPerformanceData();
    if (kDebugMode) {
      print('Performance monitoring disposed');
    }
  }
}