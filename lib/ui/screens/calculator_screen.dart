import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/calculator_logic.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';
import '../../services/history_service.dart';
import '../../providers/performance_provider.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_screen.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen>
    with TickerProviderStateMixin {
  late CalculatorLogic _calculator;
  late AnimationController _buttonController;
  // Removed scientific mode - this is now basic calculator only
  bool _isTTSEnabled = false;

  @override
  void initState() {
    super.initState();
    _calculator = CalculatorLogic();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
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
    _buttonController.dispose();
    super.dispose();
  }

  void _onButtonPressed(String value) async {
    HapticFeedback.lightImpact();
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    switch (value) {
      case 'C':
        _calculator.clear();
        break;
      case 'CE':
        _calculator.clearEntry();
        break;
      case '⌫':
        _calculator.backspace();
        break;
      case '=':
        // Monitor calculation performance
        ref.read(performanceProvider.notifier).measure('calculator_calculation', () {
          _calculator.calculate();
        });
        
        // Cache calculation result
        if (!_calculator.isError) {
          final expression = _calculator.currentExpression.isEmpty ? '0' : _calculator.currentExpression;
          ref.read(performanceProvider.notifier).registerObject('calculations', expression, _calculator.currentResult);
        }
        
        // Save to history if calculation was successful
        if (!_calculator.isError) {
          final expression = _calculator.currentExpression.isEmpty ? '0' : _calculator.currentExpression;
          await HistoryService.saveBasicCalculation(expression, _calculator.currentResult);
        }
        
        // Speak result if TTS is enabled
        if (_isTTSEnabled && !_calculator.isError) {
          TTSService.speakCalculation(
            _calculator.currentExpression.isEmpty ? '0' : _calculator.currentExpression,
            _calculator.currentResult,
          );
        }
        break;
      case 'M+':
        _calculator.memoryAdd();
        break;
      case 'M-':
        _calculator.memorySubtract();
        break;
      case 'MR':
        _calculator.memoryRecall();
        break;
      case 'MC':
        _calculator.memoryClear();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'log':
      case 'ln':
      case '√':
      case '∛':
        _calculator.inputFunction(value);
        break;
      case 'π':
      case 'e':
        _calculator.inputConstant(value);
        break;
      case 'x²':
        _calculator.inputFunction('pow');
        break;
      case 'x³':
        _calculator.inputFunction('cube');
        break;
      case 'x!':
        _calculator.inputFunction('factorial');
        break;
      case '1/x':
        _calculator.inputFunction('reciprocal');
        break;
      case '±':
        _calculator.inputFunction('negate');
        break;
      // DEG/RAD toggle removed - this is basic calculator only
      default:
        if (RegExp(r'[0-9]').hasMatch(value)) {
          _calculator.inputNumber(value);
        } else if (RegExp(r'[+\-×÷%]').hasMatch(value)) {
          _calculator.inputOperator(value);
        } else if (value == '.') {
          _calculator.inputDecimal();
        } else if (value == '(' || value == ')') {
          _calculator.inputParentheses(value);
        }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.background,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Display Screen
              Expanded(
                flex: 2,
                child: DisplayScreen(
                  expression: _calculator.currentExpression,
                  result: _calculator.currentResult,
                  isError: _calculator.isError,
                  memory: _calculator.memory,
                ),
              ),
              
              // Mode Indicator (Basic Calculator)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Basic Calculator',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Button Grid
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: _buildButtonGrid(theme),
                ),
              ),
              
              // Floating Action Buttons
              _buildFloatingActionButtons(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonGrid(ThemeData theme) {
    final basicButtons = [
      ['C', 'CE', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
    ];

    // Scientific buttons removed - this is basic calculator only

    final memoryButtons = [
      ['M+', 'M-', 'MR', 'MC'],
    ];

    return Column(
      children: [
        // Memory buttons (always visible)
        Expanded(
          child: Row(
            children: memoryButtons[0].map((button) {
              return Expanded(
                child: CalculatorButton(
                  text: button,
                  onPressed: () => _onButtonPressed(button),
                  buttonType: _getButtonType(button),
                  theme: theme,
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Basic buttons (always visible)
        Expanded(
          flex: 3,
          child: Column(
            children: basicButtons.map((row) {
              return Expanded(
                child: Row(
                  children: row.map((button) {
                    return Expanded(
                      child: CalculatorButton(
                        text: button,
                        onPressed: () => _onButtonPressed(button),
                        buttonType: _getButtonType(button),
                        theme: theme,
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  CalculatorButtonType _getButtonType(String button) {
    if (RegExp(r'[0-9]').hasMatch(button)) {
      return CalculatorButtonType.number;
    } else if (RegExp(r'[+\-×÷=]').hasMatch(button)) {
      return CalculatorButtonType.operator;
    } else if (button == 'C' || button == 'CE' || button == '⌫') {
      return CalculatorButtonType.function;
    } else if (RegExp(r'[M+\-R]').hasMatch(button)) {
      return CalculatorButtonType.memory;
    } else {
      return CalculatorButtonType.scientific;
    }
  }

  Widget _buildFloatingActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TTS button
          if (_isTTSEnabled)
            FloatingActionButton.small(
              heroTag: "tts",
              onPressed: () async {
                if (!_calculator.isError && _calculator.currentResult != '0') {
                  await TTSService.speakCalculation(
                    _calculator.currentExpression.isEmpty ? '0' : _calculator.currentExpression,
                    _calculator.currentResult,
                  );
                }
              },
              child: const Icon(Icons.volume_up),
            ),
          
          // Share button
          FloatingActionButton.small(
            heroTag: "share",
            onPressed: () async {
              if (!_calculator.isError && _calculator.currentResult != '0') {
                await SharingService.shareCalculation(
                  _calculator.currentExpression.isEmpty ? '0' : _calculator.currentExpression,
                  _calculator.currentResult,
                );
              }
            },
            child: const Icon(Icons.share),
          ),
          
          // Copy button
          FloatingActionButton.small(
            heroTag: "copy",
            onPressed: () {
              if (!_calculator.isError && _calculator.currentResult != '0') {
                Clipboard.setData(ClipboardData(text: _calculator.currentResult));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Result copied to clipboard')),
                );
              }
            },
            child: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }
}
