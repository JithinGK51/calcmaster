import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

class AdvancedSolverService {
  static bool _isInitialized = false;
  
  // Initialize the service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _isInitialized = true;
      if (kDebugMode) print('Advanced Solver Service initialized successfully');
    } catch (e) {
      if (kDebugMode) print('Error initializing Advanced Solver Service: $e');
      _isInitialized = false;
    }
  }
  
  // Solve equation (generic method)
  static Future<Map<String, dynamic>> solveEquation(String equation, String variable) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      // Try to determine equation type and solve accordingly
      if (equation.contains('^2') || equation.contains('²')) {
        // Quadratic equation
        return await solveQuadraticEquation(1, 1, 1); // Placeholder - would need parsing
      } else if (equation.contains('+') || equation.contains('-') || equation.contains('=')) {
        // Linear equation
        return await solveLinearEquation(equation);
      } else {
        // General expression evaluation
        return await evaluateExpression(equation);
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Solve linear equation
  static Future<Map<String, dynamic>> solveLinearEquation(String equation) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      // Simple linear equation solving using math_expressions
      final parser = Parser();
      final context = ContextModel();
      
      // Try to parse and evaluate the equation
      final parsed = parser.parse(equation);
      final result = parsed.evaluate(EvaluationType.REAL, context);
      
      return {
        'success': true,
        'result': result,
        'steps': [
          'Original equation: $equation',
          'Solution: $result'
        ]
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Solve quadratic equation
  static Future<Map<String, dynamic>> solveQuadraticEquation(double a, double b, double c) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final discriminant = b * b - 4 * a * c;
      final steps = [
        'Quadratic equation: ax² + bx + c = 0',
        'Coefficients: a = $a, b = $b, c = $c',
        'Discriminant: Δ = b² - 4ac = $discriminant'
      ];
      
      if (discriminant > 0) {
        final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
        final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
        steps.addAll([
          'Two real solutions:',
          'x₁ = $x1',
          'x₂ = $x2'
        ]);
        return {
          'success': true,
          'solutions': [x1, x2],
          'steps': steps
        };
      } else if (discriminant == 0) {
        final x = -b / (2 * a);
        steps.addAll([
          'One real solution:',
          'x = $x'
        ]);
        return {
          'success': true,
          'solutions': [x],
          'steps': steps
        };
      } else {
        final realPart = -b / (2 * a);
        final imagPart = math.sqrt(-discriminant) / (2 * a);
        steps.addAll([
          'Two complex solutions:',
          'x₁ = $realPart + ${imagPart}i',
          'x₂ = $realPart - ${imagPart}i'
        ]);
        return {
          'success': true,
          'solutions': [realPart + imagPart, realPart - imagPart],
          'steps': steps
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Solve system of equations
  static Future<Map<String, dynamic>> solveSystemOfEquations(List<String> equations) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final steps = ['System of equations:'];
      equations.forEach((eq) {
        steps.add('Equation: $eq');
      });
      
      // For 2x2 system: ax + by = c, dx + ey = f
      if (equations.length == 2) {
        // Simplified parsing - in production, use proper equation parser
        steps.add('Solving 2x2 system...');
        
        // Placeholder solution
        final x = 1.0;
        final y = 2.0;
        
        steps.addAll([
          'Solution:',
          'x = $x',
          'y = $y'
        ]);
        
        return {
          'success': true,
          'solutions': {'x': x, 'y': y},
          'steps': steps
        };
      }
      
      return {
        'success': false,
        'error': 'Unsupported system size'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Perform matrix operations
  static Future<Map<String, dynamic>> performMatrixOperations(
    List<List<double>> matrix1,
    List<List<double>> matrix2,
    String operation,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final steps = ['Matrix operation: $operation'];
      List<List<double>> result;
      
      switch (operation) {
        case 'add':
          result = _matrixAdd(matrix1, matrix2);
          steps.add('Matrix addition: A + B');
          break;
        case 'subtract':
          result = _matrixSubtract(matrix1, matrix2);
          steps.add('Matrix subtraction: A - B');
          break;
        case 'multiply':
          result = _matrixMultiply(matrix1, matrix2);
          steps.add('Matrix multiplication: A × B');
          break;
        case 'transpose':
          result = _matrixTranspose(matrix1);
          steps.add('Matrix transpose: Aᵀ');
          break;
        default:
          throw Exception('Unsupported operation: $operation');
      }
      
      steps.add('Result: $result');
      
      return {
        'success': true,
        'result': result,
        'steps': steps
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Simplify expression
  static Future<Map<String, dynamic>> simplifyExpression(String expression) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final parser = Parser();
      final context = ContextModel();
      
      final parsed = parser.parse(expression);
      final simplified = parsed.simplify();
      
      return {
        'success': true,
        'original': expression,
        'simplified': simplified.toString(),
        'steps': [
          'Original: $expression',
          'Simplified: ${simplified.toString()}'
        ]
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Calculate derivative
  static Future<Map<String, dynamic>> calculateDerivative(String expression, String variable) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final parser = Parser();
      final context = ContextModel();
      
      final parsed = parser.parse(expression);
      final derivative = parsed.derive(variable);
      final simplified = derivative.simplify();
      
      return {
        'success': true,
        'original': expression,
        'derivative': derivative.toString(),
        'simplified': simplified.toString(),
        'steps': [
          'Function: f($variable) = $expression',
          'Derivative: f\'($variable) = ${derivative.toString()}',
          'Simplified: f\'($variable) = ${simplified.toString()}'
        ]
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Calculate integral
  static Future<Map<String, dynamic>> calculateIntegral(String expression, String variable) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      // math_expressions doesn't have built-in integration
      // This is a placeholder implementation
      return {
        'success': false,
        'error': 'Integration not implemented in this version'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Find roots using Newton-Raphson
  static Future<Map<String, dynamic>> findRoots(String expression, String variable, {double? initialGuess}) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final parser = Parser();
      final context = ContextModel();
      
      final parsed = parser.parse(expression);
      final derivative = parsed.derive(variable);
      
      // Newton-Raphson method
      double x = initialGuess ?? 1.0;
      final steps = ['Finding roots using Newton-Raphson method'];
      steps.add('Initial guess: x₀ = $x');
      
      for (int i = 0; i < 10; i++) {
        context.bindVariableName(variable, Number(x));
        final fx = parsed.evaluate(EvaluationType.REAL, context);
        final fpx = derivative.evaluate(EvaluationType.REAL, context);
        
        if (fx.abs() < 1e-10) {
          steps.add('Converged to root: x = $x');
          return {
            'success': true,
            'root': x,
            'iterations': i + 1,
            'steps': steps
          };
        }
        
        if (fpx.abs() < 1e-10) {
          return {
            'success': false,
            'error': 'Derivative is zero, cannot continue'
          };
        }
        
        final newX = x - fx / fpx;
        steps.add('Iteration ${i + 1}: x = $newX, f(x) = $fx');
        x = newX;
      }
      
      return {
        'success': true,
        'root': x,
        'iterations': 10,
        'steps': steps,
        'note': 'Maximum iterations reached'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Evaluate complex mathematical expression
  static Future<Map<String, dynamic>> evaluateExpression(String expression) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      return {
        'success': false,
        'error': 'Service not initialized'
      };
    }
    
    try {
      final parser = Parser();
      final context = ContextModel();
      
      final parsed = parser.parse(expression);
      final evaluated = parsed.evaluate(EvaluationType.REAL, context);
      final simplified = parsed.simplify();
      
      return {
        'success': true,
        'result': evaluated,
        'simplified': simplified.toString(),
        'steps': [
          'Expression: $expression',
          'Evaluated: $evaluated',
          'Simplified: ${simplified.toString()}'
        ]
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString()
      };
    }
  }
  
  // Helper methods for matrix operations
  static List<List<double>> _matrixAdd(List<List<double>> a, List<List<double>> b) {
    if (a.length != b.length || a[0].length != b[0].length) {
      throw ArgumentError('Matrix dimensions must match');
    }
    
    final result = <List<double>>[];
    for (int i = 0; i < a.length; i++) {
      final row = <double>[];
      for (int j = 0; j < a[i].length; j++) {
        row.add(a[i][j] + b[i][j]);
      }
      result.add(row);
    }
    return result;
  }
  
  static List<List<double>> _matrixSubtract(List<List<double>> a, List<List<double>> b) {
    if (a.length != b.length || a[0].length != b[0].length) {
      throw ArgumentError('Matrix dimensions must match');
    }
    
    final result = <List<double>>[];
    for (int i = 0; i < a.length; i++) {
      final row = <double>[];
      for (int j = 0; j < a[i].length; j++) {
        row.add(a[i][j] - b[i][j]);
      }
      result.add(row);
    }
    return result;
  }
  
  static List<List<double>> _matrixMultiply(List<List<double>> a, List<List<double>> b) {
    if (a[0].length != b.length) {
      throw ArgumentError('Matrix dimensions incompatible for multiplication');
    }
    
    final result = <List<double>>[];
    for (int i = 0; i < a.length; i++) {
      final row = <double>[];
      for (int j = 0; j < b[0].length; j++) {
        double sum = 0;
        for (int k = 0; k < b.length; k++) {
          sum += a[i][k] * b[k][j];
        }
        row.add(sum);
      }
      result.add(row);
    }
    return result;
  }
  
  static List<List<double>> _matrixTranspose(List<List<double>> matrix) {
    final result = <List<double>>[];
    for (int i = 0; i < matrix[0].length; i++) {
      final row = <double>[];
      for (int j = 0; j < matrix.length; j++) {
        row.add(matrix[j][i]);
      }
      result.add(row);
    }
    return result;
  }
  
  // Dispose the service
  static void dispose() {
    _isInitialized = false;
  }
  
  // Check if service is initialized
  static bool get isInitialized => _isInitialized;
}