import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/scientific_calculator_logic.dart';
import 'dart:math' as math;

void main() {
  group('ScientificCalculatorLogic', () {
    test('should evaluate expressions correctly', () {
      expect(ScientificCalculatorLogic.evaluate('2+3'), 5.0);
      expect(ScientificCalculatorLogic.evaluate('sin(0)'), 0.0);
      expect(ScientificCalculatorLogic.evaluate('cos(0)'), 1.0);
    });

    test('should handle trigonometric functions', () {
      expect(ScientificCalculatorLogic.sin(0), 0.0);
      expect(ScientificCalculatorLogic.cos(0), 1.0);
      expect(ScientificCalculatorLogic.tan(0), 0.0);
      expect(ScientificCalculatorLogic.sin(math.pi/2), closeTo(1.0, 0.001));
      expect(ScientificCalculatorLogic.cos(math.pi/2), closeTo(0.0, 0.001));
    });

    test('should handle inverse trigonometric functions', () {
      expect(ScientificCalculatorLogic.asin(0), 0.0);
      expect(ScientificCalculatorLogic.acos(1), 0.0);
      expect(ScientificCalculatorLogic.atan(0), 0.0);
      expect(ScientificCalculatorLogic.asin(1), closeTo(math.pi/2, 0.001));
    });

    test('should handle domain errors for inverse trig functions', () {
      expect(() => ScientificCalculatorLogic.asin(2), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.acos(2), throwsArgumentError);
    });

    test('should handle hyperbolic functions', () {
      expect(ScientificCalculatorLogic.sinh(0), 0.0);
      expect(ScientificCalculatorLogic.cosh(0), 1.0);
      expect(ScientificCalculatorLogic.tanh(0), 0.0);
    });

    test('should handle logarithmic functions', () {
      expect(ScientificCalculatorLogic.log(10), closeTo(1.0, 0.001));
      expect(ScientificCalculatorLogic.ln(math.e), closeTo(1.0, 0.001));
      expect(ScientificCalculatorLogic.log2(8), closeTo(3.0, 0.001));
    });

    test('should handle domain errors for logarithmic functions', () {
      expect(() => ScientificCalculatorLogic.log(0), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.ln(-1), throwsArgumentError);
      expect(() => ScientificCalculatorLogic.log2(0), throwsArgumentError);
    });

    test('should handle exponential functions', () {
      expect(ScientificCalculatorLogic.exp(0), 1.0);
      expect(ScientificCalculatorLogic.exp(1), closeTo(math.e, 0.001));
    });

    test('should handle power and root functions', () {
      expect(ScientificCalculatorLogic.power(2, 3), 8.0);
      expect(ScientificCalculatorLogic.sqrt(16), 4.0);
      expect(ScientificCalculatorLogic.cbrt(27), 3.0);
      expect(ScientificCalculatorLogic.nthRoot(16, 4), 2.0);
    });

    test('should handle factorial', () {
      expect(ScientificCalculatorLogic.factorial(0), 1);
      expect(ScientificCalculatorLogic.factorial(1), 1);
      expect(ScientificCalculatorLogic.factorial(5), 120);
      expect(ScientificCalculatorLogic.factorial(10), 3628800);
    });

    test('should handle domain errors for factorial', () {
      expect(() => ScientificCalculatorLogic.factorial(-1), throwsArgumentError);
    });

    test('should handle permutations and combinations', () {
      expect(ScientificCalculatorLogic.permutation(5, 3), 60);
      expect(ScientificCalculatorLogic.combination(5, 3), 10);
      expect(ScientificCalculatorLogic.permutation(10, 2), 90);
      expect(ScientificCalculatorLogic.combination(10, 2), 45);
    });

    test('should handle statistical functions', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];
      expect(ScientificCalculatorLogic.mean(data), 3.0);
      expect(ScientificCalculatorLogic.median(data), 3.0);
      expect(ScientificCalculatorLogic.mode(data), 1.0);
      expect(ScientificCalculatorLogic.variance(data), 2.0);
      expect(ScientificCalculatorLogic.standardDeviation(data), closeTo(1.414, 0.001));
    });

    test('should handle constants', () {
      expect(ScientificCalculatorLogic.pi, math.pi);
      expect(ScientificCalculatorLogic.e, math.e);
    });

    test('should handle degree/radian conversion', () {
      expect(ScientificCalculatorLogic.degreesToRadians(180), math.pi);
      expect(ScientificCalculatorLogic.radiansToDegrees(math.pi), 180.0);
      expect(ScientificCalculatorLogic.degreesToRadians(90), math.pi/2);
      expect(ScientificCalculatorLogic.radiansToDegrees(math.pi/2), 90.0);
    });

    test('should handle floor and ceiling functions', () {
      expect(ScientificCalculatorLogic.floor(3.7), 3.0);
      expect(ScientificCalculatorLogic.ceil(3.2), 4.0);
      expect(ScientificCalculatorLogic.floor(-3.2), -4.0);
      expect(ScientificCalculatorLogic.ceil(-3.7), -3.0);
    });

    test('should handle absolute value', () {
      expect(ScientificCalculatorLogic.abs(-5), 5.0);
      expect(ScientificCalculatorLogic.abs(5), 5.0);
      expect(ScientificCalculatorLogic.abs(0), 0.0);
    });

    test('should handle sign function', () {
      expect(ScientificCalculatorLogic.sign(5), 1.0);
      expect(ScientificCalculatorLogic.sign(-5), -1.0);
      expect(ScientificCalculatorLogic.sign(0), 0.0);
    });

    test('should handle modulo operation', () {
      expect(ScientificCalculatorLogic.modulo(10, 3), 1.0);
      expect(ScientificCalculatorLogic.modulo(15, 4), 3.0);
      expect(ScientificCalculatorLogic.modulo(8, 2), 0.0);
    });

    test('should handle greatest common divisor', () {
      expect(ScientificCalculatorLogic.gcd(12, 8), 4);
      expect(ScientificCalculatorLogic.gcd(15, 25), 5);
      expect(ScientificCalculatorLogic.gcd(17, 13), 1);
    });

    test('should handle least common multiple', () {
      expect(ScientificCalculatorLogic.lcm(12, 8), 24);
      expect(ScientificCalculatorLogic.lcm(15, 25), 75);
      expect(ScientificCalculatorLogic.lcm(4, 6), 12);
    });
  });
}
