import 'dart:math' as math;

class CurrencyConverter {
  // Base currency: USD
  // static const String _baseCurrency = 'USD'; // Commented out as not currently used
  
  // Exchange rates (as of a sample date - in real app, these would be updated)
  static const Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'CAD': 1.25,
    'AUD': 1.35,
    'CHF': 0.92,
    'CNY': 6.45,
    'INR': 74.0,
    'BRL': 5.2,
    'MXN': 20.0,
    'KRW': 1180.0,
    'SGD': 1.35,
    'HKD': 7.8,
    'NZD': 1.45,
    'NOK': 8.5,
    'SEK': 8.7,
    'DKK': 6.3,
    'PLN': 3.9,
    'CZK': 21.5,
    'HUF': 300.0,
    'RUB': 73.0,
    'TRY': 8.5,
    'ZAR': 14.5,
    'AED': 3.67,
    'SAR': 3.75,
    'QAR': 3.64,
    'KWD': 0.30,
    'BHD': 0.38,
    'OMR': 0.38,
    'JOD': 0.71,
    'LBP': 1500.0,
    'EGP': 15.7,
    'ILS': 3.2,
    'THB': 33.0,
    'MYR': 4.2,
    'IDR': 14300.0,
    'PHP': 50.0,
    'VND': 23000.0,
    'PKR': 160.0,
    'BDT': 85.0,
    'LKR': 200.0,
    'NPR': 118.0,
    'AFN': 78.0,
    'IRR': 42000.0,
    'IQD': 1460.0,
    'KZT': 425.0,
    'UAH': 27.0,
    'BYN': 2.5,
    'MDL': 17.5,
    'RON': 4.2,
    'BGN': 1.66,
    'HRK': 6.4,
    'RSD': 100.0,
    'MKD': 52.0,
    'ALL': 104.0,
    'BAM': 1.66,
    'ISK': 130.0,
    'UYU': 43.0,
    'ARS': 100.0,
    'CLP': 800.0,
    'COP': 3800.0,
    'PEN': 3.6,
    'BOB': 6.9,
    'PYG': 7000.0,
    'VES': 4.5,
    'GYD': 209.0,
    'SRD': 21.0,
    'TTD': 6.8,
    'JMD': 150.0,
    'BBD': 2.0,
    'BZD': 2.0,
    'XCD': 2.7,
    'AWG': 1.8,
    'ANG': 1.8,
    'KYD': 0.83,
    'BSD': 1.0,
    'BMD': 1.0,
    'FJD': 2.1,
    'PGK': 3.5,
    'SBD': 8.0,
    'VUV': 110.0,
    'WST': 2.6,
    'TOP': 2.3,
    'NIO': 35.0,
    'GTQ': 7.7,
    'HNL': 24.0,
    'SVC': 8.75,
    'CRC': 620.0,
    'PAB': 1.0,
    'DOP': 57.0,
    'HTG': 100.0,
    'CUP': 25.0,
    'XOF': 550.0,
    'XAF': 550.0,
    'XPF': 100.0,
    'MAD': 9.0,
    'TND': 2.8,
    'DZD': 135.0,
    'LYD': 4.5,
    'ETB': 43.0,
    'KES': 110.0,
    'UGX': 3500.0,
    'TZS': 2300.0,
    'MWK': 800.0,
    'ZMW': 18.0,
    'BWP': 11.0,
    'SZL': 14.5,
    'LSL': 14.5,
    'NAD': 14.5,
    'MZN': 63.0,
    'AOA': 650.0,
    'GMD': 52.0,
    'GHS': 6.0,
    'NGN': 410.0,
    'CDF': 2000.0,
    'RWF': 1000.0,
    'BIF': 2000.0,
    'DJF': 178.0,
    'SOS': 580.0,
    'ERN': 15.0,
    'SDG': 55.0,
    'SSP': 130.0,
    'CVE': 100.0,
    'STN': 22.0,
  };
  
  // Currency information
  static const Map<String, Map<String, String>> _currencyInfo = {
    'USD': {'name': 'US Dollar', 'symbol': '\$', 'code': 'USD'},
    'EUR': {'name': 'Euro', 'symbol': '€', 'code': 'EUR'},
    'GBP': {'name': 'British Pound', 'symbol': '£', 'code': 'GBP'},
    'JPY': {'name': 'Japanese Yen', 'symbol': '¥', 'code': 'JPY'},
    'CAD': {'name': 'Canadian Dollar', 'symbol': 'C\$', 'code': 'CAD'},
    'AUD': {'name': 'Australian Dollar', 'symbol': 'A\$', 'code': 'AUD'},
    'CHF': {'name': 'Swiss Franc', 'symbol': 'CHF', 'code': 'CHF'},
    'CNY': {'name': 'Chinese Yuan', 'symbol': '¥', 'code': 'CNY'},
    'INR': {'name': 'Indian Rupee', 'symbol': '₹', 'code': 'INR'},
    'BRL': {'name': 'Brazilian Real', 'symbol': 'R\$', 'code': 'BRL'},
    'MXN': {'name': 'Mexican Peso', 'symbol': '\$', 'code': 'MXN'},
    'KRW': {'name': 'South Korean Won', 'symbol': '₩', 'code': 'KRW'},
    'SGD': {'name': 'Singapore Dollar', 'symbol': 'S\$', 'code': 'SGD'},
    'HKD': {'name': 'Hong Kong Dollar', 'symbol': 'HK\$', 'code': 'HKD'},
    'NZD': {'name': 'New Zealand Dollar', 'symbol': 'NZ\$', 'code': 'NZD'},
  };
  
  // Convert between currencies
  static double convert(double amount, String fromCurrency, String toCurrency) {
    if (amount < 0) throw ArgumentError('Amount cannot be negative');
    
    final fromRate = _exchangeRates[fromCurrency.toUpperCase()];
    final toRate = _exchangeRates[toCurrency.toUpperCase()];
    
    if (fromRate == null) throw ArgumentError('Unknown currency: $fromCurrency');
    if (toRate == null) throw ArgumentError('Unknown currency: $toCurrency');
    
    // Convert to USD first, then to target currency
    final usdAmount = amount / fromRate;
    return usdAmount * toRate;
  }
  
  // Get exchange rate between two currencies
  static double getExchangeRate(String fromCurrency, String toCurrency) {
    final fromRate = _exchangeRates[fromCurrency.toUpperCase()];
    final toRate = _exchangeRates[toCurrency.toUpperCase()];
    
    if (fromRate == null) throw ArgumentError('Unknown currency: $fromCurrency');
    if (toRate == null) throw ArgumentError('Unknown currency: $toCurrency');
    
    return toRate / fromRate;
  }
  
  // Get all available currencies
  static List<String> getAvailableCurrencies() {
    return _exchangeRates.keys.toList()..sort();
  }
  
  // Get currency information
  static Map<String, String>? getCurrencyInfo(String currencyCode) {
    return _currencyInfo[currencyCode.toUpperCase()];
  }
  
  // Get currency name
  static String getCurrencyName(String currencyCode) {
    return _currencyInfo[currencyCode.toUpperCase()]?['name'] ?? currencyCode;
  }
  
  // Get currency symbol
  static String getCurrencySymbol(String currencyCode) {
    return _currencyInfo[currencyCode.toUpperCase()]?['symbol'] ?? currencyCode;
  }
  
  // Format currency amount
  static String formatCurrency(double amount, String currencyCode, {int decimalPlaces = 2}) {
    final symbol = getCurrencySymbol(currencyCode);
    final formattedAmount = _formatNumber(amount, decimalPlaces);
    
    // Different positioning for different currencies
    switch (currencyCode.toUpperCase()) {
      case 'USD':
      case 'CAD':
      case 'AUD':
      case 'NZD':
      case 'SGD':
      case 'HKD':
        return '$symbol$formattedAmount';
      case 'EUR':
      case 'GBP':
        return '$symbol$formattedAmount';
      case 'JPY':
      case 'KRW':
        return '$symbol$formattedAmount';
      case 'INR':
        return '₹$formattedAmount';
      default:
        return '$formattedAmount $symbol';
    }
  }
  
  // Format number with appropriate decimal places
  static String _formatNumber(double number, int decimalPlaces) {
    if (number == 0) return '0';
    
    // Handle very large numbers
    if (number.abs() >= 1e6) {
      return number.toStringAsExponential(decimalPlaces);
    }
    
    // Remove trailing zeros
    String formatted = number.toStringAsFixed(decimalPlaces);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    
    // Add thousand separators
    final parts = formatted.split('.');
    if (parts[0].length > 3) {
      final integerPart = parts[0];
      final reversed = integerPart.split('').reversed.join('');
      final withCommas = reversed.replaceAllMapped(
        RegExp(r'.{3}'),
        (match) => '${match.group(0)},',
      );
      parts[0] = withCommas.split('').reversed.join('').replaceFirst(',', '');
    }
    
    return parts.length > 1 ? '${parts[0]}.${parts[1]}' : parts[0];
  }
  
  // Get popular currency pairs
  static List<List<String>> getPopularPairs() {
    return [
      ['USD', 'EUR'],
      ['USD', 'GBP'],
      ['USD', 'JPY'],
      ['USD', 'CAD'],
      ['USD', 'AUD'],
      ['USD', 'CHF'],
      ['USD', 'CNY'],
      ['USD', 'INR'],
      ['EUR', 'GBP'],
      ['EUR', 'JPY'],
      ['GBP', 'JPY'],
      ['AUD', 'NZD'],
      ['USD', 'BRL'],
      ['USD', 'MXN'],
      ['USD', 'KRW'],
    ];
  }
  
  // Get currencies by region
  static Map<String, List<String>> getCurrenciesByRegion() {
    return {
      'North America': ['USD', 'CAD', 'MXN'],
      'Europe': ['EUR', 'GBP', 'CHF', 'NOK', 'SEK', 'DKK', 'PLN', 'CZK', 'HUF', 'RUB'],
      'Asia': ['JPY', 'CNY', 'KRW', 'SGD', 'HKD', 'INR', 'THB', 'MYR', 'IDR', 'PHP'],
      'Oceania': ['AUD', 'NZD', 'FJD'],
      'South America': ['BRL', 'ARS', 'CLP', 'COP', 'PEN', 'BOB', 'PYG'],
      'Africa': ['ZAR', 'EGP', 'NGN', 'KES', 'GHS', 'MAD', 'TND'],
      'Middle East': ['AED', 'SAR', 'QAR', 'KWD', 'BHD', 'OMR', 'JOD', 'ILS'],
    };
  }
  
  // Calculate percentage change
  static double calculatePercentageChange(double oldRate, double newRate) {
    if (oldRate == 0) throw ArgumentError('Old rate cannot be zero');
    return ((newRate - oldRate) / oldRate) * 100;
  }
  
  // Get cross rates (rates between non-USD currencies)
  static double getCrossRate(String fromCurrency, String toCurrency) {
    if (fromCurrency.toUpperCase() == toCurrency.toUpperCase()) return 1.0;
    
    final fromRate = _exchangeRates[fromCurrency.toUpperCase()];
    final toRate = _exchangeRates[toCurrency.toUpperCase()];
    
    if (fromRate == null) throw ArgumentError('Unknown currency: $fromCurrency');
    if (toRate == null) throw ArgumentError('Unknown currency: $toCurrency');
    
    return toRate / fromRate;
  }
  
  // Validate currency code
  static bool isValidCurrency(String currencyCode) {
    return _exchangeRates.containsKey(currencyCode.toUpperCase());
  }
  
  // Get currency history (mock data - in real app, this would come from API)
  static List<Map<String, dynamic>> getCurrencyHistory(String fromCurrency, String toCurrency, int days) {
    final List<Map<String, dynamic>> history = [];
    final currentRate = getExchangeRate(fromCurrency, toCurrency);
    
    for (int i = days; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      // Simulate rate fluctuation (±2% daily)
      final fluctuation = (math.Random().nextDouble() - 0.5) * 0.04;
      final rate = currentRate * (1 + fluctuation);
      
      history.add({
        'date': date.toIso8601String().split('T')[0],
        'rate': rate,
        'high': rate * (1 + math.Random().nextDouble() * 0.01),
        'low': rate * (1 - math.Random().nextDouble() * 0.01),
        'open': rate * (1 + (math.Random().nextDouble() - 0.5) * 0.005),
        'close': rate,
      });
    }
    
    return history;
  }
  
  // Calculate compound interest in different currencies
  static double calculateCompoundInterest(
    double principal,
    double annualRate,
    int years,
    int compoundingFrequency,
    String currency,
  ) {
    if (principal < 0) throw ArgumentError('Principal cannot be negative');
    if (annualRate < 0) throw ArgumentError('Interest rate cannot be negative');
    if (years < 0) throw ArgumentError('Years cannot be negative');
    if (compoundingFrequency <= 0) throw ArgumentError('Compounding frequency must be positive');
    
    final rate = annualRate / 100;
    final amount = principal * math.pow(1 + rate / compoundingFrequency, compoundingFrequency * years);
    return amount;
  }
  
  // Convert and format for display
  static String convertAndFormat(double amount, String fromCurrency, String toCurrency, {int decimalPlaces = 2}) {
    final convertedAmount = convert(amount, fromCurrency, toCurrency);
    return formatCurrency(convertedAmount, toCurrency, decimalPlaces: decimalPlaces);
  }
}
