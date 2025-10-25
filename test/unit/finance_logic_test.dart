import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/finance_logic.dart';
import 'dart:math' as math;

void main() {
  group('FinanceLogic', () {
    test('should calculate EMI correctly', () {
      final result = FinanceLogic.calculateEMI(100000, 10, 12);
      expect(result['emi'], closeTo(8791.59, 0.1));
      expect(result['totalAmount'], closeTo(105499.08, 0.1));
      expect(result['totalInterest'], closeTo(5499.08, 0.1));
    });

    test('should calculate simple interest correctly', () {
      final result = FinanceLogic.calculateSimpleInterest(10000, 5, 2);
      expect(result['interest'], 1000.0);
      expect(result['totalAmount'], 11000.0);
    });

    test('should calculate compound interest correctly', () {
      final result = FinanceLogic.calculateCompoundInterest(10000, 5, 2, 1);
      expect(result['interest'], closeTo(1025.0, 1.0));
      expect(result['totalAmount'], closeTo(11025.0, 1.0));
    });

    test('should calculate compound interest with different compounding frequencies', () {
      final result1 = FinanceLogic.calculateCompoundInterest(10000, 5, 2, 1); // Annual
      final result2 = FinanceLogic.calculateCompoundInterest(10000, 5, 2, 12); // Monthly
      final result3 = FinanceLogic.calculateCompoundInterest(10000, 5, 2, 365); // Daily
      
      expect(result1['totalAmount'], lessThan(result2['totalAmount']));
      expect(result2['totalAmount'], lessThan(result3['totalAmount']));
    });

    test('should calculate SIP returns correctly', () {
      final result = FinanceLogic.calculateSIPReturns(1000, 12, 10, 1);
      expect(result['totalInvestment'], 12000.0);
      expect(result['maturityValue'], closeTo(12550.0, 50.0));
      expect(result['totalReturns'], closeTo(550.0, 50.0));
    });

    test('should calculate lump sum investment returns correctly', () {
      final result = FinanceLogic.calculateLumpSumReturns(100000, 10, 5, 1);
      expect(result['totalInvestment'], 100000.0);
      expect(result['maturityValue'], closeTo(161051.0, 100.0));
      expect(result['totalReturns'], closeTo(61051.0, 100.0));
    });

    test('should calculate loan comparison correctly', () {
      final loan1 = {'principal': 100000, 'rate': 8, 'tenure': 12};
      final loan2 = {'principal': 100000, 'rate': 10, 'tenure': 12};
      
      final result = FinanceLogic.compareLoans(loan1, loan2);
      expect(result['loan1']['emi'], lessThan(result['loan2']['emi']));
      expect(result['loan1']['totalInterest'], lessThan(result['loan2']['totalInterest']));
    });

    test('should calculate present value correctly', () {
      final result = FinanceLogic.calculatePresentValue(1100, 10, 1);
      expect(result, closeTo(1000.0, 1.0));
    });

    test('should calculate future value correctly', () {
      final result = FinanceLogic.calculateFutureValue(1000, 10, 1);
      expect(result, closeTo(1100.0, 1.0));
    });

    test('should calculate net present value correctly', () {
      final cashFlows = [-1000, 300, 300, 300, 300];
      final result = FinanceLogic.calculateNPV(cashFlows, 10);
      expect(result, closeTo(-49.04, 1.0));
    });

    test('should calculate internal rate of return correctly', () {
      final cashFlows = [-1000, 300, 300, 300, 300];
      final result = FinanceLogic.calculateIRR(cashFlows);
      expect(result, closeTo(7.71, 0.1));
    });

    test('should calculate payback period correctly', () {
      final cashFlows = [-1000, 300, 300, 300, 300];
      final result = FinanceLogic.calculatePaybackPeriod(cashFlows);
      expect(result, closeTo(3.33, 0.1));
    });

    test('should calculate profit margin correctly', () {
      final result = FinanceLogic.calculateProfitMargin(1000, 800);
      expect(result, 20.0);
    });

    test('should calculate return on investment correctly', () {
      final result = FinanceLogic.calculateROI(1000, 1200);
      expect(result, 20.0);
    });

    test('should calculate break-even point correctly', () {
      final result = FinanceLogic.calculateBreakEvenPoint(1000, 500, 200);
      expect(result, 2.0);
    });

    test('should calculate depreciation using straight line method', () {
      final result = FinanceLogic.calculateStraightLineDepreciation(10000, 1000, 5);
      expect(result['annualDepreciation'], 1800.0);
      expect(result['bookValue'], [10000, 8200, 6400, 4600, 2800, 1000]);
    });

    test('should calculate depreciation using declining balance method', () {
      final result = FinanceLogic.calculateDecliningBalanceDepreciation(10000, 20, 5);
      expect(result['annualDepreciation'], isA<List>());
      expect(result['bookValue'], isA<List>());
    });

    test('should calculate loan amortization schedule', () {
      final result = FinanceLogic.calculateLoanAmortization(100000, 10, 12);
      expect(result['schedule'], isA<List>());
      expect(result['schedule'].length, 12);
      expect(result['totalInterest'], closeTo(5499.08, 1.0));
    });

    test('should calculate mortgage payment correctly', () {
      final result = FinanceLogic.calculateMortgagePayment(200000, 6, 30);
      expect(result['monthlyPayment'], closeTo(1199.10, 1.0));
      expect(result['totalPayment'], closeTo(431676.0, 100.0));
      expect(result['totalInterest'], closeTo(231676.0, 100.0));
    });

    test('should calculate credit card interest correctly', () {
      final result = FinanceLogic.calculateCreditCardInterest(1000, 18, 30);
      expect(result['dailyRate'], closeTo(0.0493, 0.001));
      expect(result['monthlyInterest'], closeTo(14.79, 0.1));
    });

    test('should calculate tax calculations correctly', () {
      final result = FinanceLogic.calculateTax(50000, 20);
      expect(result['taxAmount'], 10000.0);
      expect(result['afterTaxAmount'], 40000.0);
    });

    test('should calculate inflation adjusted returns correctly', () {
      final result = FinanceLogic.calculateInflationAdjustedReturns(1000, 10, 3, 1);
      expect(result['nominalReturn'], closeTo(100.0, 1.0));
      expect(result['realReturn'], closeTo(70.0, 1.0));
    });

    test('should handle zero values', () {
      expect(FinanceLogic.calculateSimpleInterest(0, 5, 2)['interest'], 0.0);
      expect(FinanceLogic.calculateCompoundInterest(0, 5, 2, 1)['interest'], 0.0);
      expect(FinanceLogic.calculateEMI(0, 10, 12)['emi'], 0.0);
    });

    test('should handle edge cases', () {
      expect(FinanceLogic.calculateSimpleInterest(1000, 0, 2)['interest'], 0.0);
      expect(FinanceLogic.calculateSimpleInterest(1000, 5, 0)['interest'], 0.0);
      expect(FinanceLogic.calculateEMI(100000, 0, 12)['emi'], closeTo(8333.33, 0.1));
    });

    test('should handle large numbers', () {
      final result = FinanceLogic.calculateEMI(10000000, 12, 240);
      expect(result['emi'], closeTo(110108.0, 10.0));
      expect(result['totalAmount'], closeTo(26425920.0, 1000.0));
    });

    test('should handle small numbers', () {
      final result = FinanceLogic.calculateEMI(1000, 12, 12);
      expect(result['emi'], closeTo(88.85, 0.1));
      expect(result['totalAmount'], closeTo(1066.2, 1.0));
    });
  });
}
