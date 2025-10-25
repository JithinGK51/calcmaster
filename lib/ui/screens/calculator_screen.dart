import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/calculator_logic.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';
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
  bool _isScientificMode = false;
  bool _isDegreeMode = true;
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

  void _onButtonPressed(String value) {
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
      case 'DEG':
      case 'RAD':
        setState(() {
          _isDegreeMode = !_isDegreeMode;
        });
        break;
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
              
              // Mode Toggle
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Scientific Mode Toggle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isScientificMode = !_isScientificMode;
                          });
                        },
                        icon: Icon(
                          _isScientificMode ? Icons.calculate : Icons.functions,
                          size: 18,
                        ),
                        label: Text(_isScientificMode ? 'Scientific' : 'Basic'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isScientificMode
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          foregroundColor: _isScientificMode
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          elevation: _isScientificMode ? 4 : 1,
                        ),
                      ),
                    ),
                    
                    // Degree/Radian Toggle
                    if (_isScientificMode)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isDegreeMode = !_isDegreeMode;
                            });
                          },
                          icon: Icon(
                            _isDegreeMode ? Icons.straighten : Icons.radar,
                            size: 18,
                          ),
                          label: Text(_isDegreeMode ? 'DEG' : 'RAD'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDegreeMode
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.surface,
                            foregroundColor: _isDegreeMode
                                ? theme.colorScheme.onSecondary
                                : theme.colorScheme.onSurface,
                            elevation: _isDegreeMode ? 4 : 1,
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

    final scientificButtons = [
      ['sin', 'cos', 'tan', 'log'],
      ['ln', '√', '∛', 'x²'],
      ['x³', 'x!', '1/x', 'π'],
      ['e', '(', ')', '%'],
    ];

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
        
        // Scientific buttons (if in scientific mode)
        if (_isScientificMode) ...[
          Expanded(
            child: Column(
              children: scientificButtons.map((row) {
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
          const SizedBox(height: 8),
        ],
        
        // Basic buttons (always visible)
        Expanded(
          flex: _isScientificMode ? 2 : 3,
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
