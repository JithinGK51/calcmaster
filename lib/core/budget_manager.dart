import 'dart:math' as math;

class BudgetManager {
  // Calculate remaining budget
  static double calculateRemainingBudget(double totalBudget, double totalExpenses) {
    return totalBudget - totalExpenses;
  }
  
  // Calculate budget percentage used
  static double calculateBudgetPercentageUsed(double totalBudget, double totalExpenses) {
    if (totalBudget <= 0) return 0;
    return (totalExpenses / totalBudget) * 100;
  }
  
  // Calculate daily budget allowance
  static double calculateDailyBudget(double monthlyBudget, int daysInMonth) {
    if (daysInMonth <= 0) return 0;
    return monthlyBudget / daysInMonth;
  }
  
  // Calculate weekly budget allowance
  static double calculateWeeklyBudget(double monthlyBudget) {
    return monthlyBudget / 4.33; // Average weeks per month
  }
  
  // Calculate savings rate
  static double calculateSavingsRate(double income, double expenses) {
    if (income <= 0) return 0;
    return ((income - expenses) / income) * 100;
  }
  
  // Calculate debt-to-income ratio
  static double calculateDebtToIncomeRatio(double monthlyDebt, double monthlyIncome) {
    if (monthlyIncome <= 0) return 0;
    return (monthlyDebt / monthlyIncome) * 100;
  }
  
  // Calculate compound interest for savings
  static double calculateCompoundInterest({
    required double principal,
    required double annualRate,
    required int years,
    required int compoundingFrequency,
  }) {
    if (principal <= 0 || annualRate < 0 || years <= 0 || compoundingFrequency <= 0) {
      throw ArgumentError('All parameters must be positive');
    }
    
    final rate = annualRate / 100;
    return principal * math.pow((1 + rate / compoundingFrequency), (compoundingFrequency * years)) - principal;
  }
  
  // Calculate future value of savings
  static double calculateFutureValue({
    required double principal,
    required double annualRate,
    required int years,
    required int compoundingFrequency,
  }) {
    if (principal <= 0 || annualRate < 0 || years <= 0 || compoundingFrequency <= 0) {
      throw ArgumentError('All parameters must be positive');
    }
    
    final rate = annualRate / 100;
    return principal * math.pow((1 + rate / compoundingFrequency), (compoundingFrequency * years));
  }
  
  // Calculate required monthly savings for goal
  static double calculateRequiredMonthlySavings({
    required double goalAmount,
    required double currentSavings,
    required double annualRate,
    required int years,
  }) {
    if (goalAmount <= currentSavings) return 0;
    if (annualRate < 0 || years <= 0) {
      throw ArgumentError('Rate and years must be positive');
    }
    
    final rate = annualRate / 100;
    final monthlyRate = rate / 12;
    final months = years * 12;
    
    if (monthlyRate == 0) {
      return (goalAmount - currentSavings) / months;
    }
    
    final futureValueOfCurrentSavings = currentSavings * math.pow((1 + monthlyRate), months);
    final requiredFutureValue = goalAmount - futureValueOfCurrentSavings;
    
    return requiredFutureValue * monthlyRate / (math.pow((1 + monthlyRate), months) - 1);
  }
  
  // Calculate emergency fund recommendation
  static Map<String, dynamic> calculateEmergencyFund({
    required double monthlyExpenses,
    required int monthsCoverage,
  }) {
    final recommendedAmount = monthlyExpenses * monthsCoverage;
    
    String recommendation;
    if (monthsCoverage < 3) {
      recommendation = 'Consider building a larger emergency fund (3-6 months recommended)';
    } else if (monthsCoverage <= 6) {
      recommendation = 'Good emergency fund coverage';
    } else {
      recommendation = 'Strong emergency fund - consider investing excess funds';
    }
    
    return {
      'recommendedAmount': recommendedAmount,
      'monthsCoverage': monthsCoverage,
      'recommendation': recommendation
    };
  }
  
  // Calculate 50/30/20 budget allocation
  static Map<String, double> calculate503020Budget(double monthlyIncome) {
    return {
      'needs': monthlyIncome * 0.50,
      'wants': monthlyIncome * 0.30,
      'savings': monthlyIncome * 0.20,
    };
  }
  
  // Calculate expense category percentages
  static Map<String, double> calculateExpensePercentages(Map<String, double> expenses) {
    final total = expenses.values.fold(0.0, (sum, amount) => sum + amount);
    if (total <= 0) return {};
    
    final percentages = <String, double>{};
    expenses.forEach((category, amount) {
      percentages[category] = (amount / total) * 100;
    });
    
    return percentages;
  }
  
  // Calculate budget variance
  static Map<String, dynamic> calculateBudgetVariance({
    required Map<String, double> budgeted,
    required Map<String, double> actual,
  }) {
    final variance = <String, double>{};
    final variancePercentage = <String, double>{};
    
    budgeted.forEach((category, budgetedAmount) {
      final actualAmount = actual[category] ?? 0;
      final varAmount = actualAmount - budgetedAmount;
      variance[category] = varAmount;
      variancePercentage[category] = budgetedAmount > 0 ? (varAmount / budgetedAmount) * 100 : 0;
    });
    
    return {
      'variance': variance,
      'variancePercentage': variancePercentage,
    };
  }
  
  // Calculate retirement savings goal
  static Map<String, dynamic> calculateRetirementGoal({
    required double currentAge,
    required double retirementAge,
    required double currentSavings,
    required double annualIncome,
    required double replacementRatio,
    required double annualReturn,
  }) {
    final yearsToRetirement = retirementAge - currentAge;
    final targetAmount = annualIncome * replacementRatio * 25; // 25x rule
    
    final requiredMonthlySavings = calculateRequiredMonthlySavings(
      goalAmount: targetAmount,
      currentSavings: currentSavings,
      annualRate: annualReturn,
      years: yearsToRetirement.toInt(),
    );
    
    return {
      'targetAmount': targetAmount,
      'yearsToRetirement': yearsToRetirement,
      'requiredMonthlySavings': requiredMonthlySavings,
      'currentSavings': currentSavings,
    };
  }
}
