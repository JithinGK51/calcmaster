import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedFilter = 'All';
  String _result = '';
  bool _isTTSEnabled = false;
  List<Map<String, dynamic>> _historyItems = [];

  final List<String> _filters = [
    'All',
    'Calculator',
    'Algebra',
    'Geometry',
    'Finance',
    'Health',
    'Unit Converter',
    'Currency Converter',
    'Graph',
    'Budget',
    'Reminder',
    'Vault',
  ];

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _loadMockHistory();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  void _loadMockHistory() {
    // Mock history data for demonstration
    _historyItems = [
      {
        'id': 1,
        'type': 'Calculator',
        'expression': '2 + 3 × 4',
        'result': '14',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'category': 'Basic',
      },
      {
        'id': 2,
        'type': 'Algebra',
        'expression': 'x² + 5x + 6 = 0',
        'result': 'x = -2, x = -3',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'category': 'Quadratic',
      },
      {
        'id': 3,
        'type': 'Geometry',
        'expression': 'Circle Area (r=5)',
        'result': '78.54 cm²',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'category': 'Area',
      },
      {
        'id': 4,
        'type': 'Finance',
        'expression': 'EMI Calculator (₹10L, 8.5%, 20 years)',
        'result': '₹8,697.50',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'category': 'Loan',
      },
      {
        'id': 5,
        'type': 'Health',
        'expression': 'BMI Calculator (70kg, 175cm)',
        'result': '22.86 (Normal)',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'category': 'BMI',
      },
      {
        'id': 6,
        'type': 'Unit Converter',
        'expression': '100 km to miles',
        'result': '62.14 miles',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'category': 'Length',
      },
      {
        'id': 7,
        'type': 'Currency Converter',
        'expression': '100 USD to EUR',
        'result': '92.00 EUR',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'category': 'Exchange',
      },
      {
        'id': 8,
        'type': 'Graph',
        'expression': 'y = x²',
        'result': 'Parabola plotted',
        'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
        'category': 'Function',
      },
      {
        'id': 9,
        'type': 'Budget',
        'expression': 'Added expense: ₹500 (Food)',
        'result': 'Balance: ₹2,500',
        'timestamp': DateTime.now().subtract(const Duration(hours: 7)),
        'category': 'Expense',
      },
      {
        'id': 10,
        'type': 'Reminder',
        'expression': 'Meeting at 3 PM',
        'result': 'Reminder set for 3:00 PM',
        'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
        'category': 'Schedule',
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedFilter == 'All') {
      return _historyItems;
    }
    return _historyItems.where((item) => item['type'] == _selectedFilter).toList();
  }

  void _clearHistory() {
    setState(() {
      _historyItems.clear();
      _result = 'History cleared successfully';
    });
  }

  void _exportHistory() {
    final filteredItems = _filteredHistory;
    final exportData = filteredItems.map((item) {
      return '${item['timestamp'].toString().split(' ')[0]} | ${item['type']} | ${item['expression']} | ${item['result']}';
    }).join('\n');

    setState(() {
      _result = 'History Export (${filteredItems.length} items)\n\n$exportData';
    });
  }

  void _deleteItem(int id) {
    setState(() {
      _historyItems.removeWhere((item) => item['id'] == id);
      _result = 'Item deleted from history';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredHistory = _filteredHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareHistoryResult(_result);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        items: _filters.map((filter) {
                          return DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _exportHistory,
                      icon: const Icon(Icons.download),
                      label: const Text('Export'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearHistory,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _result = 'History Statistics\n\n'
                                     'Total Items: ${_historyItems.length}\n'
                                     'Filtered Items: ${filteredHistory.length}\n'
                                     'Most Used: ${_getMostUsedType()}\n'
                                     'Recent Activity: ${_getRecentActivity()}';
                          });
                        },
                        icon: const Icon(Icons.analytics),
                        label: const Text('Statistics'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // History List
          Expanded(
            child: filteredHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No history items found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start using the app to see your calculation history',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      final item = filteredHistory[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getTypeColor(item['type']),
                            child: Icon(
                              _getTypeIcon(item['type']),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            item['expression'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Result: ${item['result']}',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${item['timestamp'].toString().split(' ')[0]} at ${item['timestamp'].toString().split(' ')[1].substring(0, 5)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'copy',
                                child: const Row(
                                  children: [
                                    Icon(Icons.copy),
                                    SizedBox(width: 8),
                                    Text('Copy'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'copy') {
                                Clipboard.setData(ClipboardData(
                                  text: '${item['expression']} = ${item['result']}',
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied to clipboard')),
                                );
                              } else if (value == 'delete') {
                                _deleteItem(item['id']);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Result Section
          if (_result.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Result',
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
                                    await TTSService.speakHistoryResult('operation', _result);
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _result));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Result copied to clipboard')),
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
            ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Calculator':
        return Colors.blue;
      case 'Algebra':
        return Colors.green;
      case 'Geometry':
        return Colors.orange;
      case 'Finance':
        return Colors.purple;
      case 'Health':
        return Colors.red;
      case 'Unit Converter':
        return Colors.teal;
      case 'Currency Converter':
        return Colors.indigo;
      case 'Graph':
        return Colors.pink;
      case 'Budget':
        return Colors.brown;
      case 'Reminder':
        return Colors.cyan;
      case 'Vault':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Calculator':
        return Icons.calculate;
      case 'Algebra':
        return Icons.functions;
      case 'Geometry':
        return Icons.square_foot;
      case 'Finance':
        return Icons.account_balance_wallet;
      case 'Health':
        return Icons.favorite;
      case 'Unit Converter':
        return Icons.swap_horiz;
      case 'Currency Converter':
        return Icons.currency_exchange;
      case 'Graph':
        return Icons.show_chart;
      case 'Budget':
        return Icons.account_balance;
      case 'Reminder':
        return Icons.alarm;
      case 'Vault':
        return Icons.lock;
      default:
        return Icons.history;
    }
  }

  String _getMostUsedType() {
    if (_historyItems.isEmpty) return 'None';
    
    final typeCounts = <String, int>{};
    for (final item in _historyItems) {
      typeCounts[item['type']] = (typeCounts[item['type']] ?? 0) + 1;
    }
    
    return typeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String _getRecentActivity() {
    if (_historyItems.isEmpty) return 'None';
    
    final now = DateTime.now();
    final recentItems = _historyItems.where((item) {
      final diff = now.difference(item['timestamp']);
      return diff.inHours < 24;
    }).length;
    
    return '$recentItems items in last 24 hours';
  }
}