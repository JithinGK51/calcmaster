import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  
  // Static method for simple evaluation
  static double evaluate(String expression) {
    try {
      final parser = Parser();
      final context = ContextModel();
      final parsed = parser.parse(expression);
      return parsed.evaluate(EvaluationType.REAL, context);
    } catch (e) {
      throw Exception('Invalid expression: $e');
    }
  }
  
  double _memory = 0.0;
  String _currentExpression = '';
  String _currentResult = '0';
  bool _isNewCalculation = true;
  bool _isError = false;
  List<String> _history = [];
  
  // Getters
  String get currentExpression => _currentExpression;
  String get currentResult => _currentResult;
  double get memory => _memory;
  bool get isError => _isError;
  List<String> get history => List.unmodifiable(_history);

  // Basic operations
  void inputNumber(String number) {
    if (_isError) {
      clear();
    }
    
    if (_isNewCalculation) {
      _currentExpression = number;
      _isNewCalculation = false;
    } else {
      _currentExpression += number;
    }
    _evaluateExpression();
  }

  void inputOperator(String operator) {
    if (_isError) {
      clear();
      return;
    }
    
    if (_currentExpression.isEmpty) {
      _currentExpression = _currentResult;
    }
    
    // Replace last operator if it exists
    if (_isLastCharOperator()) {
      _currentExpression = _currentExpression.substring(0, _currentExpression.length - 1);
    }
    
    _currentExpression += operator;
    _isNewCalculation = false;
  }

  void inputDecimal() {
    if (_isError) {
      clear();
      return;
    }
    
    if (_isNewCalculation) {
      _currentExpression = '0.';
      _isNewCalculation = false;
    } else if (!_hasDecimalInCurrentNumber()) {
      _currentExpression += '.';
    }
    _evaluateExpression();
  }

  void inputParentheses(String paren) {
    if (_isError) {
      clear();
      return;
    }
    
    _currentExpression += paren;
    _isNewCalculation = false;
    _evaluateExpression();
  }

  void calculate() {
    if (_isError || _currentExpression.isEmpty) return;
    
    try {
      final result = _evaluateExpression();
      if (result != null) {
        _currentResult = _formatNumber(result);
        _addToHistory(_currentExpression, _currentResult);
        _currentExpression = '';
        _isNewCalculation = true;
        _isError = false;
      }
    } catch (e) {
      _handleError();
    }
  }

  void clear() {
    _currentExpression = '';
    _currentResult = '0';
    _isNewCalculation = true;
    _isError = false;
  }

  void clearEntry() {
    if (_isNewCalculation) {
      clear();
    } else {
      _currentExpression = '';
      _currentResult = '0';
    }
  }

  void backspace() {
    if (_isError) {
      clear();
      return;
    }
    
    if (_currentExpression.isNotEmpty) {
      _currentExpression = _currentExpression.substring(0, _currentExpression.length - 1);
      _evaluateExpression();
    }
  }

  // Memory functions
  void memoryAdd() {
    if (!_isError) {
      _memory += double.tryParse(_currentResult) ?? 0.0;
    }
  }

  void memorySubtract() {
    if (!_isError) {
      _memory -= double.tryParse(_currentResult) ?? 0.0;
    }
  }

  void memoryRecall() {
    if (!_isError) {
      _currentResult = _formatNumber(_memory);
      _currentExpression = _currentResult;
      _isNewCalculation = true;
    }
  }

  void memoryClear() {
    _memory = 0.0;
  }

  // Scientific functions
  void inputFunction(String function) {
    if (_isError) {
      clear();
      return;
    }
    
    if (_isNewCalculation) {
      _currentExpression = function + '(' + _currentResult + ')';
    } else {
      _currentExpression += function + '(';
    }
    _isNewCalculation = false;
    _evaluateExpression();
  }

  void inputConstant(String constant) {
    if (_isError) {
      clear();
      return;
    }
    
    String value;
    switch (constant) {
      case 'π':
        value = math.pi.toString();
        break;
      case 'e':
        value = math.e.toString();
        break;
      default:
        value = constant;
    }
    
    if (_isNewCalculation) {
      _currentExpression = value;
      _isNewCalculation = false;
    } else {
      _currentExpression += value;
    }
    _evaluateExpression();
  }

  // Private methods
  double? _evaluateExpression() {
    if (_currentExpression.isEmpty) return null;
    
    try {
      // Replace display symbols with math symbols
      String expression = _currentExpression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', 'pi')
          .replaceAll('e', 'e');
      
      // Parse and evaluate expression
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      
      if (result.isInfinite || result.isNaN) {
        throw Exception('Invalid result');
      }
      
      _currentResult = _formatNumber(result);
      _isError = false;
      return result;
    } catch (e) {
      _handleError();
      return null;
    }
  }

  String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    
    // Format with appropriate decimal places
    String formatted = number.toStringAsFixed(10);
    // Remove trailing zeros
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    
    return formatted;
  }

  bool _isLastCharOperator() {
    if (_currentExpression.isEmpty) return false;
    final lastChar = _currentExpression[_currentExpression.length - 1];
    return ['+', '-', '×', '÷', '*', '/'].contains(lastChar);
  }

  bool _hasDecimalInCurrentNumber() {
    // Find the last number in the expression
    final regex = RegExp(r'[\d.]+$');
    final match = regex.firstMatch(_currentExpression);
    if (match != null) {
      return match.group(0)!.contains('.');
    }
    return false;
  }

  void _handleError() {
    _currentResult = 'Error';
    _isError = true;
  }

  void _addToHistory(String expression, String result) {
    _history.insert(0, '$expression = $result');
    // Keep only last 100 calculations
    if (_history.length > 100) {
      _history = _history.take(100).toList();
    }
  }

  // Advanced functions
  double factorial(int n) {
    if (n < 0) throw Exception('Factorial of negative number');
    if (n == 0 || n == 1) return 1;
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  double power(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }

  double squareRoot(double number) {
    if (number < 0) throw Exception('Square root of negative number');
    return math.sqrt(number);
  }

  double cubeRoot(double number) {
    return math.pow(number, 1/3).toDouble();
  }

  double nthRoot(double number, double n) {
    if (n == 0) throw Exception('Cannot calculate 0th root');
    return math.pow(number, 1/n).toDouble();
  }

  double logarithm(double number, double base) {
    if (number <= 0) throw Exception('Logarithm of non-positive number');
    if (base <= 0 || base == 1) throw Exception('Invalid logarithm base');
    return math.log(number) / math.log(base);
  }

  double naturalLogarithm(double number) {
    if (number <= 0) throw Exception('Natural logarithm of non-positive number');
    return math.log(number);
  }

  double commonLogarithm(double number) {
    if (number <= 0) throw Exception('Common logarithm of non-positive number');
    return math.log(number) / math.log(10);
  }

  double exponential(double number) {
    return math.exp(number);
  }

  double powerOf10(double number) {
    return math.pow(10, number).toDouble();
  }

  // Trigonometric functions (in radians)
  double sine(double angle) {
    return math.sin(angle);
  }

  double cosine(double angle) {
    return math.cos(angle);
  }

  double tangent(double angle) {
    return math.tan(angle);
  }

  double arcsine(double value) {
    if (value < -1 || value > 1) throw Exception('Arcsine domain error');
    return math.asin(value);
  }

  double arccosine(double value) {
    if (value < -1 || value > 1) throw Exception('Arccosine domain error');
    return math.acos(value);
  }

  double arctangent(double value) {
    return math.atan(value);
  }

  // Convert degrees to radians
  double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  // Convert radians to degrees
  double radiansToDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  // Permutation and combination
  double permutation(int n, int r) {
    if (n < 0 || r < 0 || r > n) throw Exception('Invalid permutation parameters');
    return factorial(n) / factorial(n - r);
  }

  double combination(int n, int r) {
    if (n < 0 || r < 0 || r > n) throw Exception('Invalid combination parameters');
    return factorial(n) / (factorial(r) * factorial(n - r));
  }

  // Percentage calculations
  double percentage(double value, double percent) {
    return value * percent / 100;
  }

  double percentageOf(double part, double whole) {
    if (whole == 0) throw Exception('Division by zero');
    return (part / whole) * 100;
  }

  double percentageChange(double oldValue, double newValue) {
    if (oldValue == 0) throw Exception('Division by zero');
    return ((newValue - oldValue) / oldValue) * 100;
  }
}
