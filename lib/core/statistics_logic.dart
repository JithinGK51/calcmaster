import 'dart:math' as math;

class StatisticsLogic {
  // Descriptive Statistics
  static double mean(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    return values.reduce((a, b) => a + b) / values.length;
  }
  
  static double median(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    
    final sorted = List<double>.from(values)..sort();
    final n = sorted.length;
    
    if (n % 2 == 1) {
      return sorted[n ~/ 2];
    } else {
      return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
    }
  }
  
  static double mode(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    
    final frequency = <double, int>{};
    for (final value in values) {
      frequency[value] = (frequency[value] ?? 0) + 1;
    }
    
    final maxFrequency = frequency.values.reduce(math.max);
    final modes = frequency.entries
        .where((entry) => entry.value == maxFrequency)
        .map((entry) => entry.key)
        .toList();
    
    return modes.length == 1 ? modes.first : modes.first; // Return first mode if multiple
  }
  
  static List<double> allModes(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    
    final frequency = <double, int>{};
    for (final value in values) {
      frequency[value] = (frequency[value] ?? 0) + 1;
    }
    
    final maxFrequency = frequency.values.reduce(math.max);
    return frequency.entries
        .where((entry) => entry.value == maxFrequency)
        .map((entry) => entry.key)
        .toList();
  }
  
  static double range(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    return values.reduce(math.max) - values.reduce(math.min);
  }
  
  static double variance(List<double> values, {bool isSample = true}) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    if (values.length == 1 && isSample) throw ArgumentError('Sample variance requires at least 2 values');
    
    final meanValue = mean(values);
    final squaredDiffs = values.map((x) => math.pow(x - meanValue, 2)).toList();
    final sumSquaredDiffs = squaredDiffs.reduce((a, b) => a + b);
    
    return isSample ? sumSquaredDiffs / (values.length - 1) : sumSquaredDiffs / values.length;
  }
  
  static double standardDeviation(List<double> values, {bool isSample = true}) {
    return math.sqrt(variance(values, isSample: isSample));
  }
  
  static double coefficientOfVariation(List<double> values) {
    final meanValue = mean(values);
    if (meanValue == 0) throw ArgumentError('Mean cannot be zero for coefficient of variation');
    return standardDeviation(values) / meanValue.abs() * 100;
  }
  
  // Percentiles and Quartiles
  static double percentile(List<double> values, double percentile) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    if (percentile < 0 || percentile > 100) throw ArgumentError('Percentile must be between 0 and 100');
    
    final sorted = List<double>.from(values)..sort();
    final n = sorted.length;
    
    if (percentile == 0) return sorted.first;
    if (percentile == 100) return sorted.last;
    
    final index = (percentile / 100) * (n - 1);
    final lower = sorted[index.floor()];
    final upper = sorted[index.ceil()];
    
    if (index == index.floor()) return lower;
    
    final weight = index - index.floor();
    return lower + weight * (upper - lower);
  }
  
  static Map<String, double> quartiles(List<double> values) {
    return {
      'Q1': percentile(values, 25),
      'Q2': percentile(values, 50), // Same as median
      'Q3': percentile(values, 75),
    };
  }
  
  static double interquartileRange(List<double> values) {
    final quartiles = StatisticsLogic.quartiles(values);
    return quartiles['Q3']! - quartiles['Q1']!;
  }
  
  // Skewness and Kurtosis
  static double skewness(List<double> values) {
    if (values.length < 3) throw ArgumentError('At least 3 values required for skewness');
    
    final meanValue = mean(values);
    final stdDev = standardDeviation(values);
    
    final sumCubedDiffs = values
        .map((x) => math.pow((x - meanValue) / stdDev, 3))
        .reduce((a, b) => a + b);
    
    return sumCubedDiffs / values.length;
  }
  
  static double kurtosis(List<double> values) {
    if (values.length < 4) throw ArgumentError('At least 4 values required for kurtosis');
    
    final meanValue = mean(values);
    final stdDev = standardDeviation(values);
    
    final sumFourthDiffs = values
        .map((x) => math.pow((x - meanValue) / stdDev, 4))
        .reduce((a, b) => a + b);
    
    return (sumFourthDiffs / values.length) - 3; // Excess kurtosis
  }
  
  // Correlation and Regression
  static double correlation(List<double> x, List<double> y) {
    if (x.length != y.length) throw ArgumentError('Lists must have the same length');
    if (x.length < 2) throw ArgumentError('At least 2 pairs required for correlation');
    
    final n = x.length;
    final meanX = mean(x);
    final meanY = mean(y);
    
    double numerator = 0;
    double sumXSquared = 0;
    double sumYSquared = 0;
    
    for (int i = 0; i < n; i++) {
      final diffX = x[i] - meanX;
      final diffY = y[i] - meanY;
      
      numerator += diffX * diffY;
      sumXSquared += diffX * diffX;
      sumYSquared += diffY * diffY;
    }
    
    final denominator = math.sqrt(sumXSquared * sumYSquared);
    if (denominator == 0) throw ArgumentError('Cannot calculate correlation: one variable has no variance');
    
    return numerator / denominator;
  }
  
  static Map<String, double> linearRegression(List<double> x, List<double> y) {
    if (x.length != y.length) throw ArgumentError('Lists must have the same length');
    if (x.length < 2) throw ArgumentError('At least 2 pairs required for regression');
    
    final n = x.length;
    final meanX = mean(x);
    final meanY = mean(y);
    
    double numerator = 0;
    double denominator = 0;
    
    for (int i = 0; i < n; i++) {
      final diffX = x[i] - meanX;
      numerator += diffX * (y[i] - meanY);
      denominator += diffX * diffX;
    }
    
    if (denominator == 0) throw ArgumentError('Cannot calculate regression: x variable has no variance');
    
    final slope = numerator / denominator;
    final intercept = meanY - slope * meanX;
    
    return {'slope': slope, 'intercept': intercept};
  }
  
  static double rSquared(List<double> x, List<double> y) {
    final correlation = StatisticsLogic.correlation(x, y);
    return correlation * correlation;
  }
  
  // Probability Distributions
  static double normalDistribution(double x, double mean, double stdDev) {
    final coefficient = 1 / (stdDev * math.sqrt(2 * math.pi));
    final exponent = -0.5 * math.pow((x - mean) / stdDev, 2);
    return coefficient * math.exp(exponent);
  }
  
  static double normalCumulative(double x, double mean, double stdDev) {
    // Approximation using error function
    final z = (x - mean) / stdDev;
    return 0.5 * (1 + _erf(z / math.sqrt(2)));
  }
  
  static double binomialProbability(int n, int k, double p) {
    if (n < 0 || k < 0 || k > n) throw ArgumentError('Invalid parameters');
    if (p < 0 || p > 1) throw ArgumentError('Probability must be between 0 and 1');
    
    final combination = _combination(n, k);
    return combination * math.pow(p, k) * math.pow(1 - p, n - k);
  }
  
  static double poissonProbability(int k, double lambda) {
    if (k < 0) throw ArgumentError('k must be non-negative');
    if (lambda <= 0) throw ArgumentError('lambda must be positive');
    
    return math.exp(-lambda) * math.pow(lambda, k) / _factorial(k);
  }
  
  // Confidence Intervals
  static Map<String, double> confidenceInterval(List<double> values, double confidenceLevel) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    if (confidenceLevel <= 0 || confidenceLevel >= 1) {
      throw ArgumentError('Confidence level must be between 0 and 1');
    }
    
    final meanValue = mean(values);
    final stdDev = standardDeviation(values, isSample: true);
    final n = values.length;
    
    // Using t-distribution approximation (simplified)
    final alpha = 1 - confidenceLevel;
    final tValue = _tValue(alpha / 2, n - 1);
    final marginOfError = tValue * (stdDev / math.sqrt(n));
    
    return {
      'lower': meanValue - marginOfError,
      'upper': meanValue + marginOfError,
      'marginOfError': marginOfError,
    };
  }
  
  // Hypothesis Testing
  static Map<String, dynamic> tTest(List<double> sample, double populationMean, double alpha) {
    if (sample.isEmpty) throw ArgumentError('Sample cannot be empty');
    if (alpha <= 0 || alpha >= 1) throw ArgumentError('Alpha must be between 0 and 1');
    
    final n = sample.length;
    final sampleMean = mean(sample);
    final sampleStdDev = standardDeviation(sample, isSample: true);
    
    final tStatistic = (sampleMean - populationMean) / (sampleStdDev / math.sqrt(n));
    final degreesOfFreedom = n - 1;
    final criticalValue = _tValue(alpha / 2, degreesOfFreedom);
    
    final pValue = 2 * (1 - _tCumulative(tStatistic.abs(), degreesOfFreedom));
    
    return {
      'tStatistic': tStatistic,
      'degreesOfFreedom': degreesOfFreedom,
      'criticalValue': criticalValue,
      'pValue': pValue,
      'rejectNull': tStatistic.abs() > criticalValue,
    };
  }
  
  // Utility functions
  static double _erf(double x) {
    // Approximation of error function
    final a1 = 0.254829592;
    final a2 = -0.284496736;
    final a3 = 1.421413741;
    final a4 = -1.453152027;
    final a5 = 1.061405429;
    final p = 0.3275911;
    
    final sign = x >= 0 ? 1 : -1;
    x = x.abs();
    
    final t = 1.0 / (1.0 + p * x);
    final y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);
    
    return sign * y;
  }
  
  static double _factorial(int n) {
    if (n < 0) throw ArgumentError('Factorial not defined for negative numbers');
    if (n <= 1) return 1;
    
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
  
  static double _combination(int n, int k) {
    if (k > n || k < 0) return 0;
    if (k == 0 || k == n) return 1;
    
    double result = 1;
    for (int i = 0; i < k; i++) {
      result = result * (n - i) / (i + 1);
    }
    return result;
  }
  
  static double _tValue(double alpha, int degreesOfFreedom) {
    // Simplified t-value lookup (for common values)
    final tTable = {
      1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571,
      6: 2.447, 7: 2.365, 8: 2.306, 9: 2.262, 10: 2.228,
      15: 2.131, 20: 2.086, 25: 2.060, 30: 2.042, 40: 2.021,
      50: 2.009, 60: 2.000, 80: 1.990, 100: 1.984, 120: 1.980,
    };
    
    if (degreesOfFreedom >= 120) return 1.96; // Approximate with normal distribution
    if (tTable.containsKey(degreesOfFreedom)) return tTable[degreesOfFreedom]!;
    
    // Linear interpolation for intermediate values
    final keys = tTable.keys.toList()..sort();
    for (int i = 0; i < keys.length - 1; i++) {
      if (degreesOfFreedom >= keys[i] && degreesOfFreedom <= keys[i + 1]) {
        final x1 = keys[i].toDouble();
        final y1 = tTable[keys[i]]!;
        final x2 = keys[i + 1].toDouble();
        final y2 = tTable[keys[i + 1]]!;
        
        return y1 + (y2 - y1) * (degreesOfFreedom - x1) / (x2 - x1);
      }
    }
    
    return 1.96; // Fallback
  }
  
  static double _tCumulative(double t, int degreesOfFreedom) {
    // Simplified t-distribution cumulative function
    // This is a rough approximation
    if (degreesOfFreedom >= 30) {
      return normalCumulative(t, 0, 1);
    }
    
    // For smaller degrees of freedom, use approximation
    final tValue = _tValue(0.05, degreesOfFreedom);
    if (t.abs() > tValue) return 0.95;
    return 0.5 + 0.5 * _erf(t / math.sqrt(2));
  }
  
  // Data transformation
  static List<double> standardize(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    
    final meanValue = mean(values);
    final stdDev = standardDeviation(values);
    
    if (stdDev == 0) throw ArgumentError('Cannot standardize: standard deviation is zero');
    
    return values.map((x) => (x - meanValue) / stdDev).toList();
  }
  
  static List<double> normalize(List<double> values) {
    if (values.isEmpty) throw ArgumentError('List cannot be empty');
    
    final min = values.reduce(math.min);
    final max = values.reduce(math.max);
    
    if (max == min) return List.filled(values.length, 0.5);
    
    return values.map((x) => (x - min) / (max - min)).toList();
  }
}
