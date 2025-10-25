import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class CacheService {
  static final Map<String, dynamic> _memoryCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _defaultExpiry = Duration(hours: 1);
  static const int _maxMemoryCacheSize = 100; // Maximum number of items in memory cache

  // Cache data in memory
  static void cacheInMemory(String key, dynamic data, {Duration? expiry}) {
    try {
      _memoryCache[key] = data;
      _cacheTimestamps[key] = DateTime.now().add(expiry ?? _defaultExpiry);
      
      // Clean up old entries if cache is too large
      if (_memoryCache.length > _maxMemoryCacheSize) {
        _cleanupMemoryCache();
      }
      
      if (kDebugMode) {
        print('Cached in memory: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error caching in memory: $e');
      }
    }
  }

  // Get data from memory cache
  static T? getFromMemoryCache<T>(String key) {
    try {
      if (_memoryCache.containsKey(key)) {
        final expiry = _cacheTimestamps[key];
        if (expiry != null && DateTime.now().isBefore(expiry)) {
          return _memoryCache[key] as T?;
        } else {
          // Cache expired, remove it
          _memoryCache.remove(key);
          _cacheTimestamps.remove(key);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting from memory cache: $e');
      }
    }
    return null;
  }

  // Cache data to disk
  static Future<void> cacheToDisk(String key, dynamic data, {Duration? expiry}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/cache');
      
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      
      final file = File('${cacheDir.path}/${_hashKey(key)}.json');
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': (expiry ?? _defaultExpiry).inMilliseconds,
      };
      
      await file.writeAsString(jsonEncode(cacheData));
      
      if (kDebugMode) {
        print('Cached to disk: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error caching to disk: $e');
      }
    }
  }

  // Get data from disk cache
  static Future<T?> getFromDiskCache<T>(String key) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/cache');
      
      if (!await cacheDir.exists()) {
        return null;
      }
      
      final file = File('${cacheDir.path}/${_hashKey(key)}.json');
      
      if (!await file.exists()) {
        return null;
      }
      
      final content = await file.readAsString();
      final cacheData = jsonDecode(content) as Map<String, dynamic>;
      
      final timestamp = cacheData['timestamp'] as int;
      final expiry = cacheData['expiry'] as int;
      
      if (DateTime.now().millisecondsSinceEpoch - timestamp > expiry) {
        // Cache expired, delete file
        await file.delete();
        return null;
      }
      
      return cacheData['data'] as T?;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting from disk cache: $e');
      }
      return null;
    }
  }

  // Cache with automatic fallback (memory first, then disk)
  static Future<void> cache(String key, dynamic data, {Duration? expiry}) async {
    // Cache in memory first
    cacheInMemory(key, data, expiry: expiry);
    
    // Also cache to disk for persistence
    await cacheToDisk(key, data, expiry: expiry);
  }

  // Get with automatic fallback (memory first, then disk)
  static Future<T?> get<T>(String key) async {
    // Try memory cache first
    final memoryResult = getFromMemoryCache<T>(key);
    if (memoryResult != null) {
      return memoryResult;
    }
    
    // Try disk cache
    final diskResult = await getFromDiskCache<T>(key);
    if (diskResult != null) {
      // Put back in memory cache for faster access
      cacheInMemory(key, diskResult);
      return diskResult;
    }
    
    return null;
  }

  // Remove from cache
  static Future<void> remove(String key) async {
    // Remove from memory
    _memoryCache.remove(key);
    _cacheTimestamps.remove(key);
    
    // Remove from disk
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/cache');
      final file = File('${cacheDir.path}/${_hashKey(key)}.json');
      
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing from disk cache: $e');
      }
    }
  }

  // Clear all cache
  static Future<void> clearAll() async {
    // Clear memory cache
    _memoryCache.clear();
    _cacheTimestamps.clear();
    
    // Clear disk cache
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/cache');
      
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing disk cache: $e');
      }
    }
  }

  // Clean up expired memory cache entries
  static void _cleanupMemoryCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    _cacheTimestamps.forEach((key, expiry) {
      if (now.isAfter(expiry)) {
        expiredKeys.add(key);
      }
    });
    
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    // If still too large, remove oldest entries
    if (_memoryCache.length > _maxMemoryCacheSize) {
      final sortedKeys = _cacheTimestamps.keys.toList()
        ..sort((a, b) => _cacheTimestamps[a]!.compareTo(_cacheTimestamps[b]!));
      
      final keysToRemove = sortedKeys.take(_memoryCache.length - _maxMemoryCacheSize);
      for (final key in keysToRemove) {
        _memoryCache.remove(key);
        _cacheTimestamps.remove(key);
      }
    }
  }

  // Hash key for file names
  static String _hashKey(String key) {
    final bytes = utf8.encode(key);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'memoryCacheSize': _memoryCache.length,
      'maxMemoryCacheSize': _maxMemoryCacheSize,
      'memoryCacheKeys': _memoryCache.keys.toList(),
    };
  }

  // Preload data into cache
  static Future<void> preload(String key, Future<dynamic> Function() dataLoader, {Duration? expiry}) async {
    try {
      final data = await dataLoader();
      await cache(key, data, expiry: expiry);
    } catch (e) {
      if (kDebugMode) {
        print('Error preloading cache: $e');
      }
    }
  }

  // Cache calculation results
  static Future<T?> getCachedCalculation<T>(String expression) async {
    final key = 'calc_${_hashKey(expression)}';
    return await get<T>(key);
  }

  static Future<void> cacheCalculation<T>(String expression, T result, {Duration? expiry}) async {
    final key = 'calc_${_hashKey(expression)}';
    await cache(key, result, expiry: expiry);
  }

  // Cache theme data
  static Future<Map<String, dynamic>?> getCachedTheme(String themeName) async {
    final key = 'theme_$themeName';
    return await get<Map<String, dynamic>>(key);
  }

  static Future<void> cacheTheme(String themeName, Map<String, dynamic> themeData) async {
    final key = 'theme_$themeName';
    await cache(key, themeData, expiry: const Duration(days: 7));
  }

  // Cache user preferences
  static Future<Map<String, dynamic>?> getCachedPreferences() async {
    const key = 'user_preferences';
    return await get<Map<String, dynamic>>(key);
  }

  static Future<void> cachePreferences(Map<String, dynamic> preferences) async {
    const key = 'user_preferences';
    await cache(key, preferences, expiry: const Duration(days: 30));
  }

  // Cache currency rates
  static Future<Map<String, double>?> getCachedCurrencyRates() async {
    const key = 'currency_rates';
    return await get<Map<String, double>>(key);
  }

  static Future<void> cacheCurrencyRates(Map<String, double> rates) async {
    const key = 'currency_rates';
    await cache(key, rates, expiry: const Duration(hours: 6));
  }

  // Cache health calculations
  static Future<Map<String, dynamic>?> getCachedHealthCalculation(String type, Map<String, dynamic> inputs) async {
    final key = 'health_${type}_${_hashKey(jsonEncode(inputs))}';
    return await get<Map<String, dynamic>>(key);
  }

  static Future<void> cacheHealthCalculation(String type, Map<String, dynamic> inputs, Map<String, dynamic> result) async {
    final key = 'health_${type}_${_hashKey(jsonEncode(inputs))}';
    await cache(key, result, expiry: const Duration(hours: 1));
  }

  // Cache budget data
  static Future<Map<String, dynamic>?> getCachedBudget(String budgetId) async {
    final key = 'budget_$budgetId';
    return await get<Map<String, dynamic>>(key);
  }

  static Future<void> cacheBudget(String budgetId, Map<String, dynamic> budgetData) async {
    final key = 'budget_$budgetId';
    await cache(key, budgetData, expiry: const Duration(hours: 1));
  }

  // Cache reminder data
  static Future<List<Map<String, dynamic>>?> getCachedReminders() async {
    const key = 'reminders';
    return await get<List<Map<String, dynamic>>>(key);
  }

  static Future<void> cacheReminders(List<Map<String, dynamic>> reminders) async {
    const key = 'reminders';
    await cache(key, reminders, expiry: const Duration(minutes: 30));
  }

  // Cache vault metadata
  static Future<List<Map<String, dynamic>>?> getCachedVaultItems() async {
    const key = 'vault_items';
    return await get<List<Map<String, dynamic>>>(key);
  }

  static Future<void> cacheVaultItems(List<Map<String, dynamic>> vaultItems) async {
    const key = 'vault_items';
    await cache(key, vaultItems, expiry: const Duration(minutes: 15));
  }

  // Cache statistics data
  static Future<Map<String, dynamic>?> getCachedStatistics() async {
    const key = 'statistics';
    return await get<Map<String, dynamic>>(key);
  }

  static Future<void> cacheStatistics(Map<String, dynamic> statistics) async {
    const key = 'statistics';
    await cache(key, statistics, expiry: const Duration(hours: 2));
  }
}
