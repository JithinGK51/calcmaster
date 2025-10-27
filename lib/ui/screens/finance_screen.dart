import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/finance_logic.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';
import '../../services/history_service.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  String _selectedCalculator = 'EMI Calculator';
  final Map<String, TextEditingController> _controllers = {};
  String _result = '';
  bool _isTTSEnabled = false;

  final List<String> _calculators = [
    'EMI Calculator',
    'Simple Interest',
    'Compound Interest',
    'SIP Calculator',
    'Lump Sum Investment',
    'Loan Eligibility',
    'Fixed Deposit',
    'Recurring Deposit',
    'PPF Calculator',
    'Inflation Calculator',
    'Future Value',
    'Present Value',
    'Annuity Calculator',
    'Income Tax Calculator',
    'GST Calculator',
    'Break-even Analysis',
    'ROI Calculator',
    'CAGR Calculator',
  ];

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _initializeControllers();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  void _initializeControllers() {
    final fields = [
      'principal', 'rate', 'time', 'tenure', 'monthlyInvestment', 'years',
      'monthlyIncome', 'monthlyExpenses', 'annualIncome', 'gstRate', 'amount',
      'fixedCosts', 'variableCostPerUnit', 'sellingPricePerUnit', 'initialInvestment',
      'finalValue', 'initialValue', 'finalValue', 'presentValue', 'futureValue',
      'annuityPayment', 'compoundingFrequency', 'paymentFrequency', 'taxRegime',
      'oldValue', 'newValue', 'cashFlows', 'discountRate'
    ];
    
    for (final field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCalculatorChanged(String calculator) {
    setState(() {
      _selectedCalculator = calculator;
      _result = '';
    });
  }

  void _calculate() async {
    try {
      String result = '';
      
      switch (_selectedCalculator) {
        case 'EMI Calculator':
          final principal = double.tryParse(_controllers['principal']!.text) ?? 0;
          final rate = double.tryParse(_controllers['rate']!.text) ?? 0;
          final tenure = int.tryParse(_controllers['tenure']!.text) ?? 0;
          
          if (principal <= 0 || rate < 0 || tenure <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final emi = FinanceLogic.calculateEMI(principal, rate, tenure);
          final totalAmount = FinanceLogic.calculateTotalAmount(emi, tenure);
          final totalInterest = FinanceLogic.calculateTotalInterest(principal, emi, tenure);
          
          result = 'EMI: ₹${emi.toStringAsFixed(2)}\n';
          result += 'Total Amount: ₹${totalAmount.toStringAsFixed(2)}\n';
          result += 'Total Interest: ₹${totalInterest.toStringAsFixed(2)}';
          break;
          
        case 'Simple Interest':
          final principal = double.tryParse(_controllers['principal']!.text) ?? 0;
          final rate = double.tryParse(_controllers['rate']!.text) ?? 0;
          final time = double.tryParse(_controllers['time']!.text) ?? 0;
          
          if (principal <= 0 || rate < 0 || time < 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final interest = FinanceLogic.calculateSimpleInterest(principal, rate, time);
          final amount = principal + interest;
          
          result = 'Simple Interest: ₹${interest.toStringAsFixed(2)}\n';
          result += 'Total Amount: ₹${amount.toStringAsFixed(2)}';
          break;
          
        case 'Compound Interest':
          final principal = double.tryParse(_controllers['principal']!.text) ?? 0;
          final rate = double.tryParse(_controllers['rate']!.text) ?? 0;
          final time = double.tryParse(_controllers['time']!.text) ?? 0;
          final frequency = int.tryParse(_controllers['compoundingFrequency']!.text) ?? 1;
          
          if (principal <= 0 || rate < 0 || time < 0 || frequency <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final interest = FinanceLogic.calculateCompoundInterest(principal, rate, time, frequency);
          final amount = FinanceLogic.calculateCompoundAmount(principal, rate, time, frequency);
          
          result = 'Compound Interest: ₹${interest.toStringAsFixed(2)}\n';
          result += 'Total Amount: ₹${amount.toStringAsFixed(2)}';
          break;
          
        case 'SIP Calculator':
          final monthlyInvestment = double.tryParse(_controllers['monthlyInvestment']!.text) ?? 0;
          final rate = double.tryParse(_controllers['rate']!.text) ?? 0;
          final years = int.tryParse(_controllers['years']!.text) ?? 0;
          
          if (monthlyInvestment <= 0 || rate < 0 || years <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final maturityValue = FinanceLogic.calculateSIPMaturity(monthlyInvestment, rate, years);
          final totalInvestment = FinanceLogic.calculateSIPTotalInvestment(monthlyInvestment, years);
          final returns = FinanceLogic.calculateSIPReturns(monthlyInvestment, rate, years);
          
          result = 'Maturity Value: ₹${maturityValue.toStringAsFixed(2)}\n';
          result += 'Total Investment: ₹${totalInvestment.toStringAsFixed(2)}\n';
          result += 'Returns: ₹${returns.toStringAsFixed(2)}';
          break;
          
        case 'Lump Sum Investment':
          final principal = double.tryParse(_controllers['principal']!.text) ?? 0;
          final rate = double.tryParse(_controllers['rate']!.text) ?? 0;
          final years = int.tryParse(_controllers['years']!.text) ?? 0;
          
          if (principal <= 0 || rate < 0 || years <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final maturityValue = FinanceLogic.calculateLumpSumMaturity(principal, rate, years);
          final returns = maturityValue - principal;
          
          result = 'Maturity Value: ₹${maturityValue.toStringAsFixed(2)}\n';
          result += 'Returns: ₹${returns.toStringAsFixed(2)}';
          break;
          
        case 'Loan Eligibility':
          final monthlyIncome = double.tryParse(_controllers['monthlyIncome']!.text) ?? 0;
          final monthlyExpenses = double.tryParse(_controllers['monthlyExpenses']!.text) ?? 0;
          final rate = double.tryParse(_controllers['rate']!.text) ?? 0;
          final tenureYears = int.tryParse(_controllers['tenure']!.text) ?? 0;
          
          if (monthlyIncome <= 0 || monthlyExpenses < 0 || rate < 0 || tenureYears <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final maxLoanAmount = FinanceLogic.calculateLoanEligibility(monthlyIncome, monthlyExpenses, rate, tenureYears);
          
          result = 'Maximum Loan Amount: ₹${maxLoanAmount.toStringAsFixed(2)}';
          break;
          
        case 'Income Tax Calculator':
          final annualIncome = double.tryParse(_controllers['annualIncome']!.text) ?? 0;
          final taxRegime = _controllers['taxRegime']!.text.isEmpty ? 'new' : _controllers['taxRegime']!.text;
          
          if (annualIncome < 0) {
            _showError('Please enter valid income');
            return;
          }
          
          final taxResult = FinanceLogic.calculateIncomeTax(annualIncome, taxRegime);
          
          result = 'Tax: ₹${taxResult['tax']!.toStringAsFixed(2)}\n';
          result += 'Effective Rate: ${taxResult['effectiveRate']!.toStringAsFixed(2)}%\n';
          result += 'After Tax Income: ₹${taxResult['afterTaxIncome']!.toStringAsFixed(2)}';
          break;
          
        case 'GST Calculator':
          final amount = double.tryParse(_controllers['amount']!.text) ?? 0;
          final gstRate = double.tryParse(_controllers['gstRate']!.text) ?? 0;
          
          if (amount < 0 || gstRate < 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final gstResult = FinanceLogic.calculateGST(amount, gstRate);
          
          result = 'Base Amount: ₹${gstResult['baseAmount']!.toStringAsFixed(2)}\n';
          result += 'CGST: ₹${gstResult['cgst']!.toStringAsFixed(2)}\n';
          result += 'SGST: ₹${gstResult['sgst']!.toStringAsFixed(2)}\n';
          result += 'Total GST: ₹${gstResult['totalGST']!.toStringAsFixed(2)}\n';
          result += 'Total Amount: ₹${gstResult['totalAmount']!.toStringAsFixed(2)}';
          break;
          
        case 'ROI Calculator':
          final initialInvestment = double.tryParse(_controllers['initialInvestment']!.text) ?? 0;
          final finalValue = double.tryParse(_controllers['finalValue']!.text) ?? 0;
          
          if (initialInvestment <= 0 || finalValue < 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final roi = FinanceLogic.calculateROI(initialInvestment, finalValue);
          
          result = 'ROI: ${roi.toStringAsFixed(2)}%';
          break;
          
        case 'CAGR Calculator':
          final initialValue = double.tryParse(_controllers['initialValue']!.text) ?? 0;
          final finalValue = double.tryParse(_controllers['finalValue']!.text) ?? 0;
          final years = int.tryParse(_controllers['years']!.text) ?? 0;
          
          if (initialValue <= 0 || finalValue <= 0 || years <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final cagr = FinanceLogic.calculateCAGR(initialValue, finalValue, years);
          
          result = 'CAGR: ${cagr.toStringAsFixed(2)}%';
          break;
      }

      setState(() {
        _result = result;
      });

      // Save to history
      await HistoryService.saveFinanceCalculation(
        '$_selectedCalculator: ${_getCalculationExpression()}',
        result,
        category: _selectedCalculator,
      );

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        TTSService.speakFinanceResult(_selectedCalculator, result);
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _getCalculationExpression() {
    final fields = _getRequiredFields(_selectedCalculator);
    final expression = StringBuffer();
    
    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final value = _controllers[field]?.text ?? '';
      expression.write('$field: $value');
      if (i < fields.length - 1) expression.write(', ');
    }
    
    return expression.toString();
  }

  List<String> _getRequiredFields(String calculator) {
    switch (calculator) {
      case 'EMI Calculator':
        return ['principal', 'rate', 'tenure'];
      case 'Simple Interest':
        return ['principal', 'rate', 'time'];
      case 'Compound Interest':
        return ['principal', 'rate', 'time', 'compoundingFrequency'];
      case 'SIP Calculator':
        return ['monthlyInvestment', 'rate', 'years'];
      case 'Lump Sum Investment':
        return ['principal', 'rate', 'years'];
      case 'Loan Eligibility':
        return ['monthlyIncome', 'monthlyExpenses', 'rate', 'tenure'];
      case 'Income Tax Calculator':
        return ['annualIncome', 'taxRegime'];
      case 'GST Calculator':
        return ['amount', 'gstRate'];
      case 'ROI Calculator':
        return ['initialInvestment', 'finalValue'];
      case 'CAGR Calculator':
        return ['initialValue', 'finalValue', 'years'];
      default:
        return [];
    }
  }

  String _getFieldLabel(String field) {
    final labels = {
      'principal': 'Principal Amount (₹)',
      'rate': 'Interest Rate (%)',
      'time': 'Time Period',
      'tenure': 'Tenure (months)',
      'monthlyInvestment': 'Monthly Investment (₹)',
      'years': 'Years',
      'monthlyIncome': 'Monthly Income (₹)',
      'monthlyExpenses': 'Monthly Expenses (₹)',
      'annualIncome': 'Annual Income (₹)',
      'gstRate': 'GST Rate (%)',
      'amount': 'Amount (₹)',
      'compoundingFrequency': 'Compounding Frequency',
      'taxRegime': 'Tax Regime (new/old)',
      'initialInvestment': 'Initial Investment (₹)',
      'finalValue': 'Final Value (₹)',
      'initialValue': 'Initial Value (₹)',
    };
    return labels[field] ?? field;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Calculator'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareFinanceResult(_selectedCalculator, _result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calculator Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Calculator',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedCalculator,
                      isExpanded: true,
                      items: _calculators.map((calculator) {
                        return DropdownMenuItem(
                          value: calculator,
                          child: Text(calculator),
                        );
                      }).toList(),
                      onChanged: (value) => _onCalculatorChanged(value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input Fields
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Values',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._getRequiredFields(_selectedCalculator).map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: _controllers[field],
                          decoration: InputDecoration(
                            labelText: _getFieldLabel(field),
                            border: const OutlineInputBorder(),
                            suffixText: field.contains('Rate') || field.contains('Frequency') ? '' : '₹',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    }).toList(),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate'),
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
                                    await TTSService.speakFinanceResult(_selectedCalculator, _result);
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

            // Quick Examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Examples',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildQuickExample('EMI for ₹10L at 8.5% for 20 years'),
                    _buildQuickExample('SIP of ₹5000 at 12% for 10 years'),
                    _buildQuickExample('Compound Interest on ₹1L at 10% for 5 years'),
                    _buildQuickExample('Income Tax on ₹8L (New Regime)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickExample(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          // Set example values based on description
          if (description.contains('EMI')) {
            setState(() {
              _selectedCalculator = 'EMI Calculator';
              _controllers['principal']!.text = '1000000';
              _controllers['rate']!.text = '8.5';
              _controllers['tenure']!.text = '240';
            });
          } else if (description.contains('SIP')) {
            setState(() {
              _selectedCalculator = 'SIP Calculator';
              _controllers['monthlyInvestment']!.text = '5000';
              _controllers['rate']!.text = '12';
              _controllers['years']!.text = '10';
            });
          } else if (description.contains('Compound Interest')) {
            setState(() {
              _selectedCalculator = 'Compound Interest';
              _controllers['principal']!.text = '100000';
              _controllers['rate']!.text = '10';
              _controllers['time']!.text = '5';
              _controllers['compoundingFrequency']!.text = '1';
            });
          } else if (description.contains('Income Tax')) {
            setState(() {
              _selectedCalculator = 'Income Tax Calculator';
              _controllers['annualIncome']!.text = '800000';
              _controllers['taxRegime']!.text = 'new';
            });
          }
          _result = '';
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
                  description,
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