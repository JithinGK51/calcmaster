import 'dart:math' as math;

class AlgebraLogic {
  // Linear equation solver: ax + b = c
  static Map<String, dynamic> solveLinearEquation(double a, double b, double c) {
    if (a == 0) {
      if (b == c) {
        return {'solution': 'Infinite solutions', 'x': 'Any real number'};
      } else {
        return {'solution': 'No solution', 'x': null};
      }
    }
    
    final x = (c - b) / a;
    return {
      'solution': 'x = $x',
      'x': x,
      'steps': [
        'Given: ${a}x + $b = $c',
        'Subtract $b from both sides: ${a}x = ${c - b}',
        'Divide by $a: x = ${x}'
      ]
    };
  }
  
  // Quadratic equation solver: ax² + bx + c = 0
  static Map<String, dynamic> solveQuadraticEquation(double a, double b, double c) {
    if (a == 0) {
      return solveLinearEquation(b, c, 0);
    }
    
    final discriminant = b * b - 4 * a * c;
    
    if (discriminant < 0) {
      final realPart = -b / (2 * a);
      final imaginaryPart = math.sqrt(-discriminant) / (2 * a);
      return {
        'solution': 'Complex solutions',
        'x1': '$realPart + ${imaginaryPart}i',
        'x2': '$realPart - ${imaginaryPart}i',
        'discriminant': discriminant,
        'steps': [
          'Given: ${a}x² + ${b}x + $c = 0',
          'Discriminant = b² - 4ac = ${b}² - 4($a)($c) = $discriminant',
          'Since discriminant < 0, solutions are complex',
          'x = (-b ± √(b² - 4ac)) / 2a',
          'x₁ = $realPart + ${imaginaryPart}i',
          'x₂ = $realPart - ${imaginaryPart}i'
        ]
      };
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      return {
        'solution': 'One real solution',
        'x': x,
        'discriminant': discriminant,
        'steps': [
          'Given: ${a}x² + ${b}x + $c = 0',
          'Discriminant = b² - 4ac = ${b}² - 4($a)($c) = $discriminant',
          'Since discriminant = 0, one real solution',
          'x = -b / (2a) = -$b / (2 × $a) = $x'
        ]
      };
    } else {
      final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      return {
        'solution': 'Two real solutions',
        'x1': x1,
        'x2': x2,
        'discriminant': discriminant,
        'steps': [
          'Given: ${a}x² + ${b}x + $c = 0',
          'Discriminant = b² - 4ac = ${b}² - 4($a)($c) = $discriminant',
          'Since discriminant > 0, two real solutions',
          'x = (-b ± √(b² - 4ac)) / 2a',
          'x₁ = (-$b + √$discriminant) / (2 × $a) = $x1',
          'x₂ = (-$b - √$discriminant) / (2 × $a) = $x2'
        ]
      };
    }
  }
  
  // Matrix operations
  static List<List<double>> addMatrices(List<List<double>> matrix1, List<List<double>> matrix2) {
    if (matrix1.length != matrix2.length || matrix1[0].length != matrix2[0].length) {
      throw ArgumentError('Matrices must have the same dimensions');
    }
    
    final result = <List<double>>[];
    for (int i = 0; i < matrix1.length; i++) {
      final row = <double>[];
      for (int j = 0; j < matrix1[i].length; j++) {
        row.add(matrix1[i][j] + matrix2[i][j]);
      }
      result.add(row);
    }
    return result;
  }

  static List<List<double>> subtractMatrices(List<List<double>> matrix1, List<List<double>> matrix2) {
    if (matrix1.length != matrix2.length || matrix1[0].length != matrix2[0].length) {
      throw ArgumentError('Matrices must have the same dimensions');
    }
    
    final result = <List<double>>[];
    for (int i = 0; i < matrix1.length; i++) {
      final row = <double>[];
      for (int j = 0; j < matrix1[i].length; j++) {
        row.add(matrix1[i][j] - matrix2[i][j]);
      }
      result.add(row);
    }
    return result;
  }

  static List<List<double>> scalarMultiplyMatrix(List<List<double>> matrix, double scalar) {
    final result = <List<double>>[];
    for (int i = 0; i < matrix.length; i++) {
      final row = <double>[];
      for (int j = 0; j < matrix[i].length; j++) {
        row.add(matrix[i][j] * scalar);
      }
      result.add(row);
    }
    return result;
  }

  static List<List<double>> transposeMatrix(List<List<double>> matrix) {
    final result = <List<double>>[];
    for (int j = 0; j < matrix[0].length; j++) {
      final row = <double>[];
      for (int i = 0; i < matrix.length; i++) {
        row.add(matrix[i][j]);
      }
      result.add(row);
    }
    return result;
  }

  static List<List<double>> inverseMatrix(List<List<double>> matrix) {
    final det = determinant(matrix);
    if (det == 0) {
      throw ArgumentError('Matrix is singular (determinant = 0)');
    }
    
    final n = matrix.length;
    final adjugate = <List<double>>[];
    
    for (int i = 0; i < n; i++) {
      final row = <double>[];
      for (int j = 0; j < n; j++) {
        final cofactor = math.pow(-1, i + j) * determinant(_getMinor(matrix, i, j));
        row.add(cofactor);
      }
      adjugate.add(row);
    }
    
    final adjugateTransposed = transposeMatrix(adjugate);
    return scalarMultiplyMatrix(adjugateTransposed, 1 / det);
  }

  static List<List<double>> _getMinor(List<List<double>> matrix, int row, int col) {
    final minor = <List<double>>[];
    for (int i = 0; i < matrix.length; i++) {
      if (i != row) {
        final minorRow = <double>[];
        for (int j = 0; j < matrix[i].length; j++) {
          if (j != col) {
            minorRow.add(matrix[i][j]);
          }
        }
        minor.add(minorRow);
      }
    }
    return minor;
  }

  static double trace(List<List<double>> matrix) {
    if (matrix.length != matrix[0].length) {
      throw ArgumentError('Matrix must be square');
    }
    
    double trace = 0;
    for (int i = 0; i < matrix.length; i++) {
      trace += matrix[i][i];
    }
    return trace;
  }

  static List<List<double>> identityMatrix(int size) {
    final identity = <List<double>>[];
    for (int i = 0; i < size; i++) {
      final row = <double>[];
      for (int j = 0; j < size; j++) {
        row.add(i == j ? 1.0 : 0.0);
      }
      identity.add(row);
    }
    return identity;
  }

  static bool isSymmetric(List<List<double>> matrix) {
    if (matrix.length != matrix[0].length) return false;
    
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] != matrix[j][i]) return false;
      }
    }
    return true;
  }

  static bool isOrthogonal(List<List<double>> matrix) {
    if (matrix.length != matrix[0].length) return false;
    
    final transpose = transposeMatrix(matrix);
    final product = multiplyMatrices(matrix, transpose);
    final identity = identityMatrix(matrix.length);
    
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if ((product[i][j] - identity[i][j]).abs() > 1e-10) return false;
      }
    }
    return true;
  }
  
  static List<List<double>> multiplyMatrices(List<List<double>> matrix1, List<List<double>> matrix2) {
    if (matrix1[0].length != matrix2.length) {
      throw ArgumentError('Number of columns in first matrix must equal number of rows in second matrix');
    }
    
    final result = <List<double>>[];
    for (int i = 0; i < matrix1.length; i++) {
      final row = <double>[];
      for (int j = 0; j < matrix2[0].length; j++) {
        double sum = 0;
        for (int k = 0; k < matrix2.length; k++) {
          sum += matrix1[i][k] * matrix2[k][j];
        }
        row.add(sum);
      }
      result.add(row);
    }
    return result;
  }
  
  static double determinant(List<List<double>> matrix) {
    if (matrix.length != matrix[0].length) {
      throw ArgumentError('Matrix must be square');
    }
    
    final n = matrix.length;
    if (n == 1) return matrix[0][0];
    if (n == 2) {
      return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    }
    
    double det = 0;
    for (int i = 0; i < n; i++) {
      final subMatrix = <List<double>>[];
      for (int j = 1; j < n; j++) {
        final row = <double>[];
        for (int k = 0; k < n; k++) {
          if (k != i) row.add(matrix[j][k]);
        }
        subMatrix.add(row);
      }
      det += math.pow(-1, i) * matrix[0][i] * determinant(subMatrix);
    }
    return det;
  }
  
  // Polynomial operations
  static List<double> addPolynomials(List<double> poly1, List<double> poly2) {
    final maxLength = math.max(poly1.length, poly2.length);
    final result = List<double>.filled(maxLength, 0);
    
    for (int i = 0; i < poly1.length; i++) {
      result[i] += poly1[i];
    }
    for (int i = 0; i < poly2.length; i++) {
      result[i] += poly2[i];
    }
    
    return result;
  }

  static List<double> subtractPolynomials(List<double> poly1, List<double> poly2) {
    final maxLength = math.max(poly1.length, poly2.length);
    final result = List<double>.filled(maxLength, 0);
    
    for (int i = 0; i < poly1.length; i++) {
      result[i] += poly1[i];
    }
    for (int i = 0; i < poly2.length; i++) {
      result[i] -= poly2[i];
    }
    
    return result;
  }
  
  static List<double> multiplyPolynomials(List<double> poly1, List<double> poly2) {
    final result = List<double>.filled(poly1.length + poly2.length - 1, 0);
    
    for (int i = 0; i < poly1.length; i++) {
      for (int j = 0; j < poly2.length; j++) {
        result[i + j] += poly1[i] * poly2[j];
      }
    }
    
    return result;
  }

  static Map<String, dynamic> dividePolynomials(List<double> dividend, List<double> divisor) {
    if (divisor.isEmpty || divisor.every((coeff) => coeff == 0)) {
      throw ArgumentError('Division by zero polynomial');
    }
    
    final quotient = <double>[];
    final remainder = List<double>.from(dividend);
    
    while (remainder.length >= divisor.length && !remainder.every((coeff) => coeff == 0)) {
      final leadingCoeff = remainder.last / divisor.last;
      quotient.insert(0, leadingCoeff);
      
      for (int i = 0; i < divisor.length; i++) {
        final index = remainder.length - divisor.length + i;
        if (index >= 0) {
          remainder[index] -= leadingCoeff * divisor[i];
        }
      }
      
      // Remove leading zeros
      while (remainder.isNotEmpty && remainder.last == 0) {
        remainder.removeLast();
      }
    }
    
    return {
      'quotient': quotient.isEmpty ? [0.0] : quotient,
      'remainder': remainder.isEmpty ? [0.0] : remainder
    };
  }

  static double evaluatePolynomial(List<double> coefficients, double x) {
    double result = 0;
    for (int i = 0; i < coefficients.length; i++) {
      result += coefficients[i] * math.pow(x, coefficients.length - 1 - i);
    }
    return result;
  }

  static List<double> derivative(List<double> coefficients) {
    if (coefficients.length <= 1) return [0.0];
    
    final derivative = <double>[];
    for (int i = 0; i < coefficients.length - 1; i++) {
      derivative.add(coefficients[i] * (coefficients.length - 1 - i));
    }
    return derivative;
  }

  static List<double> integral(List<double> coefficients, {double constant = 0}) {
    final integral = <double>[constant];
    for (int i = 0; i < coefficients.length; i++) {
      final power = coefficients.length - i;
      integral.add(coefficients[i] / power);
    }
    return integral;
  }

  // Polynomial root finding using Newton-Raphson method
  static List<double> findRoots(List<double> coefficients, {double tolerance = 1e-10, int maxIterations = 100}) {
    final roots = <double>[];
    final derivative = AlgebraLogic.derivative(coefficients);
    
    // Try different starting points
    for (double start = -10; start <= 10; start += 0.5) {
      try {
        final root = _newtonRaphson(coefficients, derivative, start, tolerance, maxIterations);
        if (root != null && !roots.any((r) => (r - root).abs() < tolerance)) {
          roots.add(root);
        }
      } catch (e) {
        // Continue with next starting point
      }
    }
    
    return roots;
  }

  static double? _newtonRaphson(List<double> coefficients, List<double> derivative, double x0, double tolerance, int maxIterations) {
    double x = x0;
    
    for (int i = 0; i < maxIterations; i++) {
      final fx = evaluatePolynomial(coefficients, x);
      if (fx.abs() < tolerance) return x;
      
      final fpx = evaluatePolynomial(derivative, x);
      if (fpx.abs() < tolerance) break; // Avoid division by zero
      
      x = x - fx / fpx;
    }
    
    return null;
  }

  // Cubic equation solver: ax³ + bx² + cx + d = 0
  static Map<String, dynamic> solveCubicEquation(double a, double b, double c, double d) {
    if (a == 0) {
      return solveQuadraticEquation(b, c, d);
    }
    
    // Normalize: x³ + px² + qx + r = 0
    final p = b / a;
    final q = c / a;
    final r = d / a;
    
    // Cardano's method
    final Q = (3 * q - p * p) / 9;
    final R = (9 * p * q - 27 * r - 2 * p * p * p) / 54;
    final discriminant = Q * Q * Q + R * R;
    
    if (discriminant > 0) {
      // One real root, two complex
      final S = math.pow(R + math.sqrt(discriminant), 1/3);
      final T = math.pow(R - math.sqrt(discriminant), 1/3);
      final x1 = S + T - p / 3;
      
      return {
        'solution': 'One real root, two complex roots',
        'x1': x1,
        'x2': 'Complex',
        'x3': 'Complex',
        'discriminant': discriminant,
        'steps': [
          'Given: ${a}x³ + ${b}x² + ${c}x + $d = 0',
          'Normalized: x³ + ${p}x² + ${q}x + $r = 0',
          'Q = (3q - p²)/9 = ${Q}',
          'R = (9pq - 27r - 2p³)/54 = ${R}',
          'Discriminant = Q³ + R² = ${discriminant} > 0',
          'One real root: x₁ = ${x1}'
        ]
      };
    } else if (discriminant == 0) {
      // Three real roots, at least two equal
      final S = math.pow(R, 1/3);
      final x1 = 2 * S - p / 3;
      final x2 = -S - p / 3;
      
      return {
        'solution': 'Three real roots (two equal)',
        'x1': x1,
        'x2': x2,
        'x3': x2,
        'discriminant': discriminant,
        'steps': [
          'Given: ${a}x³ + ${b}x² + ${c}x + $d = 0',
          'Discriminant = 0',
          'x₁ = ${x1}',
          'x₂ = x₃ = ${x2}'
        ]
      };
    } else {
      // Three distinct real roots
      final rho = math.sqrt(-Q);
      final theta = math.acos(R / (rho * rho * rho));
      
      final x1 = 2 * rho * math.cos(theta / 3) - p / 3;
      final x2 = 2 * rho * math.cos((theta + 2 * math.pi) / 3) - p / 3;
      final x3 = 2 * rho * math.cos((theta + 4 * math.pi) / 3) - p / 3;
      
      return {
        'solution': 'Three distinct real roots',
        'x1': x1,
        'x2': x2,
        'x3': x3,
        'discriminant': discriminant,
        'steps': [
          'Given: ${a}x³ + ${b}x² + ${c}x + $d = 0',
          'Discriminant < 0',
          'Using trigonometric method',
          'x₁ = ${x1}',
          'x₂ = ${x2}',
          'x₃ = ${x3}'
        ]
      };
    }
  }

  // System of linear equations solver using Gaussian elimination
  static Map<String, dynamic> solveSystemOfEquations(List<List<double>> coefficients, List<double> constants) {
    if (coefficients.length != constants.length) {
      throw ArgumentError('Number of equations must equal number of constants');
    }
    
    final n = coefficients.length;
    final augmented = <List<double>>[];
    
    // Create augmented matrix
    for (int i = 0; i < n; i++) {
      final row = <double>[];
      for (int j = 0; j < n; j++) {
        row.add(coefficients[i][j]);
      }
      row.add(constants[i]);
      augmented.add(row);
    }
    
    // Gaussian elimination
    for (int i = 0; i < n; i++) {
      // Find pivot
      int maxRow = i;
      for (int k = i + 1; k < n; k++) {
        if (augmented[k][i].abs() > augmented[maxRow][i].abs()) {
          maxRow = k;
        }
      }
      
      // Swap rows
      if (maxRow != i) {
        final temp = augmented[i];
        augmented[i] = augmented[maxRow];
        augmented[maxRow] = temp;
      }
      
      // Make all rows below this one 0 in current column
      for (int k = i + 1; k < n; k++) {
        final factor = augmented[k][i] / augmented[i][i];
        for (int j = i; j <= n; j++) {
          augmented[k][j] -= factor * augmented[i][j];
        }
      }
    }
    
    // Back substitution
    final solution = List<double>.filled(n, 0);
    for (int i = n - 1; i >= 0; i--) {
      solution[i] = augmented[i][n];
      for (int j = i + 1; j < n; j++) {
        solution[i] -= augmented[i][j] * solution[j];
      }
      solution[i] /= augmented[i][i];
    }
    
    return {
      'solution': solution,
      'steps': ['Gaussian elimination completed', 'Solution: ${solution.map((x) => x.toStringAsFixed(3)).join(', ')}']
    };
  }
  
  // Expression simplification (basic)
  static String simplifyExpression(String expression) {
    // Remove spaces
    expression = expression.replaceAll(' ', '');
    
    // Basic simplification rules
    expression = expression.replaceAll('--', '+');
    expression = expression.replaceAll('+-', '-');
    
    // Handle basic cases like x + 0 = x, x * 1 = x, etc.
    expression = expression.replaceAll(RegExp(r'\+0(?!\d)'), '');
    expression = expression.replaceAll(RegExp(r'\+0$'), '');
    expression = expression.replaceAll(RegExp(r'^0\+'), '');
    
    return expression;
  }
  
  // Factorize quadratic expressions (basic)
  static Map<String, dynamic> factorizeQuadratic(double a, double b, double c) {
    if (a == 0) {
      return {'error': 'Not a quadratic expression'};
    }
    
    // Try to factor as (px + q)(rx + s)
    // We need pr = a, ps + qr = b, qs = c
    
    final factors = <Map<String, dynamic>>[];
    
    // Find factors of a
    final aFactors = <int>[];
    for (int i = 1; i <= a.abs(); i++) {
      if (a % i == 0) {
        aFactors.add(i);
        aFactors.add(-i);
      }
    }
    
    // Find factors of c
    final cFactors = <int>[];
    for (int i = 1; i <= c.abs(); i++) {
      if (c % i == 0) {
        cFactors.add(i);
        cFactors.add(-i);
      }
    }
    
    // Try different combinations
    for (final p in aFactors) {
      for (final r in aFactors) {
        if (p * r == a) {
          for (final q in cFactors) {
            for (final s in cFactors) {
              if (q * s == c && p * s + q * r == b) {
                factors.add({
                  'p': p,
                  'q': q,
                  'r': r,
                  's': s,
                  'factorization': '(${p}x + $q)(${r}x + $s)'
                });
              }
            }
          }
        }
      }
    }
    
    if (factors.isEmpty) {
      return {'error': 'Cannot factorize with integer coefficients'};
    }
    
    return {
      'factorization': factors.first['factorization'],
      'factors': factors.first
    };
  }
}
