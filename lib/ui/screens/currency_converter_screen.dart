import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/currency_converter.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends ConsumerState<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  String _result = '';
  bool _isTTSEnabled = false;
  DateTime _lastUpdated = DateTime.now();

  final List<String> _currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'INR', 'CNY', 'CHF', 'SEK',
    'NOK', 'DKK', 'PLN', 'CZK', 'HUF', 'RUB', 'BRL', 'MXN', 'KRW', 'SGD',
    'HKD', 'NZD', 'TRY', 'ZAR', 'AED', 'SAR', 'QAR', 'KWD', 'BHD', 'OMR'
  ];

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    try {
      final amount = double.tryParse(_amountController.text) ?? 0;
      
      if (amount <= 0) {
        _showError('Please enter a valid amount');
        return;
      }

      final convertedAmount = CurrencyConverter.convert(amount, _fromCurrency, _toCurrency);
      final rate = convertedAmount / amount;
      
      setState(() {
        _result = '${amount.toStringAsFixed(2)} $_fromCurrency = ${convertedAmount.toStringAsFixed(2)} $_toCurrency\n'
                 'Exchange Rate: 1 $_fromCurrency = ${rate.toStringAsFixed(4)} $_toCurrency\n'
                 'Last Updated: ${_lastUpdated.toString().split(' ')[0]}';
      });

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        TTSService.speakCurrencyResult(_fromCurrency, _toCurrency, amount.toString(), convertedAmount.toString());
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
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
        title: const Text('Currency Converter'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareCurrencyResult(_result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Enter amount to convert',
                        border: OutlineInputBorder(),
                        prefixText: '₹ ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Currency Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currencies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _fromCurrency,
                            isExpanded: true,
                            items: _currencies.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _fromCurrency = value!;
                                _result = '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _swapCurrencies,
                          icon: const Icon(Icons.swap_horiz),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _toCurrency,
                            isExpanded: true,
                            items: _currencies.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _toCurrency = value!;
                                _result = '';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Convert Button
            ElevatedButton.icon(
              onPressed: _convert,
              icon: const Icon(Icons.currency_exchange),
              label: const Text('Convert'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    final amount = double.tryParse(_amountController.text) ?? 0;
                                    final convertedAmount = CurrencyConverter.convert(amount, _fromCurrency, _toCurrency);
                                    await TTSService.speakCurrencyResult(_fromCurrency, _toCurrency, amount.toString(), convertedAmount.toString());
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _result,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Popular Conversions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Conversions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPopularConversion('USD to EUR', 'USD', 'EUR'),
                    _buildPopularConversion('GBP to USD', 'GBP', 'USD'),
                    _buildPopularConversion('INR to USD', 'INR', 'USD'),
                    _buildPopularConversion('EUR to GBP', 'EUR', 'GBP'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Exchange Rate Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exchange Rate Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Rates are updated daily\n'
                      '• Rates are for reference only\n'
                      '• Actual rates may vary\n'
                      '• Check with your bank for current rates',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularConversion(String title, String from, String to) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _fromCurrency = from;
            _toCurrency = to;
            _result = '';
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
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