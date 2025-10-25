import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/unit_converter.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class UnitConverterScreen extends ConsumerStatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  ConsumerState<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends ConsumerState<UnitConverterScreen> {
  String _selectedCategory = 'Length';
  String _fromUnit = '';
  String _toUnit = '';
  final TextEditingController _valueController = TextEditingController();
  String _result = '';
  bool _isTTSEnabled = false;

  final Map<String, List<String>> _categoryUnits = {
    'Length': ['mm', 'cm', 'm', 'km', 'in', 'ft', 'yd', 'mi'],
    'Mass': ['mg', 'g', 'kg', 't', 'oz', 'lb', 'st', 'ton'],
    'Volume': ['ml', 'l', 'gal', 'qt', 'pt', 'cup', 'fl_oz', 'm3'],
    'Temperature': ['c', 'f', 'k', 'r'],
    'Speed': ['m/s', 'km/h', 'mph', 'ft/s', 'knot', 'mach'],
    'Pressure': ['pa', 'kpa', 'mpa', 'bar', 'atm', 'psi', 'torr'],
    'Energy': ['j', 'kj', 'mj', 'cal', 'kcal', 'wh', 'kwh', 'btu'],
    'Power': ['w', 'kw', 'mw', 'hp', 'ps', 'btu/h'],
    'Area': ['mm2', 'cm2', 'm2', 'km2', 'in2', 'ft2', 'yd2', 'acre'],
    'Time': ['ns', 'μs', 'ms', 's', 'min', 'h', 'day', 'week'],
  };

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _initializeUnits();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  void _initializeUnits() {
    final units = _categoryUnits[_selectedCategory]!;
    _fromUnit = units.first;
    _toUnit = units.length > 1 ? units[1] : units.first;
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _initializeUnits();
      _result = '';
    });
  }

  void _onFromUnitChanged(String unit) {
    setState(() {
      _fromUnit = unit;
      _result = '';
    });
  }

  void _onToUnitChanged(String unit) {
    setState(() {
      _toUnit = unit;
      _result = '';
    });
  }

  void _convert() {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      _showError('Please enter a valid number');
      return;
    }

    try {
      double result;
      if (_selectedCategory == 'Temperature') {
        result = UnitConverter.convertTemperature(value, _fromUnit, _toUnit);
      } else {
        result = UnitConverter.convert(value, _fromUnit, _toUnit, _selectedCategory);
      }

      setState(() {
        _result = UnitConverter.formatResult(result);
      });

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        TTSService.speakConversion(
          '${_valueController.text} ${UnitConverter.getUnitDisplayName(_fromUnit, _selectedCategory)}',
          UnitConverter.getUnitDisplayName(_toUnit, _selectedCategory),
          _result,
        );
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _result = '';
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareConversion(
                  _fromUnit,
                  _toUnit,
                  double.tryParse(_valueController.text) ?? 0,
                  double.tryParse(_result) ?? 0,
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categoryUnits.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => _onCategoryChanged(value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Value Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Value',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _valueController,
                      decoration: InputDecoration(
                        hintText: 'Enter value to convert',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.numbers),
                        suffixText: UnitConverter.getUnitDisplayName(_fromUnit, _selectedCategory),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Unit Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Units',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: _fromUnit,
                                isExpanded: true,
                                items: _categoryUnits[_selectedCategory]!.map((unit) {
                                  return DropdownMenuItem(
                                    value: unit,
                                    child: Text(UnitConverter.getUnitDisplayName(unit, _selectedCategory)),
                                  );
                                }).toList(),
                                onChanged: (value) => _onFromUnitChanged(value!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _swapUnits,
                          icon: const Icon(Icons.swap_horiz),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: _toUnit,
                                isExpanded: true,
                                items: _categoryUnits[_selectedCategory]!.map((unit) {
                                  return DropdownMenuItem(
                                    value: unit,
                                    child: Text(UnitConverter.getUnitDisplayName(unit, _selectedCategory)),
                                  );
                                }).toList(),
                                onChanged: (value) => _onToUnitChanged(value!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _convert,
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Convert'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result Section
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Result',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (_isTTSEnabled)
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await TTSService.speakConversion(
                                      _fromUnit,
                                      _toUnit,
                                      _result,
                                    );
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _result));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Result copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _result,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              UnitConverter.getUnitDisplayName(_toUnit, _selectedCategory),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Quick Conversions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Conversions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildQuickConversion('1 meter', 'Length', 'm', 'ft'),
                    _buildQuickConversion('1 kilogram', 'Mass', 'kg', 'lb'),
                    _buildQuickConversion('1 liter', 'Volume', 'l', 'gal'),
                    _buildQuickConversion('0°C', 'Temperature', 'c', 'f'),
                    _buildQuickConversion('1 km/h', 'Speed', 'km/h', 'mph'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickConversion(String label, String category, String fromUnit, String toUnit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = category;
            _fromUnit = fromUnit;
            _toUnit = toUnit;
            _valueController.text = '1';
            _result = '';
          });
          _convert();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}