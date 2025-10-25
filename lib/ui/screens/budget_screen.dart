import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final TextEditingController _budgetNameController = TextEditingController();
  final TextEditingController _budgetAmountController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  String _selectedCategory = 'Food';
  String _selectedType = 'Expense';
  String _result = '';
  bool _isTTSEnabled = false;
  
  double _totalIncome = 0;
  double _totalExpenses = 0;
  double _budgetBalance = 0;

  final List<String> _categories = [
    'Food', 'Transportation', 'Entertainment', 'Shopping', 'Bills',
    'Healthcare', 'Education', 'Travel', 'Savings', 'Other'
  ];

  final List<String> _types = ['Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  @override
  void dispose() {
    _budgetNameController.dispose();
    _budgetAmountController.dispose();
    _incomeController.dispose();
    _expenseController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addTransaction() {
    try {
      final amount = double.tryParse(_expenseController.text) ?? 0;
      
      if (amount <= 0) {
        _showError('Please enter a valid amount');
        return;
      }

      if (_selectedType == 'Income') {
        _totalIncome += amount;
      } else {
        _totalExpenses += amount;
      }

      _budgetBalance = _totalIncome - _totalExpenses;

      setState(() {
        _result = 'Transaction Added\n'
                 'Type: $_selectedType\n'
                 'Category: $_selectedCategory\n'
                 'Amount: ₹${amount.toStringAsFixed(2)}\n\n'
                 'Total Income: ₹${_totalIncome.toStringAsFixed(2)}\n'
                 'Total Expenses: ₹${_totalExpenses.toStringAsFixed(2)}\n'
                 'Balance: ₹${_budgetBalance.toStringAsFixed(2)}';
      });

      _expenseController.clear();

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        TTSService.speakBudgetResult('calculation', _result);
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _setBudget() {
    try {
      final budgetAmount = double.tryParse(_budgetAmountController.text) ?? 0;
      
      if (budgetAmount <= 0) {
        _showError('Please enter a valid budget amount');
        return;
      }

      setState(() {
        _result = 'Budget Set\n'
                 'Budget: ₹${budgetAmount.toStringAsFixed(2)}\n'
                 'Current Balance: ₹${_budgetBalance.toStringAsFixed(2)}\n'
                 'Remaining: ₹${(budgetAmount - _budgetBalance).toStringAsFixed(2)}';
      });

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        TTSService.speakBudgetResult('calculation', _result);
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Manager'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareBudgetResult(_result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Budget Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Overview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOverviewCard(
                            'Income',
                            '₹${_totalIncome.toStringAsFixed(2)}',
                            Colors.green,
                            Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOverviewCard(
                            'Expenses',
                            '₹${_totalExpenses.toStringAsFixed(2)}',
                            Colors.red,
                            Icons.trending_down,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildOverviewCard(
                      'Balance',
                      '₹${_budgetBalance.toStringAsFixed(2)}',
                      _budgetBalance >= 0 ? Colors.green : Colors.red,
                      _budgetBalance >= 0 ? Icons.account_balance_wallet : Icons.warning,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Set Budget
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Budget',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _budgetAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Budget Amount (₹)',
                        border: OutlineInputBorder(),
                        prefixText: '₹ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _setBudget,
                      icon: const Icon(Icons.account_balance_wallet),
                      label: const Text('Set Budget'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Add Transaction
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Transaction',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedType,
                            isExpanded: true,
                            items: _types.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _expenseController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        border: OutlineInputBorder(),
                        prefixText: '₹ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addTransaction,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Transaction'),
                    ),
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
                                    await TTSService.speakBudgetResult('calculation', _result);
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

            const SizedBox(height: 16),

            // Budget Tips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Tips',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBudgetTip('Track all your expenses regularly'),
                    _buildBudgetTip('Set realistic budget goals'),
                    _buildBudgetTip('Use the 50/30/20 rule: 50% needs, 30% wants, 20% savings'),
                    _buildBudgetTip('Review and adjust your budget monthly'),
                    _buildBudgetTip('Build an emergency fund'),
                    _buildBudgetTip('Avoid impulse purchases'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, Color color, IconData icon) {
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

  Widget _buildBudgetTip(String tip) {
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