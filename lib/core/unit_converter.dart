
class UnitConverter {
  // Length conversions (base unit: meter)
  static const Map<String, double> _lengthFactors = {
    'mm': 0.001,
    'cm': 0.01,
    'm': 1.0,
    'km': 1000.0,
    'in': 0.0254,
    'ft': 0.3048,
    'yd': 0.9144,
    'mi': 1609.344,
    'nm': 0.000000001,
    'μm': 0.000001,
    'dm': 0.1,
    'dam': 10.0,
    'hm': 100.0,
  };
  
  // Mass conversions (base unit: kilogram)
  static const Map<String, double> _massFactors = {
    'mg': 0.000001,
    'g': 0.001,
    'kg': 1.0,
    't': 1000.0,
    'oz': 0.0283495,
    'lb': 0.453592,
    'st': 6.35029,
    'ton': 1016.05, // Imperial ton
    'tonne': 1000.0, // Metric ton
  };
  
  // Volume conversions (base unit: liter)
  static const Map<String, double> _volumeFactors = {
    'ml': 0.001,
    'l': 1.0,
    'gal': 3.78541, // US gallon
    'qt': 0.946353, // US quart
    'pt': 0.473176, // US pint
    'cup': 0.236588, // US cup
    'fl_oz': 0.0295735, // US fluid ounce
    'tbsp': 0.0147868, // US tablespoon
    'tsp': 0.00492892, // US teaspoon
    'm3': 1000.0, // Cubic meter
    'cm3': 0.001, // Cubic centimeter
    'in3': 0.0163871, // Cubic inch
    'ft3': 28.3168, // Cubic foot
  };
  
  // Temperature conversions (special handling required)
  static double convertTemperature(double value, String from, String to) {
    // Convert to Celsius first
    double celsius;
    switch (from.toLowerCase()) {
      case 'c':
      case 'celsius':
        celsius = value;
        break;
      case 'f':
      case 'fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'k':
      case 'kelvin':
        celsius = value - 273.15;
        break;
      case 'r':
      case 'rankine':
        celsius = (value - 491.67) * 5 / 9;
        break;
      default:
        throw ArgumentError('Unknown temperature unit: $from');
    }
    
    // Convert from Celsius to target
    switch (to.toLowerCase()) {
      case 'c':
      case 'celsius':
        return celsius;
      case 'f':
      case 'fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'k':
      case 'kelvin':
        return celsius + 273.15;
      case 'r':
      case 'rankine':
        return celsius * 9 / 5 + 491.67;
      default:
        throw ArgumentError('Unknown temperature unit: $to');
    }
  }
  
  // Speed conversions (base unit: m/s)
  static const Map<String, double> _speedFactors = {
    'm/s': 1.0,
    'km/h': 0.277778,
    'mph': 0.44704,
    'ft/s': 0.3048,
    'knot': 0.514444,
    'mach': 343.0, // At sea level
  };
  
  // Pressure conversions (base unit: Pascal)
  static const Map<String, double> _pressureFactors = {
    'pa': 1.0,
    'kpa': 1000.0,
    'mpa': 1000000.0,
    'bar': 100000.0,
    'atm': 101325.0,
    'psi': 6894.76,
    'torr': 133.322,
    'mmhg': 133.322,
    'inhg': 3386.39,
  };
  
  // Energy conversions (base unit: Joule)
  static const Map<String, double> _energyFactors = {
    'j': 1.0,
    'kj': 1000.0,
    'mj': 1000000.0,
    'cal': 4.184,
    'kcal': 4184.0,
    'wh': 3600.0,
    'kwh': 3600000.0,
    'btu': 1055.06,
    'therm': 105506000.0,
  };
  
  // Power conversions (base unit: Watt)
  static const Map<String, double> _powerFactors = {
    'w': 1.0,
    'kw': 1000.0,
    'mw': 1000000.0,
    'hp': 745.7, // Mechanical horsepower
    'ps': 735.499, // Metric horsepower
    'btu/h': 0.293071,
  };
  
  // Area conversions (base unit: square meter)
  static const Map<String, double> _areaFactors = {
    'mm2': 0.000001,
    'cm2': 0.0001,
    'm2': 1.0,
    'km2': 1000000.0,
    'in2': 0.00064516,
    'ft2': 0.092903,
    'yd2': 0.836127,
    'acre': 4046.86,
    'hectare': 10000.0,
    'mi2': 2589988.11,
  };
  
  // Time conversions (base unit: second)
  static const Map<String, double> _timeFactors = {
    'ns': 0.000000001,
    'μs': 0.000001,
    'ms': 0.001,
    's': 1.0,
    'min': 60.0,
    'h': 3600.0,
    'day': 86400.0,
    'week': 604800.0,
    'month': 2629746.0, // Average month
    'year': 31556952.0, // Average year
  };
  
  // Generic conversion function
  static double convert(double value, String from, String to, String category) {
    switch (category.toLowerCase()) {
      case 'length':
        return _convertWithFactors(value, from, to, _lengthFactors);
      case 'mass':
      case 'weight':
        return _convertWithFactors(value, from, to, _massFactors);
      case 'volume':
        return _convertWithFactors(value, from, to, _volumeFactors);
      case 'temperature':
        return convertTemperature(value, from, to);
      case 'speed':
        return _convertWithFactors(value, from, to, _speedFactors);
      case 'pressure':
        return _convertWithFactors(value, from, to, _pressureFactors);
      case 'energy':
        return _convertWithFactors(value, from, to, _energyFactors);
      case 'power':
        return _convertWithFactors(value, from, to, _powerFactors);
      case 'area':
        return _convertWithFactors(value, from, to, _areaFactors);
      case 'time':
        return _convertWithFactors(value, from, to, _timeFactors);
      default:
        throw ArgumentError('Unknown conversion category: $category');
    }
  }
  
  static double _convertWithFactors(double value, String from, String to, Map<String, double> factors) {
    final fromFactor = factors[from.toLowerCase()];
    final toFactor = factors[to.toLowerCase()];
    
    if (fromFactor == null) throw ArgumentError('Unknown unit: $from');
    if (toFactor == null) throw ArgumentError('Unknown unit: $to');
    
    // Convert to base unit, then to target unit
    final baseValue = value * fromFactor;
    return baseValue / toFactor;
  }
  
  // Get available units for a category
  static List<String> getAvailableUnits(String category) {
    switch (category.toLowerCase()) {
      case 'length':
        return _lengthFactors.keys.toList();
      case 'mass':
      case 'weight':
        return _massFactors.keys.toList();
      case 'volume':
        return _volumeFactors.keys.toList();
      case 'temperature':
        return ['c', 'f', 'k', 'r'];
      case 'speed':
        return _speedFactors.keys.toList();
      case 'pressure':
        return _pressureFactors.keys.toList();
      case 'energy':
        return _energyFactors.keys.toList();
      case 'power':
        return _powerFactors.keys.toList();
      case 'area':
        return _areaFactors.keys.toList();
      case 'time':
        return _timeFactors.keys.toList();
      default:
        return [];
    }
  }
  
  // Get unit display names
  static String getUnitDisplayName(String unit, String category) {
    final displayNames = {
      'length': {
        'mm': 'Millimeter',
        'cm': 'Centimeter',
        'm': 'Meter',
        'km': 'Kilometer',
        'in': 'Inch',
        'ft': 'Foot',
        'yd': 'Yard',
        'mi': 'Mile',
        'nm': 'Nanometer',
        'μm': 'Micrometer',
        'dm': 'Decimeter',
        'dam': 'Decameter',
        'hm': 'Hectometer',
      },
      'mass': {
        'mg': 'Milligram',
        'g': 'Gram',
        'kg': 'Kilogram',
        't': 'Ton',
        'oz': 'Ounce',
        'lb': 'Pound',
        'st': 'Stone',
        'ton': 'Imperial Ton',
        'tonne': 'Metric Ton',
      },
      'volume': {
        'ml': 'Milliliter',
        'l': 'Liter',
        'gal': 'Gallon',
        'qt': 'Quart',
        'pt': 'Pint',
        'cup': 'Cup',
        'fl_oz': 'Fluid Ounce',
        'tbsp': 'Tablespoon',
        'tsp': 'Teaspoon',
        'm3': 'Cubic Meter',
        'cm3': 'Cubic Centimeter',
        'in3': 'Cubic Inch',
        'ft3': 'Cubic Foot',
      },
      'temperature': {
        'c': 'Celsius',
        'f': 'Fahrenheit',
        'k': 'Kelvin',
        'r': 'Rankine',
      },
      'speed': {
        'm/s': 'Meter per Second',
        'km/h': 'Kilometer per Hour',
        'mph': 'Mile per Hour',
        'ft/s': 'Foot per Second',
        'knot': 'Knot',
        'mach': 'Mach',
      },
      'pressure': {
        'pa': 'Pascal',
        'kpa': 'Kilopascal',
        'mpa': 'Megapascal',
        'bar': 'Bar',
        'atm': 'Atmosphere',
        'psi': 'Pound per Square Inch',
        'torr': 'Torr',
        'mmhg': 'Millimeter of Mercury',
        'inhg': 'Inch of Mercury',
      },
      'energy': {
        'j': 'Joule',
        'kj': 'Kilojoule',
        'mj': 'Megajoule',
        'cal': 'Calorie',
        'kcal': 'Kilocalorie',
        'wh': 'Watt Hour',
        'kwh': 'Kilowatt Hour',
        'btu': 'British Thermal Unit',
        'therm': 'Therm',
      },
      'power': {
        'w': 'Watt',
        'kw': 'Kilowatt',
        'mw': 'Megawatt',
        'hp': 'Horsepower',
        'ps': 'Metric Horsepower',
        'btu/h': 'BTU per Hour',
      },
      'area': {
        'mm2': 'Square Millimeter',
        'cm2': 'Square Centimeter',
        'm2': 'Square Meter',
        'km2': 'Square Kilometer',
        'in2': 'Square Inch',
        'ft2': 'Square Foot',
        'yd2': 'Square Yard',
        'acre': 'Acre',
        'hectare': 'Hectare',
        'mi2': 'Square Mile',
      },
      'time': {
        'ns': 'Nanosecond',
        'μs': 'Microsecond',
        'ms': 'Millisecond',
        's': 'Second',
        'min': 'Minute',
        'h': 'Hour',
        'day': 'Day',
        'week': 'Week',
        'month': 'Month',
        'year': 'Year',
      },
    };
    
    return displayNames[category.toLowerCase()]?[unit.toLowerCase()] ?? unit;
  }
  
  // Get all available categories
  static List<String> getAvailableCategories() {
    return [
      'Length',
      'Mass',
      'Volume',
      'Temperature',
      'Speed',
      'Pressure',
      'Energy',
      'Power',
      'Area',
      'Time',
    ];
  }
  
  // Format result with appropriate precision
  static String formatResult(double value, {int precision = 6}) {
    if (value == 0) return '0';
    
    // Handle very large or very small numbers
    if (value.abs() >= 1e6 || (value.abs() < 1e-3 && value != 0)) {
      return value.toStringAsExponential(precision);
    }
    
    // Remove trailing zeros
    String formatted = value.toStringAsFixed(precision);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    
    return formatted;
  }
  
  // Validate unit compatibility
  static bool areUnitsCompatible(String unit1, String unit2, String category) {
    final units = getAvailableUnits(category);
    return units.contains(unit1.toLowerCase()) && units.contains(unit2.toLowerCase());
  }
  
  // Get conversion factor between two units
  static double getConversionFactor(String from, String to, String category) {
    if (category.toLowerCase() == 'temperature') {
      // Temperature conversion is not linear, so we can't provide a simple factor
      throw ArgumentError('Temperature conversion requires special handling');
    }
    
    final factors = _getFactorsForCategory(category);
    final fromFactor = factors[from.toLowerCase()];
    final toFactor = factors[to.toLowerCase()];
    
    if (fromFactor == null || toFactor == null) {
      throw ArgumentError('Invalid units for category: $category');
    }
    
    return fromFactor / toFactor;
  }
  
  static Map<String, double> _getFactorsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'length':
        return _lengthFactors;
      case 'mass':
      case 'weight':
        return _massFactors;
      case 'volume':
        return _volumeFactors;
      case 'speed':
        return _speedFactors;
      case 'pressure':
        return _pressureFactors;
      case 'energy':
        return _energyFactors;
      case 'power':
        return _powerFactors;
      case 'area':
        return _areaFactors;
      case 'time':
        return _timeFactors;
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }
}
