import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/algebra_logic.dart';
import 'dart:math' as math;

void main() {
  group('AlgebraLogic', () {
    test('should solve linear equations', () {
      final result = AlgebraLogic.solveLinearEquation(2, 3, 7);
      expect(result['x'], 2.0);
      expect(result['solution'], 'x = 2.0');
      expect(result['steps'], isA<List>());
    });

    test('should handle linear equation with no solution', () {
      final result = AlgebraLogic.solveLinearEquation(0, 3, 7);
      expect(result['solution'], 'No solution');
      expect(result['x'], null);
    });

    test('should handle linear equation with infinite solutions', () {
      final result = AlgebraLogic.solveLinearEquation(0, 3, 3);
      expect(result['solution'], 'Infinite solutions');
      expect(result['x'], 'Any real number');
    });

    test('should solve quadratic equations with two real roots', () {
      final result = AlgebraLogic.solveQuadraticEquation(1, -5, 6);
      expect(result['solution'], 'Two real solutions');
      expect(result['x1'], 3.0);
      expect(result['x2'], 2.0);
      expect(result['discriminant'], 1.0);
    });

    test('should solve quadratic equations with one real root', () {
      final result = AlgebraLogic.solveQuadraticEquation(1, -4, 4);
      expect(result['solution'], 'One real solution');
      expect(result['x'], 2.0);
      expect(result['discriminant'], 0.0);
    });

    test('should solve quadratic equations with complex roots', () {
      final result = AlgebraLogic.solveQuadraticEquation(1, 2, 5);
      expect(result['solution'], 'Complex solutions');
      expect(result['discriminant'], -16.0);
      expect(result['x1'], contains('i'));
      expect(result['x2'], contains('i'));
    });

    test('should solve cubic equations', () {
      final result = AlgebraLogic.solveCubicEquation(1, -6, 11, -6);
      expect(result['solution'], isA<String>());
      expect(result['steps'], isA<List>());
    });

    test('should add matrices correctly', () {
      final matrix1 = [[1, 2], [3, 4]];
      final matrix2 = [[5, 6], [7, 8]];
      final result = AlgebraLogic.addMatrices(matrix1, matrix2);
      expect(result, [[6, 8], [10, 12]]);
    });

    test('should subtract matrices correctly', () {
      final matrix1 = [[5, 6], [7, 8]];
      final matrix2 = [[1, 2], [3, 4]];
      final result = AlgebraLogic.subtractMatrices(matrix1, matrix2);
      expect(result, [[4, 4], [4, 4]]);
    });

    test('should multiply matrices correctly', () {
      final matrix1 = [[1, 2], [3, 4]];
      final matrix2 = [[5, 6], [7, 8]];
      final result = AlgebraLogic.multiplyMatrices(matrix1, matrix2);
      expect(result, [[19, 22], [43, 50]]);
    });

    test('should calculate determinant correctly', () {
      final matrix2x2 = [[1, 2], [3, 4]];
      expect(AlgebraLogic.determinant(matrix2x2), -2.0);

      final matrix3x3 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
      expect(AlgebraLogic.determinant(matrix3x3), 0.0);
    });

    test('should transpose matrix correctly', () {
      final matrix = [[1, 2, 3], [4, 5, 6]];
      final result = AlgebraLogic.transposeMatrix(matrix);
      expect(result, [[1, 4], [2, 5], [3, 6]]);
    });

    test('should calculate matrix trace correctly', () {
      final matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
      expect(AlgebraLogic.trace(matrix), 15.0);
    });

    test('should create identity matrix correctly', () {
      final identity = AlgebraLogic.identityMatrix(3);
      expect(identity, [[1, 0, 0], [0, 1, 0], [0, 0, 1]]);
    });

    test('should check if matrix is symmetric', () {
      final symmetric = [[1, 2], [2, 3]];
      final notSymmetric = [[1, 2], [3, 4]];
      expect(AlgebraLogic.isSymmetric(symmetric), true);
      expect(AlgebraLogic.isSymmetric(notSymmetric), false);
    });

    test('should add polynomials correctly', () {
      final poly1 = [1, 2, 3]; // x² + 2x + 3
      final poly2 = [2, 1];    // 2x + 1
      final result = AlgebraLogic.addPolynomials(poly1, poly2);
      expect(result, [1, 4, 4]); // x² + 4x + 4
    });

    test('should subtract polynomials correctly', () {
      final poly1 = [1, 2, 3]; // x² + 2x + 3
      final poly2 = [2, 1];    // 2x + 1
      final result = AlgebraLogic.subtractPolynomials(poly1, poly2);
      expect(result, [1, 0, 2]); // x² + 2
    });

    test('should multiply polynomials correctly', () {
      final poly1 = [1, 1]; // x + 1
      final poly2 = [1, 1]; // x + 1
      final result = AlgebraLogic.multiplyPolynomials(poly1, poly2);
      expect(result, [1, 2, 1]); // x² + 2x + 1
    });

    test('should divide polynomials correctly', () {
      final dividend = [1, 2, 1]; // x² + 2x + 1
      final divisor = [1, 1];     // x + 1
      final result = AlgebraLogic.dividePolynomials(dividend, divisor);
      expect(result['quotient'], [1, 1]); // x + 1
      expect(result['remainder'], [0.0]);
    });

    test('should evaluate polynomials correctly', () {
      final poly = [1, 2, 1]; // x² + 2x + 1
      expect(AlgebraLogic.evaluatePolynomial(poly, 1), 4.0);
      expect(AlgebraLogic.evaluatePolynomial(poly, 2), 9.0);
    });

    test('should calculate polynomial derivative correctly', () {
      final poly = [1, 2, 1]; // x² + 2x + 1
      final derivative = AlgebraLogic.derivative(poly);
      expect(derivative, [2, 2]); // 2x + 2
    });

    test('should calculate polynomial integral correctly', () {
      final poly = [2, 2]; // 2x + 2
      final integral = AlgebraLogic.integral(poly);
      expect(integral, [0, 1, 2]); // x² + 2x + C
    });

    test('should find polynomial roots', () {
      final poly = [1, -5, 6]; // x² - 5x + 6
      final roots = AlgebraLogic.findRoots(poly);
      expect(roots.length, 2);
      expect(roots, contains(closeTo(2.0, 0.1)));
      expect(roots, contains(closeTo(3.0, 0.1)));
    });

    test('should solve system of equations', () {
      final coefficients = [[2, 1], [1, 1]];
      final constants = [5, 3];
      final result = AlgebraLogic.solveSystemOfEquations(coefficients, constants);
      expect(result['solution'], [2.0, 1.0]);
    });

    test('should simplify expressions', () {
      expect(AlgebraLogic.simplifyExpression('x + 0'), 'x');
      expect(AlgebraLogic.simplifyExpression('x - -y'), 'x+y');
      expect(AlgebraLogic.simplifyExpression('x + -y'), 'x-y');
    });

    test('should factorize quadratic expressions', () {
      final result = AlgebraLogic.factorizeQuadratic(1, -5, 6);
      expect(result['factorization'], contains('x'));
      expect(result['factors'], isA<Map>());
    });

    test('should handle matrix dimension errors', () {
      final matrix1 = [[1, 2], [3, 4]];
      final matrix2 = [[1, 2, 3], [4, 5, 6]];
      expect(() => AlgebraLogic.addMatrices(matrix1, matrix2), throwsArgumentError);
    });

    test('should handle matrix multiplication dimension errors', () {
      final matrix1 = [[1, 2], [3, 4]];
      final matrix2 = [[1, 2, 3]];
      expect(() => AlgebraLogic.multiplyMatrices(matrix1, matrix2), throwsArgumentError);
    });

    test('should handle determinant of non-square matrix', () {
      final matrix = [[1, 2, 3], [4, 5, 6]];
      expect(() => AlgebraLogic.determinant(matrix), throwsArgumentError);
    });

    test('should handle trace of non-square matrix', () {
      final matrix = [[1, 2, 3], [4, 5, 6]];
      expect(() => AlgebraLogic.trace(matrix), throwsArgumentError);
    });

    test('should handle division by zero polynomial', () {
      final dividend = [1, 2, 1];
      final divisor = [0, 0];
      expect(() => AlgebraLogic.dividePolynomials(dividend, divisor), throwsArgumentError);
    });
  });
}
