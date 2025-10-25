import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 4)
enum BudgetType {
  @HiveField(0)
  monthly,
  @HiveField(1)
  weekly,
  @HiveField(2)
  yearly,
  @HiveField(3)
  custom,
}

@HiveType(typeId: 5)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 6)
class Budget extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  BudgetType type;

  @HiveField(3)
  double totalBudget;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  String? description;

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  Budget({
    required this.id,
    required this.name,
    required this.type,
    required this.totalBudget,
    required this.startDate,
    required this.endDate,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingBudget {
    return totalBudget - totalExpenses;
  }

  double get totalExpenses {
    // This will be calculated from transactions
    return 0.0;
  }

  double get totalIncome {
    // This will be calculated from transactions
    return 0.0;
  }

  Budget copyWith({
    String? id,
    String? name,
    BudgetType? type,
    double? totalBudget,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      totalBudget: totalBudget ?? this.totalBudget,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: 7)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String budgetId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  double amount;

  @HiveField(5)
  TransactionType type;

  @HiveField(6)
  String category;

  @HiveField(7)
  DateTime date;

  @HiveField(8)
  bool isRecurring;

  @HiveField(9)
  String? recurringPattern;

  @HiveField(10)
  DateTime? nextRecurringDate;

  @HiveField(11)
  DateTime createdAt;

  Transaction({
    required this.id,
    required this.budgetId,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.isRecurring = false,
    this.recurringPattern,
    this.nextRecurringDate,
    required this.createdAt,
  });

  Transaction copyWith({
    String? id,
    String? budgetId,
    String? title,
    String? description,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    bool? isRecurring,
    String? recurringPattern,
    DateTime? nextRecurringDate,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      nextRecurringDate: nextRecurringDate ?? this.nextRecurringDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
