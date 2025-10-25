import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class StatsInsightsScreen extends ConsumerStatefulWidget {
  const StatsInsightsScreen({super.key});

  @override
  ConsumerState<StatsInsightsScreen> createState() => _StatsInsightsScreenState();
}

class _StatsInsightsScreenState extends ConsumerState<StatsInsightsScreen> {
  String _selectedPeriod = 'Last 7 Days';
  String _result = '';
  bool _isTTSEnabled = false;

  final List<String> _periods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'Last Year',
    'All Time'
  ];

  // Mock data for demonstration
  final Map<String, Map<String, dynamic>> _mockStats = {
    'Last 7 Days': {
      'calculations': 45,
      'timeSpent': '2h 30m',
      'mostUsed': 'Basic Calculator',
      'accuracy': 98.5,
      'favoriteTheme': 'Dark',
      'topCategory': 'Finance',
    },
    'Last 30 Days': {
      'calculations': 180,
      'timeSpent': '12h 15m',
      'mostUsed': 'Scientific Calculator',
      'accuracy': 97.2,
      'favoriteTheme': 'Dark',
      'topCategory': 'Health',
    },
    'Last 3 Months': {
      'calculations': 520,
      'timeSpent': '35h 45m',
      'mostUsed': 'Algebra Solver',
      'accuracy': 96.8,
      'favoriteTheme': 'Cyberpunk',
      'topCategory': 'Geometry',
    },
    'Last 6 Months': {
      'calculations': 1050,
      'timeSpent': '72h 20m',
      'mostUsed': 'Unit Converter',
      'accuracy': 97.1,
      'favoriteTheme': 'Nature',
      'topCategory': 'Finance',
    },
    'Last Year': {
      'calculations': 2100,
      'timeSpent': '145h 30m',
      'mostUsed': 'Budget Manager',
      'accuracy': 96.5,
      'favoriteTheme': 'Galaxy',
      'topCategory': 'Health',
    },
    'All Time': {
      'calculations': 2100,
      'timeSpent': '145h 30m',
      'mostUsed': 'Budget Manager',
      'accuracy': 96.5,
      'favoriteTheme': 'Galaxy',
      'topCategory': 'Health',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _generateStats();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  void _generateStats() {
    final stats = _mockStats[_selectedPeriod]!;
    
    setState(() {
      _result = 'Usage Statistics - $_selectedPeriod\n\n'
               'Total Calculations: ${stats['calculations']}\n'
               'Time Spent: ${stats['timeSpent']}\n'
               'Most Used Feature: ${stats['mostUsed']}\n'
               'Accuracy Rate: ${stats['accuracy']}%\n'
               'Favorite Theme: ${stats['favoriteTheme']}\n'
               'Top Category: ${stats['topCategory']}\n\n'
               'Insights:\n'
               '• You\'re most productive in the morning\n'
               '• Finance calculations are your specialty\n'
               '• You prefer dark themes for better focus\n'
               '• Your accuracy has improved over time\n'
               '• You use the app consistently daily';
    });
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _generateStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _mockStats[_selectedPeriod]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics & Insights'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareStatsResult(_result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Period Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Period',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedPeriod,
                      isExpanded: true,
                      items: _periods.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                      onChanged: (value) => _onPeriodChanged(value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Key Metrics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Metrics',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Calculations',
                            '${stats['calculations']}',
                            Icons.calculate,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Time Spent',
                            '${stats['timeSpent']}',
                            Icons.access_time,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Accuracy',
                            '${stats['accuracy']}%',
                            Icons.gps_fixed,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Top Category',
                            '${stats['topCategory']}',
                            Icons.category,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Usage Breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage Breakdown',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildUsageItem('Calculator', 35, Colors.blue),
                    _buildUsageItem('Finance Tools', 25, Colors.green),
                    _buildUsageItem('Health Calculators', 20, Colors.red),
                    _buildUsageItem('Unit Converter', 15, Colors.orange),
                    _buildUsageItem('Other Tools', 5, Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Achievements
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAchievement('First Calculation', 'Completed your first calculation', Icons.star, true),
                    _buildAchievement('Power User', 'Used the app for 100+ hours', Icons.emoji_events, true),
                    _buildAchievement('Accuracy Master', 'Achieved 95%+ accuracy', Icons.gps_fixed, true),
                    _buildAchievement('Theme Explorer', 'Tried 5+ different themes', Icons.palette, false),
                    _buildAchievement('Budget Pro', 'Used budget manager 50+ times', Icons.account_balance_wallet, false),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result Section
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Detailed Report',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (_isTTSEnabled)
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await TTSService.speakStatsResult('insights', _result);
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _result));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Report copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _result,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Tips for Improvement
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips for Improvement',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildImprovementTip('Try using different themes to find your preference'),
                    _buildImprovementTip('Explore advanced features like algebra solver'),
                    _buildImprovementTip('Use the budget manager for better financial planning'),
                    _buildImprovementTip('Set reminders for regular app usage'),
                    _buildImprovementTip('Share your calculations with others'),
                    _buildImprovementTip('Keep your vault organized and secure'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(String category, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category),
              Text('$percentage%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement(String title, String description, IconData icon, bool unlocked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: unlocked ? Colors.amber : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: unlocked ? null : Colors.grey,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: unlocked ? null : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            unlocked ? Icons.check_circle : Icons.lock,
            color: unlocked ? Colors.green : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}