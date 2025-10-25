import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_model.dart';
import '../core/budget_manager.dart';

class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier() : super(BudgetState.initial());

  void addBudget(Budget budget) {
    state = state.copyWith(
      budgets: [...state.budgets, budget],
    );
  }

  void updateBudget(Budget budget) {
    state = state.copyWith(
      budgets: state.budgets.map((b) => b.id == budget.id ? budget : b).toList(),
    );
  }

  void deleteBudget(String budgetId) {
    state = state.copyWith(
      budgets: state.budgets.where((b) => b.id != budgetId).toList(),
    );
  }

  void addTransaction(String budgetId, Transaction transaction) {
    state = state.copyWith(
      transactions: [...state.transactions, transaction],
    );
  }

  void updateTransaction(Transaction transaction) {
    state = state.copyWith(
      transactions: state.transactions.map((t) => t.id == transaction.id ? transaction : t).toList(),
    );
  }

  void deleteTransaction(String transactionId) {
    state = state.copyWith(
      transactions: state.transactions.where((t) => t.id != transactionId).toList(),
    );
  }

  void setActiveBudget(String budgetId) {
    state = state.copyWith(activeBudgetId: budgetId);
  }

  List<Transaction> getTransactionsForBudget(String budgetId) {
    return state.transactions.where((t) => t.budgetId == budgetId).toList();
  }

  List<Transaction> getIncomeTransactions(String budgetId) {
    return state.transactions.where((t) => t.budgetId == budgetId && t.type == TransactionType.income).toList();
  }

  List<Transaction> getExpenseTransactions(String budgetId) {
    return state.transactions.where((t) => t.budgetId == budgetId && t.type == TransactionType.expense).toList();
  }

  Map<String, dynamic> calculateBudgetStats(String budgetId) {
    final budget = state.budgets.firstWhere((b) => b.id == budgetId);
    final transactions = getTransactionsForBudget(budgetId);
    
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    
    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    
    final remaining = BudgetManager.calculateRemainingBudget(budget.totalBudget, totalExpenses);
    final percentageUsed = BudgetManager.calculateBudgetPercentageUsed(budget.totalBudget, totalExpenses);
    
    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'remaining': remaining,
      'percentageUsed': percentageUsed,
      'budget': budget.totalBudget,
    };
  }

  Map<String, double> calculateExpenseCategories(String budgetId) {
    final transactions = getExpenseTransactions(budgetId);
    final categoryTotals = <String, double>{};
    
    for (final transaction in transactions) {
      categoryTotals[transaction.category] = (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }
    
    return categoryTotals;
  }

  List<Map<String, dynamic>> getRecentTransactions(String budgetId, {int limit = 10}) {
    final transactions = getTransactionsForBudget(budgetId);
    
    final transactionMaps = transactions.map((transaction) => {
      'id': transaction.id,
      'type': transaction.type == TransactionType.income ? 'income' : 'expense',
      'amount': transaction.type == TransactionType.income ? transaction.amount : -transaction.amount,
      'description': transaction.description,
      'date': transaction.date,
      'category': transaction.category,
    }).toList();
    
    // Sort by date (newest first) and limit
    transactionMaps.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return transactionMaps.take(limit).toList();
  }

  Map<String, dynamic> calculateMonthlyTrends(String budgetId) {
    final transactions = getTransactionsForBudget(budgetId);
    final monthlyData = <String, Map<String, double>>{};
    
    // Group by month
    for (final transaction in transactions) {
      final monthKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = {'income': 0, 'expenses': 0};
      }
      
      if (transaction.type == TransactionType.income) {
        monthlyData[monthKey]!['income'] = monthlyData[monthKey]!['income']! + transaction.amount;
      } else {
        monthlyData[monthKey]!['expenses'] = monthlyData[monthKey]!['expenses']! + transaction.amount;
      }
    }
    
    return monthlyData;
  }
}

class BudgetState {
  final List<Budget> budgets;
  final List<Transaction> transactions;
  final String? activeBudgetId;
  final bool isLoading;
  final String? error;

  const BudgetState({
    required this.budgets,
    required this.transactions,
    this.activeBudgetId,
    required this.isLoading,
    this.error,
  });

  factory BudgetState.initial() {
    return const BudgetState(
      budgets: [],
      transactions: [],
      activeBudgetId: null,
      isLoading: false,
      error: null,
    );
  }

  BudgetState copyWith({
    List<Budget>? budgets,
    List<Transaction>? transactions,
    String? activeBudgetId,
    bool? isLoading,
    String? error,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      transactions: transactions ?? this.transactions,
      activeBudgetId: activeBudgetId ?? this.activeBudgetId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  Budget? get activeBudget {
    if (activeBudgetId == null) return null;
    try {
      return budgets.firstWhere((b) => b.id == activeBudgetId);
    } catch (e) {
      return null;
    }
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});