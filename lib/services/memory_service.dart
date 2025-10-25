import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MemoryService {
  static final Map<String, dynamic> _memoryPools = {};
  static final Map<String, int> _objectCounts = {};
  static final Map<String, DateTime> _lastAccessTimes = {};
  static Timer? _cleanupTimer;
  static bool _isEnabled = true;
  static const Duration _cleanupInterval = Duration(minutes: 5);
  static const Duration _objectLifetime = Duration(minutes: 30);

  // Enable/disable memory management
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (enabled) {
      _startCleanupTimer();
    } else {
      _stopCleanupTimer();
    }
    
    if (kDebugMode) {
      print('Memory management ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  // Start automatic cleanup timer
  static void _startCleanupTimer() {
    _stopCleanupTimer();
    _cleanupTimer = Timer.periodic(_cleanupInterval, (timer) {
      performCleanup();
    });
  }

  // Stop automatic cleanup timer
  static void _stopCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  // Register an object in memory pool
  static void registerObject(String poolName, String objectId, dynamic object) {
    if (!_isEnabled) return;
    
    _memoryPools.putIfAbsent(poolName, () => {});
    _memoryPools[poolName]![objectId] = object;
    _objectCounts[poolName] = (_objectCounts[poolName] ?? 0) + 1;
    _lastAccessTimes['$poolName:$objectId'] = DateTime.now();
    
    if (kDebugMode) {
      print('Registered object $objectId in pool $poolName');
    }
  }

  // Get an object from memory pool
  static T? getObject<T>(String poolName, String objectId) {
    if (!_isEnabled) return null;
    
    final pool = _memoryPools[poolName];
    if (pool == null || !pool.containsKey(objectId)) {
      return null;
    }
    
    // Update last access time
    _lastAccessTimes['$poolName:$objectId'] = DateTime.now();
    
    return pool[objectId] as T?;
  }

  // Remove an object from memory pool
  static void removeObject(String poolName, String objectId) {
    if (!_isEnabled) return;
    
    final pool = _memoryPools[poolName];
    if (pool != null && pool.containsKey(objectId)) {
      pool.remove(objectId);
      _objectCounts[poolName] = (_objectCounts[poolName] ?? 1) - 1;
      _lastAccessTimes.remove('$poolName:$objectId');
      
      if (kDebugMode) {
        print('Removed object $objectId from pool $poolName');
      }
    }
  }

  // Clear a memory pool
  static void clearPool(String poolName) {
    if (!_isEnabled) return;
    
    final pool = _memoryPools[poolName];
    if (pool != null) {
      final objectIds = pool.keys.toList();
      for (final objectId in objectIds) {
        _lastAccessTimes.remove('$poolName:$objectId');
      }
      
      pool.clear();
      _objectCounts[poolName] = 0;
      
      if (kDebugMode) {
        print('Cleared pool $poolName');
      }
    }
  }

  // Perform memory cleanup
  static void performCleanup() {
    if (!_isEnabled) return;
    
    final now = DateTime.now();
    final expiredObjects = <String>[];
    
    // Find expired objects
    _lastAccessTimes.forEach((key, lastAccess) {
      if (now.difference(lastAccess) > _objectLifetime) {
        expiredObjects.add(key);
      }
    });
    
    // Remove expired objects
    for (final key in expiredObjects) {
      final parts = key.split(':');
      if (parts.length == 2) {
        final poolName = parts[0];
        final objectId = parts[1];
        removeObject(poolName, objectId);
      }
    }
    
    if (kDebugMode && expiredObjects.isNotEmpty) {
      print('Cleaned up ${expiredObjects.length} expired objects');
    }
  }

  // Get memory pool statistics
  static Map<String, dynamic> getPoolStats(String poolName) {
    final pool = _memoryPools[poolName];
    final count = _objectCounts[poolName] ?? 0;
    
    return {
      'poolName': poolName,
      'objectCount': count,
      'exists': pool != null,
      'isEmpty': pool?.isEmpty ?? true,
    };
  }

  // Get all memory pool statistics
  static Map<String, Map<String, dynamic>> getAllPoolStats() {
    final stats = <String, Map<String, dynamic>>{};
    
    for (final poolName in _memoryPools.keys) {
      stats[poolName] = getPoolStats(poolName);
    }
    
    return stats;
  }

  // Get memory usage summary
  static Map<String, dynamic> getMemorySummary() {
    final totalObjects = _objectCounts.values.fold(0, (a, b) => a + b);
    final totalPools = _memoryPools.length;
    final expiredObjects = _getExpiredObjectCount();
    
    return {
      'totalObjects': totalObjects,
      'totalPools': totalPools,
      'expiredObjects': expiredObjects,
      'enabled': _isEnabled,
      'lastCleanup': DateTime.now().toIso8601String(),
    };
  }

  // Get count of expired objects
  static int _getExpiredObjectCount() {
    final now = DateTime.now();
    int count = 0;
    
    _lastAccessTimes.forEach((key, lastAccess) {
      if (now.difference(lastAccess) > _objectLifetime) {
        count++;
      }
    });
    
    return count;
  }

  // Force garbage collection (if available)
  static void forceGarbageCollection() {
    if (kDebugMode) {
      print('Forcing garbage collection...');
      // In Flutter, we can't directly force GC, but we can suggest it
      developer.log('Memory cleanup requested', name: 'MemoryService');
    }
  }

  // Optimize memory usage
  static void optimizeMemory() {
    if (!_isEnabled) return;
    
    // Perform cleanup
    performCleanup();
    
    // Clear empty pools
    final emptyPools = <String>[];
    _memoryPools.forEach((poolName, pool) {
      if (pool.isEmpty) {
        emptyPools.add(poolName);
      }
    });
    
    for (final poolName in emptyPools) {
      _memoryPools.remove(poolName);
      _objectCounts.remove(poolName);
    }
    
    // Force garbage collection
    forceGarbageCollection();
    
    if (kDebugMode) {
      print('Memory optimization completed');
    }
  }

  // Memory pool for calculation results
  static void cacheCalculationResult(String expression, dynamic result) {
    registerObject('calculations', expression, result);
  }

  static dynamic getCachedCalculationResult(String expression) {
    return getObject('calculations', expression);
  }

  // Memory pool for theme data
  static void cacheThemeData(String themeName, dynamic themeData) {
    registerObject('themes', themeName, themeData);
  }

  static dynamic getCachedThemeData(String themeName) {
    return getObject('themes', themeName);
  }

  // Memory pool for user preferences
  static void cacheUserPreferences(dynamic preferences) {
    registerObject('preferences', 'user', preferences);
  }

  static dynamic getCachedUserPreferences() {
    return getObject('preferences', 'user');
  }

  // Memory pool for currency rates
  static void cacheCurrencyRates(dynamic rates) {
    registerObject('currency', 'rates', rates);
  }

  static dynamic getCachedCurrencyRates() {
    return getObject('currency', 'rates');
  }

  // Memory pool for health calculations
  static void cacheHealthCalculation(String type, Map<String, dynamic> inputs, dynamic result) {
    final key = '${type}_${inputs.hashCode}';
    registerObject('health', key, result);
  }

  static dynamic getCachedHealthCalculation(String type, Map<String, dynamic> inputs) {
    final key = '${type}_${inputs.hashCode}';
    return getObject('health', key);
  }

  // Memory pool for budget data
  static void cacheBudgetData(String budgetId, dynamic budgetData) {
    registerObject('budgets', budgetId, budgetData);
  }

  static dynamic getCachedBudgetData(String budgetId) {
    return getObject('budgets', budgetId);
  }

  // Memory pool for reminder data
  static void cacheReminderData(dynamic reminders) {
    registerObject('reminders', 'all', reminders);
  }

  static dynamic getCachedReminderData() {
    return getObject('reminders', 'all');
  }

  // Memory pool for vault metadata
  static void cacheVaultMetadata(dynamic vaultData) {
    registerObject('vault', 'metadata', vaultData);
  }

  static dynamic getCachedVaultMetadata() {
    return getObject('vault', 'metadata');
  }

  // Memory pool for statistics data
  static void cacheStatisticsData(dynamic statistics) {
    registerObject('statistics', 'all', statistics);
  }

  static dynamic getCachedStatisticsData() {
    return getObject('statistics', 'all');
  }

  // Clear all memory pools
  static void clearAllPools() {
    _memoryPools.clear();
    _objectCounts.clear();
    _lastAccessTimes.clear();
    
    if (kDebugMode) {
      print('All memory pools cleared');
    }
  }

  // Initialize memory service
  static void initialize() {
    setEnabled(true);
    
    if (kDebugMode) {
      print('Memory service initialized');
    }
  }

  // Dispose memory service
  static void dispose() {
    setEnabled(false);
    clearAllPools();
    
    if (kDebugMode) {
      print('Memory service disposed');
    }
  }

  // Log memory usage
  static void logMemoryUsage() {
    if (!kDebugMode) return;
    
    final summary = getMemorySummary();
    print('\n=== Memory Usage ===');
    print('Total objects: ${summary['totalObjects']}');
    print('Total pools: ${summary['totalPools']}');
    print('Expired objects: ${summary['expiredObjects']}');
    print('Enabled: ${summary['enabled']}');
    
    final poolStats = getAllPoolStats();
    if (poolStats.isNotEmpty) {
      print('\nPool details:');
      poolStats.forEach((poolName, stats) {
        print('  $poolName: ${stats['objectCount']} objects');
      });
    }
    
    print('==================\n');
  }

  // Memory recommendations
  static List<String> getMemoryRecommendations() {
    final recommendations = <String>[];
    final summary = getMemorySummary();
    
    final totalObjects = summary['totalObjects'] as int;
    final expiredObjects = summary['expiredObjects'] as int;
    
    if (totalObjects > 1000) {
      recommendations.add('High memory usage detected. Consider clearing unused pools.');
    }
    
    if (expiredObjects > 100) {
      recommendations.add('Many expired objects found. Run memory cleanup.');
    }
    
    final poolStats = getAllPoolStats();
    for (final entry in poolStats.entries) {
      final poolName = entry.key;
      final stats = entry.value;
      final objectCount = stats['objectCount'] as int;
      
      if (objectCount > 500) {
        recommendations.add('Pool "$poolName" has many objects ($objectCount). Consider optimization.');
      }
    }
    
    return recommendations;
  }

  // Export memory data
  static Map<String, dynamic> exportMemoryData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'summary': getMemorySummary(),
      'poolStats': getAllPoolStats(),
      'recommendations': getMemoryRecommendations(),
    };
  }
}
