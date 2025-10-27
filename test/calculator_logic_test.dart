import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/calculator_logic.dart';
import 'package:calcmaster/core/scientific_calculator_logic.dart';

void main() {
  group('Calculator Logic Tests', () {
    late CalculatorLogic calculator;

    setUp(() {
      calculator = CalculatorLogic();
    });

    test('Basic arithmetic operations', () {
      // Addition
      calculator.inputNumber('2');
      calculator.inputOperator('+');
      calculator.inputNumber('3');
      calculator.calculate();
      expect(calculator.currentResult, '5');

      // Subtraction
      calculator.clear();
      calculator.inputNumber('10');
      calculator.inputOperator('-');
      calculator.inputNumber('3');
      calculator.calculate();
      expect(calculator.currentResult, '7');

      // Multiplication
      calculator.clear();
      calculator.inputNumber('4');
      calculator.inputOperator('×');
      calculator.inputNumber('5');
      calculator.calculate();
      expect(calculator.currentResult, '20');

      // Division
      calculator.clear();
      calculator.inputNumber('15');
      calculator.inputOperator('÷');
      calculator.inputNumber('3');
      calculator.calculate();
      expect(calculator.currentResult, '5');
    });

    test('BODMAS order of operations', () {
      // Test: 2 + 3 × 4 = 14 (not 20)
      calculator.inputNumber('2');
      calculator.inputOperator('+');
      calculator.inputNumber('3');
      calculator.inputOperator('×');
      calculator.inputNumber('4');
      calculator.calculate();
      expect(calculator.currentResult, '14');

      // Test: (2 + 3) × 4 = 20
      calculator.clear();
      calculator.inputParentheses('(');
      calculator.inputNumber('2');
      calculator.inputOperator('+');
      calculator.inputNumber('3');
      calculator.inputParentheses(')');
      calculator.inputOperator('×');
      calculator.inputNumber('4');
      calculator.calculate();
      expect(calculator.currentResult, '20');
    });

    test('Memory functions', () {
      // Test M+ (Memory Add)
      calculator.inputNumber('10');
      calculator.memoryAdd();
      expect(calculator.memory, 10);

      // Test M- (Memory Subtract)
      calculator.inputNumber('3');
      calculator.memorySubtract();
      expect(calculator.memory, 7);

      // Test MR (Memory Recall)
      calculator.clear();
      calculator.memoryRecall();
      expect(calculator.currentResult, '7');

      // Test MC (Memory Clear)
      calculator.memoryClear();
      expect(calculator.memory, 0);
    });

    test('Error handling', () {
      // Division by zero
      calculator.inputNumber('5');
      calculator.inputOperator('÷');
      calculator.inputNumber('0');
      calculator.calculate();
      expect(calculator.isError, true);
      expect(calculator.currentResult, 'Error');

      // Invalid expression
      calculator.clear();
      calculator.inputNumber('5');
      calculator.inputOperator('+');
      calculator.inputOperator('+');
      calculator.calculate();
      expect(calculator.isError, true);
    });

    test('Decimal operations', () {
      calculator.inputNumber('3');
      calculator.inputDecimal();
      calculator.inputNumber('14');
      calculator.inputOperator('+');
      calculator.inputNumber('2');
      calculator.inputDecimal();
      calculator.inputNumber('86');
      calculator.calculate();
      expect(calculator.currentResult, '6');
    });

    test('Clear functions', () {
      calculator.inputNumber('123');
      calculator.inputOperator('+');
      calculator.inputNumber('456');
      
      // Test CE (Clear Entry)
      calculator.clearEntry();
      expect(calculator.currentExpression, '123+');
      
      // Test C (Clear All)
      calculator.clear();
      expect(calculator.currentExpression, '');
      expect(calculator.currentResult, '0');
    });

    test('Backspace function', () {
      calculator.inputNumber('123');
      calculator.inputOperator('+');
      calculator.inputNumber('456');
      
      calculator.backspace();
      expect(calculator.currentExpression, '123+45');
      
      calculator.backspace();
      expect(calculator.currentExpression, '123+4');
    });
  });

  group('Scientific Calculator Logic Tests', () {
    test('Trigonometric functions', () {
      // Test sin(0) = 0
      expect(ScientificCalculatorLogic.sin(0), 0);
      
      // Test cos(0) = 1
      expect(ScientificCalculatorLogic.cos(0), 1);
      
      // Test tan(0) = 0
      expect(ScientificCalculatorLogic.tan(0), 0);
    });

    test('Logarithmic functions', () {
      // Test ln(e) = 1
      expect(ScientificCalculatorLogic.ln(ScientificCalculatorLogic.e), closeTo(1, 0.001));
      
      // Test log(10) = 1
      expect(ScientificCalculatorLogic.log(10), closeTo(1, 0.001));
      
      // Test log2(2) = 1
      expect(ScientificCalculatorLogic.log2(2), closeTo(1, 0.001));
    });

    test('Power functions', () {
      // Test sqrt(16) = 4
      expect(ScientificCalculatorLogic.sqrt(16), 4);
      
      // Test cbrt(27) = 3
      expect(ScientificCalculatorLogic.cbrt(27), closeTo(3, 0.001));
      
      // Test pow(2, 3) = 8
      expect(ScientificCalculatorLogic.pow(2, 3), 8);
    });

    test('Factorial function', () {
      // Test 5! = 120
      expect(ScientificCalculatorLogic.factorial(5), 120);
      
      // Test 0! = 1
      expect(ScientificCalculatorLogic.factorial(0), 1);
      
      // Test 1! = 1
      expect(ScientificCalculatorLogic.factorial(1), 1);
    });

    test('Permutation and combination', () {
      // Test P(5,2) = 20
      expect(ScientificCalculatorLogic.permutation(5, 2), 20);
      
      // Test C(5,2) = 10
      expect(ScientificCalculatorLogic.combination(5, 2), 10);
    });

    test('Statistical functions', () {
      final data = [1, 2, 3, 4, 5];
      
      // Test mean
      expect(ScientificCalculatorLogic.mean(data), 3);
      
      // Test median
      expect(ScientificCalculatorLogic.median(data), 3);
      
      // Test variance
      expect(ScientificCalculatorLogic.variance(data), 2);
      
      // Test standard deviation
      expect(ScientificCalculatorLogic.standardDeviation(data), closeTo(1.414, 0.001));
    });

    test('GCD and LCM', () {
      // Test GCD(12, 18) = 6
      expect(ScientificCalculatorLogic.gcd(12, 18), 6);
      
      // Test LCM(12, 18) = 36
      expect(ScientificCalculatorLogic.lcm(12, 18), 36);
    });

    test('Angle conversions', () {
      // Test degrees to radians
      expect(ScientificCalculatorLogic.degreesToRadians(180), closeTo(ScientificCalculatorLogic.pi, 0.001));
      
      // Test radians to degrees
      expect(ScientificCalculatorLogic.radiansToDegrees(ScientificCalculatorLogic.pi), closeTo(180, 0.001));
    });

    test('Percentage calculations', () {
      // Test percentage of value
      expect(ScientificCalculatorLogic.percentage(100, 20), 20);
      
      // Test percentage of part/whole
      expect(ScientificCalculatorLogic.percentageOf(25, 100), 25);
      
      // Test percentage change
      expect(ScientificCalculatorLogic.percentageChange(100, 120), 20);
    });

    test('Complex number operations', () {
      // Test complex addition: (1+2i) + (3+4i) = (4+6i)
      final result = ScientificCalculatorLogic.complexAdd(1, 2, 3, 4);
      expect(result['real'], 4);
      expect(result['imaginary'], 6);
      
      // Test complex multiplication: (1+2i) × (3+4i) = (-5+10i)
      final multResult = ScientificCalculatorLogic.complexMultiply(1, 2, 3, 4);
      expect(multResult['real'], -5);
      expect(multResult['imaginary'], 10);
    });

    test('Matrix operations', () {
      final matrix1 = [[1, 2], [3, 4]];
      final matrix2 = [[5, 6], [7, 8]];
      
      // Test matrix addition
      final addResult = ScientificCalculatorLogic.matrixAdd(matrix1, matrix2);
      expect(addResult[0][0], 6);
      expect(addResult[0][1], 8);
      expect(addResult[1][0], 10);
      expect(addResult[1][1], 12);
      
      // Test matrix multiplication
      final multResult = ScientificCalculatorLogic.matrixMultiply(matrix1, matrix2);
      expect(multResult[0][0], 19);
      expect(multResult[0][1], 22);
      expect(multResult[1][0], 43);
      expect(multResult[1][1], 50);
      
      // Test determinant
      expect(ScientificCalculatorLogic.matrixDeterminant2x2(matrix1), -2);
    });

    test('Expression evaluation', () {
      // Test simple expression
      expect(ScientificCalculatorLogic.evaluate('2+3*4'), 14);
      
      // Test with parentheses
      expect(ScientificCalculatorLogic.evaluate('(2+3)*4'), 20);
      
      // Test with functions
      expect(ScientificCalculatorLogic.evaluate('sin(0)'), 0);
      expect(ScientificCalculatorLogic.evaluate('sqrt(16)'), 4);
      expect(ScientificCalculatorLogic.evaluate('log(10)'), closeTo(1, 0.001));
    });

    test('Error handling', () {
      // Test domain errors
      expect(() => ScientificCalculatorLogic.sqrt(-1), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.log(-1), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.ln(-1), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.factorial(-1), throwsArgumentError);
      
      // Test division by zero
      expect(() => ScientificCalculatorLogic.reciprocal(0), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.modulo(5, 0), throwsArgumentError);
    });
  });
}
