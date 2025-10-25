import 'dart:math' as math;

class FinanceLogic {
  // EMI (Equated Monthly Installment) Calculator
  static double calculateEMI(double principal, double annualRate, int tenureMonths) {
    if (principal <= 0) throw ArgumentError('Principal must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (tenureMonths <= 0) throw ArgumentError('Tenure must be positive');
    
    final monthlyRate = annualRate / (12 * 100);
    
    if (monthlyRate == 0) {
      return principal / tenureMonths;
    }
    
    final emi = principal * monthlyRate * math.pow(1 + monthlyRate, tenureMonths) /
        (math.pow(1 + monthlyRate, tenureMonths) - 1);
    
    return emi;
  }
  
  // EMI with different payment frequencies
  static double calculateEMIWithFrequency(double principal, double annualRate, int tenure, String frequency) {
    int periodsPerYear;
    switch (frequency.toLowerCase()) {
      case 'monthly':
        periodsPerYear = 12;
        break;
      case 'quarterly':
        periodsPerYear = 4;
        break;
      case 'semi-annually':
        periodsPerYear = 2;
        break;
      case 'annually':
        periodsPerYear = 1;
        break;
      default:
        throw ArgumentError('Invalid payment frequency');
    }
    
    final totalPeriods = tenure * periodsPerYear;
    final periodRate = annualRate / (periodsPerYear * 100);
    
    if (periodRate == 0) {
      return principal / totalPeriods;
    }
    
    final emi = principal * periodRate * math.pow(1 + periodRate, totalPeriods) /
        (math.pow(1 + periodRate, totalPeriods) - 1);
    
    return emi;
  }
  
  // Total amount payable
  static double calculateTotalAmount(double emi, int tenureMonths) {
    return emi * tenureMonths;
  }
  
  // Total interest payable
  static double calculateTotalInterest(double principal, double emi, int tenureMonths) {
    return (emi * tenureMonths) - principal;
  }
  
  // Simple Interest
  static double calculateSimpleInterest(double principal, double rate, double time) {
    if (principal <= 0) throw ArgumentError('Principal must be positive');
    if (rate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (time < 0) throw ArgumentError('Time cannot be negative');
    
    return (principal * rate * time) / 100;
  }
  
  // Compound Interest
  static double calculateCompoundInterest(double principal, double rate, double time, int compoundingFrequency) {
    if (principal <= 0) throw ArgumentError('Principal must be positive');
    if (rate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (time < 0) throw ArgumentError('Time cannot be negative');
    if (compoundingFrequency <= 0) throw ArgumentError('Compounding frequency must be positive');
    
    final amount = principal * math.pow(1 + (rate / (100 * compoundingFrequency)), compoundingFrequency * time);
    return amount - principal;
  }
  
  // Compound Amount (Principal + Interest)
  static double calculateCompoundAmount(double principal, double rate, double time, int compoundingFrequency) {
    if (principal <= 0) throw ArgumentError('Principal must be positive');
    if (rate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (time < 0) throw ArgumentError('Time cannot be negative');
    if (compoundingFrequency <= 0) throw ArgumentError('Compounding frequency must be positive');
    
    return principal * math.pow(1 + (rate / (100 * compoundingFrequency)), compoundingFrequency * time);
  }
  
  // SIP (Systematic Investment Plan) Calculator
  static double calculateSIPMaturity(double monthlyInvestment, double annualRate, int years) {
    if (monthlyInvestment <= 0) throw ArgumentError('Monthly investment must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years <= 0) throw ArgumentError('Years must be positive');
    
    final monthlyRate = annualRate / (12 * 100);
    final totalMonths = years * 12;
    
    if (monthlyRate == 0) {
      return monthlyInvestment * totalMonths;
    }
    
    final maturityValue = monthlyInvestment * 
        ((math.pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) * 
        (1 + monthlyRate);
    
    return maturityValue;
  }
  
  // SIP Total Investment
  static double calculateSIPTotalInvestment(double monthlyInvestment, int years) {
    return monthlyInvestment * years * 12;
  }
  
  // SIP Total Returns
  static double calculateSIPReturns(double monthlyInvestment, double annualRate, int years) {
    final maturityValue = calculateSIPMaturity(monthlyInvestment, annualRate, years);
    final totalInvestment = calculateSIPTotalInvestment(monthlyInvestment, years);
    return maturityValue - totalInvestment;
  }
  
  // Lump Sum Investment Calculator
  static double calculateLumpSumMaturity(double principal, double annualRate, int years) {
    if (principal <= 0) throw ArgumentError('Principal must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years <= 0) throw ArgumentError('Years must be positive');
    
    return principal * math.pow(1 + (annualRate / 100), years);
  }
  
  // Loan Eligibility Calculator
  static double calculateLoanEligibility(double monthlyIncome, double monthlyExpenses, double annualRate, int tenureYears) {
    if (monthlyIncome <= 0) throw ArgumentError('Monthly income must be positive');
    if (monthlyExpenses < 0) throw ArgumentError('Monthly expenses cannot be negative');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (tenureYears <= 0) throw ArgumentError('Tenure must be positive');
    
    final availableEMI = monthlyIncome - monthlyExpenses;
    final tenureMonths = tenureYears * 12;
    final monthlyRate = annualRate / (12 * 100);
    
    if (monthlyRate == 0) {
      return availableEMI * tenureMonths;
    }
    
    final maxLoanAmount = availableEMI * 
        (math.pow(1 + monthlyRate, tenureMonths) - 1) / 
        (monthlyRate * math.pow(1 + monthlyRate, tenureMonths));
    
    return maxLoanAmount;
  }
  
  // Fixed Deposit Calculator
  static double calculateFDMaturity(double principal, double annualRate, int years, int compoundingFrequency) {
    if (principal <= 0) throw ArgumentError('Principal must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years <= 0) throw ArgumentError('Years must be positive');
    if (compoundingFrequency <= 0) throw ArgumentError('Compounding frequency must be positive');
    
    return calculateCompoundAmount(principal, annualRate, years.toDouble(), compoundingFrequency);
  }
  
  // Recurring Deposit Calculator
  static double calculateRDMaturity(double monthlyDeposit, double annualRate, int years) {
    if (monthlyDeposit <= 0) throw ArgumentError('Monthly deposit must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years <= 0) throw ArgumentError('Years must be positive');
    
    final monthlyRate = annualRate / (12 * 100);
    final totalMonths = years * 12;
    
    if (monthlyRate == 0) {
      return monthlyDeposit * totalMonths;
    }
    
    final maturityValue = monthlyDeposit * 
        ((math.pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate);
    
    return maturityValue;
  }
  
  // PPF (Public Provident Fund) Calculator
  static double calculatePPFMaturity(double annualDeposit, double annualRate, int years) {
    if (annualDeposit <= 0) throw ArgumentError('Annual deposit must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years <= 0) throw ArgumentError('Years must be positive');
    
    final maturityValue = annualDeposit * 
        ((math.pow(1 + annualRate / 100, years) - 1) / (annualRate / 100));
    
    return maturityValue;
  }
  
  // Inflation Calculator
  static double calculateInflationAdjustedValue(double presentValue, double inflationRate, int years) {
    if (presentValue <= 0) throw ArgumentError('Present value must be positive');
    if (inflationRate < 0) throw ArgumentError('Inflation rate cannot be negative');
    if (years < 0) throw ArgumentError('Years cannot be negative');
    
    return presentValue / math.pow(1 + (inflationRate / 100), years);
  }
  
  // Future Value Calculator
  static double calculateFutureValue(double presentValue, double annualRate, int years) {
    if (presentValue <= 0) throw ArgumentError('Present value must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years < 0) throw ArgumentError('Years cannot be negative');
    
    return presentValue * math.pow(1 + (annualRate / 100), years);
  }
  
  // Present Value Calculator
  static double calculatePresentValue(double futureValue, double annualRate, int years) {
    if (futureValue <= 0) throw ArgumentError('Future value must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years < 0) throw ArgumentError('Years cannot be negative');
    
    return futureValue / math.pow(1 + (annualRate / 100), years);
  }
  
  // Annuity Calculator
  static double calculateAnnuityPayment(double presentValue, double annualRate, int years) {
    if (presentValue <= 0) throw ArgumentError('Present value must be positive');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years <= 0) throw ArgumentError('Years must be positive');
    
    final monthlyRate = annualRate / (12 * 100);
    final totalMonths = years * 12;
    
    if (monthlyRate == 0) {
      return presentValue / totalMonths;
    }
    
    final annuityPayment = presentValue * 
        (monthlyRate * math.pow(1 + monthlyRate, totalMonths)) / 
        (math.pow(1 + monthlyRate, totalMonths) - 1);
    
    return annuityPayment;
  }
  
  // Tax Calculator (Income Tax)
  static Map<String, double> calculateIncomeTax(double annualIncome, String taxRegime) {
    if (annualIncome < 0) throw ArgumentError('Annual income cannot be negative');
    
    double tax = 0;
    double effectiveRate = 0;
    
    if (taxRegime.toLowerCase() == 'new') {
      // New tax regime (2023-24)
      if (annualIncome <= 300000) {
        tax = 0;
      } else if (annualIncome <= 600000) {
        tax = (annualIncome - 300000) * 0.05;
      } else if (annualIncome <= 900000) {
        tax = 15000 + (annualIncome - 600000) * 0.10;
      } else if (annualIncome <= 1200000) {
        tax = 45000 + (annualIncome - 900000) * 0.15;
      } else if (annualIncome <= 1500000) {
        tax = 90000 + (annualIncome - 1200000) * 0.20;
      } else {
        tax = 150000 + (annualIncome - 1500000) * 0.30;
      }
    } else {
      // Old tax regime (with deductions)
      final taxableIncome = annualIncome - 50000; // Standard deduction
      
      if (taxableIncome <= 250000) {
        tax = 0;
      } else if (taxableIncome <= 500000) {
        tax = (taxableIncome - 250000) * 0.05;
      } else if (taxableIncome <= 1000000) {
        tax = 12500 + (taxableIncome - 500000) * 0.20;
      } else {
        tax = 112500 + (taxableIncome - 1000000) * 0.30;
      }
    }
    
    effectiveRate = annualIncome > 0 ? (tax / annualIncome) * 100 : 0;
    
    return {
      'tax': tax,
      'effectiveRate': effectiveRate,
      'afterTaxIncome': annualIncome - tax,
    };
  }
  
  // GST Calculator
  static Map<String, double> calculateGST(double amount, double gstRate) {
    if (amount < 0) throw ArgumentError('Amount cannot be negative');
    if (gstRate < 0) throw ArgumentError('GST rate cannot be negative');
    
    final cgst = (amount * gstRate) / (2 * 100);
    final sgst = (amount * gstRate) / (2 * 100);
    final igst = (amount * gstRate) / 100;
    final totalGST = cgst + sgst;
    final totalAmount = amount + totalGST;
    
    return {
      'baseAmount': amount,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'totalGST': totalGST,
      'totalAmount': totalAmount,
    };
  }
  
  // Break-even Analysis
  static Map<String, double> calculateBreakEven(double fixedCosts, double variableCostPerUnit, double sellingPricePerUnit) {
    if (fixedCosts < 0) throw ArgumentError('Fixed costs cannot be negative');
    if (variableCostPerUnit < 0) throw ArgumentError('Variable cost per unit cannot be negative');
    if (sellingPricePerUnit <= 0) throw ArgumentError('Selling price per unit must be positive');
    if (sellingPricePerUnit <= variableCostPerUnit) {
      throw ArgumentError('Selling price must be greater than variable cost per unit');
    }
    
    final contributionMargin = sellingPricePerUnit - variableCostPerUnit;
    final breakEvenUnits = fixedCosts / contributionMargin;
    final breakEvenRevenue = breakEvenUnits * sellingPricePerUnit;
    
    return {
      'breakEvenUnits': breakEvenUnits,
      'breakEvenRevenue': breakEvenRevenue,
      'contributionMargin': contributionMargin,
      'contributionMarginRatio': (contributionMargin / sellingPricePerUnit) * 100,
    };
  }
  
  // ROI (Return on Investment) Calculator
  static double calculateROI(double initialInvestment, double finalValue) {
    if (initialInvestment <= 0) throw ArgumentError('Initial investment must be positive');
    
    return ((finalValue - initialInvestment) / initialInvestment) * 100;
  }
  
  // CAGR (Compound Annual Growth Rate) Calculator
  static double calculateCAGR(double initialValue, double finalValue, int years) {
    if (initialValue <= 0) throw ArgumentError('Initial value must be positive');
    if (finalValue <= 0) throw ArgumentError('Final value must be positive');
    if (years <= 0) throw ArgumentError('Years must be positive');
    
    return (math.pow(finalValue / initialValue, 1 / years) - 1) * 100;
  }
  
  // Net Present Value (NPV) Calculator
  static double calculateNPV(List<double> cashFlows, double discountRate) {
    if (cashFlows.isEmpty) throw ArgumentError('Cash flows cannot be empty');
    if (discountRate < 0) throw ArgumentError('Discount rate cannot be negative');
    
    double npv = 0;
    for (int i = 0; i < cashFlows.length; i++) {
      npv += cashFlows[i] / math.pow(1 + discountRate / 100, i);
    }
    
    return npv;
  }
  
  // Internal Rate of Return (IRR) Calculator (Simplified)
  static double calculateIRR(List<double> cashFlows, {double initialGuess = 10.0, double tolerance = 0.0001}) {
    if (cashFlows.isEmpty) throw ArgumentError('Cash flows cannot be empty');
    
    double rate = initialGuess;
    double npv = calculateNPV(cashFlows, rate);
    
    int iterations = 0;
    while (npv.abs() > tolerance && iterations < 1000) {
      final npvDerivative = _calculateNPVDerivative(cashFlows, rate);
      if (npvDerivative == 0) break;
      
      rate = rate - npv / npvDerivative;
      npv = calculateNPV(cashFlows, rate);
      iterations++;
    }
    
    return rate;
  }
  
  static double _calculateNPVDerivative(List<double> cashFlows, double rate) {
    double derivative = 0;
    for (int i = 1; i < cashFlows.length; i++) {
      derivative -= (i * cashFlows[i]) / math.pow(1 + rate / 100, i + 1);
    }
    return derivative;
  }
}
