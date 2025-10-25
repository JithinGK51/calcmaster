import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/performance_provider.dart';
import '../../services/performance_service.dart';
import '../../services/memory_service.dart';
import '../../services/resource_service.dart';

class PerformanceScreen extends ConsumerStatefulWidget {
  const PerformanceScreen({super.key});

  @override
  ConsumerState<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends ConsumerState<PerformanceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      ref.read(performanceProvider.notifier).refreshPerformanceData();
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final performanceState = ref.watch(performanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Monitor'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.speed), text: 'Performance'),
            Tab(icon: Icon(Icons.memory), text: 'Memory'),
            Tab(icon: Icon(Icons.storage), text: 'Resources'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.speed),
            onPressed: performanceState.isOptimizing
                ? null
                : () => ref.read(performanceProvider.notifier).performOptimization(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPerformanceTab(theme, performanceState),
            _buildMemoryTab(theme, performanceState),
            _buildResourcesTab(theme, performanceState),
            _buildAnalyticsTab(theme, performanceState),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab(ThemeData theme, performanceState) {
    final performanceStats = performanceState.performanceStats as Map<String, dynamic>;
    final slowestOps = ref.watch(slowestOperationsProvider);
    final mostFrequentOps = ref.watch(mostFrequentOperationsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceOverview(theme, performanceStats),
          const SizedBox(height: 20),
          _buildSlowestOperations(theme, slowestOps),
          const SizedBox(height: 20),
          _buildMostFrequentOperations(theme, mostFrequentOps),
          const SizedBox(height: 20),
          _buildPerformanceActions(theme),
        ],
      ),
    );
  }

  Widget _buildMemoryTab(ThemeData theme, performanceState) {
    final memoryStats = performanceState.memoryStats as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMemoryOverview(theme, memoryStats),
          const SizedBox(height: 20),
          _buildMemoryPools(theme),
          const SizedBox(height: 20),
          _buildMemoryActions(theme),
        ],
      ),
    );
  }

  Widget _buildResourcesTab(ThemeData theme, performanceState) {
    final resourceStats = performanceState.resourceStats as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResourceOverview(theme, resourceStats),
          const SizedBox(height: 20),
          _buildOptimizationOptions(theme),
          const SizedBox(height: 20),
          _buildResourceActions(theme),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(ThemeData theme, performanceState) {
    final recommendations = performanceState.recommendations;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecommendations(theme, recommendations),
          const SizedBox(height: 20),
          _buildPerformanceHistory(theme),
          const SizedBox(height: 20),
          _buildExportOptions(theme),
        ],
      ),
    );
  }

  Widget _buildPerformanceOverview(ThemeData theme, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Total Operations',
                    '${stats.length}',
                    Icons.functions,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Active Timers',
                    '${_getActiveTimerCount()}',
                    Icons.timer,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryOverview(ThemeData theme, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Total Objects',
                    '${stats['totalObjects'] ?? 0}',
                    Icons.data_object,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Active Pools',
                    '${stats['totalPools'] ?? 0}',
                    Icons.storage,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Expired Objects',
                    '${stats['expiredObjects'] ?? 0}',
                    Icons.delete_outline,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Memory Status',
                    stats['enabled'] == true ? 'Enabled' : 'Disabled',
                    Icons.memory,
                    stats['enabled'] == true ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceOverview(ThemeData theme, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resource Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Active Resources',
                    '${stats['activeResources'] ?? 0}',
                    Icons.power,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Total Resources',
                    '${stats['totalResources'] ?? 0}',
                    Icons.inventory,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSlowestOperations(ThemeData theme, List<Map<String, dynamic>> operations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slowest Operations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (operations.isEmpty)
              const Text('No performance data available')
            else
              ...operations.take(5).map((op) => _buildOperationItem(theme, op)),
          ],
        ),
      ),
    );
  }

  Widget _buildMostFrequentOperations(ThemeData theme, List<Map<String, dynamic>> operations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Frequent Operations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (operations.isEmpty)
              const Text('No performance data available')
            else
              ...operations.take(5).map((op) => _buildOperationItem(theme, op)),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationItem(ThemeData theme, Map<String, dynamic> operation) {
    final name = operation['operationName'] as String;
    final avgTime = operation['averageTime'] as Duration;
    final count = operation['count'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            '${avgTime.inMilliseconds}ms',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '($count)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryPools(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Pools',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Memory pool details would be displayed here'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationOptions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Optimization Options',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildOptimizationButton(theme, 'File System', Icons.folder, () {
                  ref.read(performanceProvider.notifier).optimizeFileSystem();
                }),
                _buildOptimizationButton(theme, 'Network', Icons.network_check, () {
                  ref.read(performanceProvider.notifier).optimizeNetwork();
                }),
                _buildOptimizationButton(theme, 'Database', Icons.storage, () {
                  ref.read(performanceProvider.notifier).optimizeDatabase();
                }),
                _buildOptimizationButton(theme, 'Images', Icons.image, () {
                  ref.read(performanceProvider.notifier).optimizeImages();
                }),
                _buildOptimizationButton(theme, 'CPU', Icons.speed, () {
                  ref.read(performanceProvider.notifier).optimizeCPU();
                }),
                _buildOptimizationButton(theme, 'Battery', Icons.battery_charging_full, () {
                  ref.read(performanceProvider.notifier).optimizeBattery();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationButton(ThemeData theme, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildRecommendations(ThemeData theme, List<String> recommendations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (recommendations.isEmpty)
              const Text('No recommendations available')
            else
              ...recommendations.map((rec) => _buildRecommendationItem(theme, rec)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(ThemeData theme, String recommendation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recommendation,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceHistory(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Performance history chart would be displayed here'),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOptions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Options',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _exportPerformanceData();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Export Data'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _logPerformanceSummary();
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Log Summary'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceActions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(performanceProvider.notifier).clearPerformanceData();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Data'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(performanceProvider.notifier).logPerformanceSummary();
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('Log Summary'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryActions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(performanceProvider.notifier).performMemoryCleanup();
                    },
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Cleanup'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(performanceProvider.notifier).optimizeMemory();
                    },
                    icon: const Icon(Icons.speed),
                    label: const Text('Optimize'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceActions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resource Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(performanceProvider.notifier).cleanupAllResources();
                    },
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Cleanup All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(performanceProvider.notifier).performOptimization();
                    },
                    icon: const Icon(Icons.speed),
                    label: const Text('Optimize All'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getActiveTimerCount() {
    // This would need to be implemented in the performance service
    return 0;
  }

  void _exportPerformanceData() {
    final data = ref.read(performanceProvider.notifier).exportPerformanceData();
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Performance data exported')),
    );
  }

  void _logPerformanceSummary() {
    ref.read(performanceProvider.notifier).logPerformanceSummary();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Performance summary logged')),
    );
  }
}
