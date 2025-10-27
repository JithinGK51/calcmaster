import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/performance_service.dart';
import '../services/memory_service.dart';
import '../services/resource_service.dart';
import '../services/cache_service.dart';

// Performance monitoring state
class PerformanceState {
  final bool isEnabled;
  final Map<String, dynamic> performanceStats;
  final Map<String, dynamic> memoryStats;
  final Map<String, dynamic> resourceStats;
  final List<String> recommendations;
  final bool isOptimizing;

  const PerformanceState({
    this.isEnabled = true,
    this.performanceStats = const {},
    this.memoryStats = const {},
    this.resourceStats = const {},
    this.recommendations = const [],
    this.isOptimizing = false,
  });

  PerformanceState copyWith({
    bool? isEnabled,
    Map<String, dynamic>? performanceStats,
    Map<String, dynamic>? memoryStats,
    Map<String, dynamic>? resourceStats,
    List<String>? recommendations,
    bool? isOptimizing,
  }) {
    return PerformanceState(
      isEnabled: isEnabled ?? this.isEnabled,
      performanceStats: performanceStats ?? this.performanceStats,
      memoryStats: memoryStats ?? this.memoryStats,
      resourceStats: resourceStats ?? this.resourceStats,
      recommendations: recommendations ?? this.recommendations,
      isOptimizing: isOptimizing ?? this.isOptimizing,
    );
  }
}

// Performance provider
class PerformanceNotifier extends StateNotifier<PerformanceState> {
  PerformanceNotifier() : super(const PerformanceState()) {
    _initialize();
  }

  void _initialize() {
    // Initialize services
    PerformanceService.initialize();
    MemoryService.initialize();
    ResourceService.initialize();
    
    // Load initial state
    _loadPerformanceData();
  }

  // Load performance data
  void _loadPerformanceData() {
    final performanceStats = PerformanceService.getAllPerformanceStats();
    final memoryStats = MemoryService.getMemorySummary();
    final resourceStats = ResourceService.getResourceStats();
    final recommendations = _getAllRecommendations();

    state = state.copyWith(
      performanceStats: performanceStats,
      memoryStats: memoryStats,
      resourceStats: resourceStats,
      recommendations: recommendations,
    );
  }

  // Get all recommendations
  List<String> _getAllRecommendations() {
    final recommendations = <String>[];
    
    // Performance recommendations
    recommendations.addAll(PerformanceService.getPerformanceRecommendations());
    
    // Memory recommendations
    recommendations.addAll(MemoryService.getMemoryRecommendations());
    
    // Resource recommendations
    recommendations.addAll(ResourceService.getOptimizationRecommendations());
    
    return recommendations;
  }

  // Enable/disable performance monitoring
  void setEnabled(bool enabled) {
    PerformanceService.setEnabled(enabled);
    MemoryService.setEnabled(enabled);
    ResourceService.setEnabled(enabled);
    
    state = state.copyWith(isEnabled: enabled);
  }

  // Start timing an operation
  void startTimer(String operationName) {
    PerformanceService.startTimer(operationName);
  }

  // Stop timing an operation
  void stopTimer(String operationName) {
    PerformanceService.stopTimer(operationName);
    _loadPerformanceData();
  }

  // Measure operation execution time
  Future<T> measureAsync<T>(String operationName, Future<T> Function() operation) async {
    return await PerformanceService.measureAsync(operationName, operation);
  }

  // Measure synchronous operation execution time
  T measure<T>(String operationName, T Function() operation) {
    return PerformanceService.measure(operationName, operation);
  }

  // Get performance statistics for an operation
  Map<String, dynamic>? getOperationStats(String operationName) {
    return PerformanceService.getPerformanceStats(operationName);
  }

  // Get slowest operations
  List<Map<String, dynamic>> getSlowestOperations({int limit = 10}) {
    return PerformanceService.getSlowestOperations(limit: limit);
  }

  // Get most frequent operations
  List<Map<String, dynamic>> getMostFrequentOperations({int limit = 10}) {
    return PerformanceService.getMostFrequentOperations(limit: limit);
  }

  // Clear performance data
  void clearPerformanceData() {
    PerformanceService.clearPerformanceData();
    _loadPerformanceData();
  }

  // Clear operation data
  void clearOperationData(String operationName) {
    PerformanceService.clearOperationData(operationName);
    _loadPerformanceData();
  }

  // Memory management
  void registerObject(String poolName, String objectId, dynamic object) {
    MemoryService.registerObject(poolName, objectId, object);
  }

  T? getObject<T>(String poolName, String objectId) {
    return MemoryService.getObject<T>(poolName, objectId);
  }

  void removeObject(String poolName, String objectId) {
    MemoryService.removeObject(poolName, objectId);
  }

  void clearPool(String poolName) {
    MemoryService.clearPool(poolName);
  }

  void performMemoryCleanup() {
    MemoryService.performCleanup();
    _loadPerformanceData();
  }

  void optimizeMemory() {
    MemoryService.optimizeMemory();
    _loadPerformanceData();
  }

  // Resource management
  void registerResource(String resourceId, {Duration? timeout}) {
    ResourceService.registerResource(resourceId, timeout: timeout);
  }

  void cleanupResource(String resourceId) {
    ResourceService.cleanupResource(resourceId);
  }

  bool isResourceActive(String resourceId) {
    return ResourceService.isResourceActive(resourceId);
  }

  void extendResourceLifetime(String resourceId, {Duration? timeout}) {
    ResourceService.extendResourceLifetime(resourceId, timeout: timeout);
  }

  void cleanupAllResources() {
    ResourceService.cleanupAllResources();
  }

  // Cache management
  Future<void> cache(String key, dynamic data, {Duration? expiry}) async {
    await CacheService.cache(key, data, expiry: expiry);
  }

  Future<T?> getFromCache<T>(String key) async {
    return await CacheService.get<T>(key);
  }

  Future<void> removeFromCache(String key) async {
    await CacheService.remove(key);
  }

  Future<void> clearAllCache() async {
    await CacheService.clearAll();
  }

  // Optimization
  Future<void> performOptimization() async {
    state = state.copyWith(isOptimizing: true);
    
    try {
      // Perform comprehensive optimization
      await ResourceService.performComprehensiveOptimization();
      
      // Optimize memory
      MemoryService.optimizeMemory();
      
      // Clear old cache
      await CacheService.clearAll();
      
      // Reload data
      _loadPerformanceData();
      
      if (kDebugMode) {
        print('Performance optimization completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during optimization: $e');
      }
    } finally {
      state = state.copyWith(isOptimizing: false);
    }
  }

  // File system optimization
  Future<void> optimizeFileSystem() async {
    await ResourceService.optimizeFileSystem();
    _loadPerformanceData();
  }

  // Network optimization
  void optimizeNetwork() {
    ResourceService.optimizeNetwork();
    _loadPerformanceData();
  }

  // Database optimization
  Future<void> optimizeDatabase() async {
    await ResourceService.optimizeDatabase();
    _loadPerformanceData();
  }

  // Image optimization
  Future<void> optimizeImages() async {
    await ResourceService.optimizeImages();
    _loadPerformanceData();
  }

  // CPU optimization
  void optimizeCPU() {
    ResourceService.optimizeCPU();
    _loadPerformanceData();
  }

  // Battery optimization
  void optimizeBattery() {
    ResourceService.optimizeBattery();
    _loadPerformanceData();
  }

  // Log performance summary
  void logPerformanceSummary() {
    PerformanceService.logPerformanceSummary();
    MemoryService.logMemoryUsage();
    ResourceService.logResourceUsage();
  }

  // Export performance data
  Map<String, dynamic> exportPerformanceData() {
    return {
      'performance': PerformanceService.exportPerformanceData(),
      'memory': MemoryService.exportMemoryData(),
      'resources': ResourceService.exportResourceData(),
      'cache': CacheService.getCacheStats(),
    };
  }

  // Refresh performance data
  void refreshPerformanceData() {
    _loadPerformanceData();
  }

  // Dispose
  @override
  void dispose() {
    PerformanceService.dispose();
    MemoryService.dispose();
    ResourceService.dispose();
    super.dispose();
  }
}

// Provider
final performanceProvider = StateNotifierProvider<PerformanceNotifier, PerformanceState>((ref) {
  return PerformanceNotifier();
});

// Specific operation providers
final slowestOperationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final performanceState = ref.watch(performanceProvider);
  final notifier = ref.read(performanceProvider.notifier);
  return notifier.getSlowestOperations();
});

final mostFrequentOperationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final performanceState = ref.watch(performanceProvider);
  final notifier = ref.read(performanceProvider.notifier);
  return notifier.getMostFrequentOperations();
});

final performanceRecommendationsProvider = Provider<List<String>>((ref) {
  final performanceState = ref.watch(performanceProvider);
  return performanceState.recommendations;
});

final isOptimizingProvider = Provider<bool>((ref) {
  final performanceState = ref.watch(performanceProvider);
  return performanceState.isOptimizing;
});

// Performance monitoring helpers
class PerformanceMonitor {
  static void startOperation(String operationName) {
    PerformanceService.startTimer(operationName);
  }

  static void endOperation(String operationName) {
    PerformanceService.stopTimer(operationName);
  }

  static Future<T> monitorAsync<T>(String operationName, Future<T> Function() operation) async {
    return await PerformanceService.measureAsync(operationName, operation);
  }

  static T monitor<T>(String operationName, T Function() operation) {
    return PerformanceService.measure(operationName, operation);
  }
}

// Memory management helpers
class MemoryManager {
  static void cacheCalculation(String expression, dynamic result) {
    MemoryService.cacheCalculationResult(expression, result);
  }

  static dynamic getCachedCalculation(String expression) {
    return MemoryService.getCachedCalculationResult(expression);
  }

  static void cacheTheme(String themeName, dynamic themeData) {
    MemoryService.cacheThemeData(themeName, themeData);
  }

  static dynamic getCachedTheme(String themeName) {
    return MemoryService.getCachedThemeData(themeName);
  }

  static void cachePreferences(dynamic preferences) {
    MemoryService.cacheUserPreferences(preferences);
  }

  static dynamic getCachedPreferences() {
    return MemoryService.getCachedUserPreferences();
  }
}

// Resource management helpers
class ResourceManager {
  static void registerCalculationResource(String expression) {
    ResourceService.registerResource('calc_$expression', timeout: const Duration(minutes: 10));
  }

  static void registerThemeResource(String themeName) {
    ResourceService.registerResource('theme_$themeName', timeout: const Duration(hours: 1));
  }

  static void registerUserDataResource() {
    ResourceService.registerResource('user_data', timeout: const Duration(minutes: 30));
  }

  static void cleanupCalculationResource(String expression) {
    ResourceService.cleanupResource('calc_$expression');
  }

  static void cleanupThemeResource(String themeName) {
    ResourceService.cleanupResource('theme_$themeName');
  }

  static void cleanupUserDataResource() {
    ResourceService.cleanupResource('user_data');
  }
}

// Advanced Performance Analysis
class AdvancedPerformanceAnalyzer {
  static Map<String, dynamic> getAdvancedAnalysis(PerformanceState state) {
    final analysis = <String, dynamic>{};
    
    // Performance score (0-100)
    double performanceScore = 100;
    
    // Deduct points for various issues
    if (state.performanceStats['averageCalculationTime'] > 50) {
      performanceScore -= 20;
    }
    
    if (state.memoryStats['usedMemory'] > 80 * 1024 * 1024) {
      performanceScore -= 15;
    }
    
    if (state.performanceStats['frameDrops'] > 5) {
      performanceScore -= 10;
    }
    
    if (state.resourceStats['batteryLevel'] < 30) {
      performanceScore -= 5;
    }
    
    analysis['performanceScore'] = performanceScore.clamp(0, 100);
    analysis['grade'] = _getPerformanceGrade(performanceScore);
    analysis['bottlenecks'] = _identifyBottlenecks(state);
    analysis['optimizationSuggestions'] = _getOptimizationSuggestions(state);
    
    return analysis;
  }
  
  static String _getPerformanceGrade(double score) {
    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }
  
  static List<String> _identifyBottlenecks(PerformanceState state) {
    final bottlenecks = <String>[];
    
    if (state.performanceStats['averageCalculationTime'] > 100) {
      bottlenecks.add('Calculation Performance');
    }
    
    if (state.memoryStats['usedMemory'] > 100 * 1024 * 1024) {
      bottlenecks.add('Memory Usage');
    }
    
    if (state.performanceStats['frameDrops'] > 10) {
      bottlenecks.add('UI Rendering');
    }
    
    if (state.resourceStats['batteryLevel'] < 20) {
      bottlenecks.add('Battery Life');
    }
    
    return bottlenecks;
  }
  
  static List<String> _getOptimizationSuggestions(PerformanceState state) {
    final suggestions = <String>[];
    
    if (state.performanceStats['averageCalculationTime'] > 50) {
      suggestions.add('Use more efficient algorithms for complex calculations');
      suggestions.add('Implement calculation caching for repeated operations');
    }
    
    if (state.memoryStats['usedMemory'] > 80 * 1024 * 1024) {
      suggestions.add('Clear calculation history regularly');
      suggestions.add('Optimize image and asset loading');
    }
    
    if (state.performanceStats['frameDrops'] > 5) {
      suggestions.add('Reduce animation complexity');
      suggestions.add('Use lighter theme variants');
    }
    
    return suggestions;
  }
  
  // Performance benchmarking
  static Future<Map<String, dynamic>> runBenchmark() async {
    final benchmark = <String, dynamic>{};
    
    // Calculation benchmark
    final calculationStart = DateTime.now();
    for (int i = 0; i < 1000; i++) {
      // Simulate calculation
      await Future.delayed(const Duration(microseconds: 100));
    }
    final calculationEnd = DateTime.now();
    benchmark['calculationTime'] = calculationEnd.difference(calculationStart).inMilliseconds;
    
    // Memory benchmark
    final memoryStart = DateTime.now();
    // Simulate memory operations
    await Future.delayed(const Duration(milliseconds: 5));
    final memoryEnd = DateTime.now();
    benchmark['memoryOperationTime'] = memoryEnd.difference(memoryStart).inMilliseconds;
    
    // UI benchmark
    final uiStart = DateTime.now();
    // Simulate UI operations
    await Future.delayed(const Duration(milliseconds: 10));
    final uiEnd = DateTime.now();
    benchmark['uiResponseTime'] = uiEnd.difference(uiStart).inMilliseconds;
    
    return benchmark;
  }
}
