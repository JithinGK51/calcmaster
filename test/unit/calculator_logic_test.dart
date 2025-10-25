import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/calculator_logic.dart';

void main() {
  group('CalculatorLogic', () {
    late CalculatorLogic calculator;

    setUp(() {
      calculator = CalculatorLogic();
    });

    test('should initialize with default values', () {
      expect(calculator.currentExpression, '');
      expect(calculator.currentResult, '0');
      expect(calculator.memory, 0.0);
      expect(calculator.isError, false);
      expect(calculator.history, isEmpty);
    });

    test('should handle basic number input', () {
      calculator.inputNumber('5');
      expect(calculator.currentExpression, '5');
      expect(calculator.currentResult, '5');
    });

    test('should handle operator input', () {
      calculator.inputNumber('5');
      calculator.inputOperator('+');
      calculator.inputNumber('3');
      expect(calculator.currentExpression, '5+3');
      expect(calculator.currentResult, '8');
    });

    test('should handle decimal input', () {
      calculator.inputNumber('5');
      calculator.inputDecimal();
      calculator.inputNumber('5');
      expect(calculator.currentExpression, '5.5');
      expect(calculator.currentResult, '5.5');
    });

    test('should handle parentheses', () {
      calculator.inputParentheses('(');
      calculator.inputNumber('5');
      calculator.inputOperator('+');
      calculator.inputNumber('3');
      calculator.inputParentheses(')');
      expect(calculator.currentExpression, '(5+3)');
      expect(calculator.currentResult, '8');
    });

    test('should handle memory functions', () {
      calculator.inputNumber('10');
      calculator.calculate();
      calculator.memoryAdd();
      expect(calculator.memory, 10.0);

      calculator.inputNumber('5');
      calculator.calculate();
      calculator.memorySubtract();
      expect(calculator.memory, 5.0);

      calculator.memoryRecall();
      expect(calculator.currentResult, '5');
    });

    test('should handle clear functions', () {
      calculator.inputNumber('5');
      calculator.inputOperator('+');
      calculator.inputNumber('3');
      calculator.clear();
      expect(calculator.currentExpression, '');
      expect(calculator.currentResult, '0');
      expect(calculator.isError, false);
    });

    test('should handle backspace', () {
      calculator.inputNumber('123');
      calculator.backspace();
      expect(calculator.currentExpression, '12');
      expect(calculator.currentResult, '12');
    });

    test('should handle constants', () {
      calculator.inputConstant('π');
      expect(calculator.currentExpression, '3.141592653589793');
    });

    test('should handle scientific functions', () {
      calculator.inputNumber('0');
      calculator.inputFunction('sin');
      expect(calculator.currentExpression, 'sin(0)');
      expect(calculator.currentResult, '0');
    });

    test('should evaluate expressions correctly', () {
      expect(CalculatorLogic.evaluate('2+3'), 5.0);
      expect(CalculatorLogic.evaluate('10-4'), 6.0);
      expect(CalculatorLogic.evaluate('3*4'), 12.0);
      expect(CalculatorLogic.evaluate('15/3'), 5.0);
      expect(CalculatorLogic.evaluate('2^3'), 8.0);
    });

    test('should handle complex expressions', () {
      expect(CalculatorLogic.evaluate('(2+3)*4'), 20.0);
      expect(CalculatorLogic.evaluate('2+3*4'), 14.0);
      expect(CalculatorLogic.evaluate('(10-4)/2'), 3.0);
    });

    test('should handle error cases', () {
      expect(() => CalculatorLogic.evaluate('2/0'), throwsException);
      expect(() => CalculatorLogic.evaluate('invalid'), throwsException);
    });
  });
}
