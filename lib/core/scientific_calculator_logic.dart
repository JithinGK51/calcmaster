import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class ScientificCalculatorLogic {
  static const double pi = math.pi;
  static const double e = math.e;
  
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
  
  // Trigonometric functions (in radians)
  static double sin(double angle) => math.sin(angle);
  static double cos(double angle) => math.cos(angle);
  static double tan(double angle) => math.tan(angle);
  
  // Inverse trigonometric functions
  static double asin(double value) {
    if (value < -1 || value > 1) {
      throw ArgumentError('Domain error: asin($value)');
    }
    return math.asin(value);
  }
  
  static double acos(double value) {
    if (value < -1 || value > 1) {
      throw ArgumentError('Domain error: acos($value)');
    }
    return math.acos(value);
  }
  
  static double atan(double value) => math.atan(value);
  
  // Hyperbolic functions
  static double sinh(double x) => (math.exp(x) - math.exp(-x)) / 2;
  static double cosh(double x) => (math.exp(x) + math.exp(-x)) / 2;
  static double tanh(double x) => sinh(x) / cosh(x);
  
  // Logarithmic functions
  static double log(double value) {
    if (value <= 0) {
      throw ArgumentError('Domain error: log($value)');
    }
    return math.log(value) / math.ln10;
  }
  
  static double ln(double value) {
    if (value <= 0) {
      throw ArgumentError('Domain error: ln($value)');
    }
    return math.log(value);
  }
  
  static double log2(double value) {
    if (value <= 0) {
      throw ArgumentError('Domain error: log2($value)');
    }
    return math.log(value) / math.ln2;
  }
  
  // Exponential functions
  static double exp(double x) => math.exp(x);
  static double exp10(double x) => math.pow(10, x).toDouble();
  static double exp2(double x) => math.pow(2, x).toDouble();
  
  // Power functions
  static double pow(double base, double exponent) => math.pow(base, exponent).toDouble();
  static double sqrt(double value) {
    if (value < 0) {
      throw ArgumentError('Domain error: sqrt($value)');
    }
    return math.sqrt(value);
  }
  
  static double cbrt(double value) => math.pow(value, 1/3).toDouble();
  static double nthRoot(double value, double n) {
    if (n == 0) {
      throw ArgumentError('Cannot calculate 0th root');
    }
    return math.pow(value, 1/n).toDouble();
  }
  
  // Factorial
  static double factorial(int n) {
    if (n < 0) {
      throw ArgumentError('Factorial of negative number');
    }
    if (n == 0 || n == 1) return 1;
    
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
  
  // Permutation and combination
  static double permutation(int n, int r) {
    if (n < 0 || r < 0 || r > n) {
      throw ArgumentError('Invalid permutation parameters');
    }
    return factorial(n) / factorial(n - r);
  }
  
  static double combination(int n, int r) {
    if (n < 0 || r < 0 || r > n) {
      throw ArgumentError('Invalid combination parameters');
    }
    return factorial(n) / (factorial(r) * factorial(n - r));
  }
  
  // Statistical functions
  static double mean(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
  
  static double median(List<double> values) {
    if (values.isEmpty) return 0;
    final sorted = List<double>.from(values)..sort();
    final n = sorted.length;
    if (n % 2 == 1) {
      return sorted[n ~/ 2];
    } else {
      return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
    }
  }
  
  static double mode(List<double> values) {
    if (values.isEmpty) return 0;
    final frequency = <double, int>{};
    for (final value in values) {
      frequency[value] = (frequency[value] ?? 0) + 1;
    }
    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
  
  static double variance(List<double> values) {
    if (values.isEmpty) return 0;
    final meanValue = mean(values);
    final squaredDiffs = values.map((x) => math.pow(x - meanValue, 2).toDouble()).toList();
    return mean(squaredDiffs);
  }
  
  static double standardDeviation(List<double> values) => sqrt(variance(values));
  
  // Angle conversions
  static double degreesToRadians(double degrees) => degrees * pi / 180;
  static double radiansToDegrees(double radians) => radians * 180 / pi;
  
  // Percentage calculations
  static double percentage(double value, double percent) => value * percent / 100;
  static double percentageOf(double part, double whole) {
    if (whole == 0) throw ArgumentError('Division by zero');
    return (part / whole) * 100;
  }
  static double percentageChange(double oldValue, double newValue) {
    if (oldValue == 0) throw ArgumentError('Division by zero');
    return ((newValue - oldValue) / oldValue) * 100;
  }
  
  // Rounding functions
  static double round(double value, int decimals) {
    final factor = math.pow(10, decimals).toDouble();
    return (value * factor).round() / factor;
  }
  
  static double floor(double value) => value.floorToDouble();
  static double ceil(double value) => value.ceilToDouble();
  static double abs(double value) => value.abs();
  
  // Random number generation
  static double random() => math.Random().nextDouble();
  static double randomRange(double min, double max) {
    return min + (max - min) * math.Random().nextDouble();
  }
  
  // Constants
  static const double goldenRatio = 1.618033988749895;
  static const double eulerMascheroni = 0.5772156649015329;
  static const double catalan = 0.915965594177219;
  
  // Complex number operations (basic)
  static Map<String, double> complexAdd(double a, double b, double c, double d) {
    return {'real': a + c, 'imaginary': b + d};
  }
  
  static Map<String, double> complexSubtract(double a, double b, double c, double d) {
    return {'real': a - c, 'imaginary': b - d};
  }
  
  static Map<String, double> complexMultiply(double a, double b, double c, double d) {
    return {
      'real': a * c - b * d,
      'imaginary': a * d + b * c,
    };
  }
  
  static Map<String, double> complexDivide(double a, double b, double c, double d) {
    final denominator = c * c + d * d;
    if (denominator == 0) {
      throw ArgumentError('Division by zero in complex numbers');
    }
    return {
      'real': (a * c + b * d) / denominator,
      'imaginary': (b * c - a * d) / denominator,
    };
  }
  
  // Matrix operations (basic 2x2)
  static List<List<double>> matrixAdd(List<List<double>> a, List<List<double>> b) {
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
  
  static List<List<double>> matrixMultiply(List<List<double>> a, List<List<double>> b) {
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
  
  static double matrixDeterminant2x2(List<List<double>> matrix) {
    if (matrix.length != 2 || matrix[0].length != 2) {
      throw ArgumentError('Matrix must be 2x2');
    }
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
  }
  
  // Unit conversions
  static double convertTemperature(double value, String from, String to) {
    // Convert to Celsius first
    double celsius;
    switch (from.toLowerCase()) {
      case 'celsius':
      case 'c':
        celsius = value;
        break;
      case 'fahrenheit':
      case 'f':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'kelvin':
      case 'k':
        celsius = value - 273.15;
        break;
      default:
        throw ArgumentError('Unknown temperature unit: $from');
    }
    
    // Convert from Celsius to target
    switch (to.toLowerCase()) {
      case 'celsius':
      case 'c':
        return celsius;
      case 'fahrenheit':
      case 'f':
        return celsius * 9 / 5 + 32;
      case 'kelvin':
      case 'k':
        return celsius + 273.15;
      default:
        throw ArgumentError('Unknown temperature unit: $to');
    }
  }
  
  // Formatting utilities
  static String formatScientific(double value, {int precision = 6}) {
    if (value == 0) return '0';
    
    final exponent = (math.log(value.abs()) / math.ln10).floor();
    final mantissa = value / math.pow(10, exponent);
    
    return '${mantissa.toStringAsFixed(precision)}e${exponent >= 0 ? '+' : ''}$exponent';
  }
  
  static String formatEngineering(double value, {int precision = 3}) {
    if (value == 0) return '0';
    
    final exponent = (math.log(value.abs()) / math.ln10).floor();
    final engineeringExponent = (exponent ~/ 3) * 3;
    final mantissa = value / math.pow(10, engineeringExponent);
    
    return '${mantissa.toStringAsFixed(precision)}e${engineeringExponent >= 0 ? '+' : ''}$engineeringExponent';
  }
}
