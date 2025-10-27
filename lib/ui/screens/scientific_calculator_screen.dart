import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/scientific_calculator_logic.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';
import '../../services/history_service.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_screen.dart';

class ScientificCalculatorScreen extends ConsumerStatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  ConsumerState<ScientificCalculatorScreen> createState() => _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState extends ConsumerState<ScientificCalculatorScreen>
    with TickerProviderStateMixin {
  late ScientificCalculatorLogic _calculator;
  late AnimationController _buttonController;
  bool _isDegreeMode = true;
  bool _isTTSEnabled = false;
  String _currentExpression = '';
  String _currentResult = '0';

  @override
  void initState() {
    super.initState();
    _calculator = ScientificCalculatorLogic();
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
        setState(() {
          _currentExpression = '';
          _currentResult = '0';
        });
        break;
      case 'CE':
        setState(() {
          _currentExpression = '';
          _currentResult = '0';
        });
        break;
      case '⌫':
        setState(() {
          if (_currentExpression.isNotEmpty) {
            _currentExpression = _currentExpression.substring(0, _currentExpression.length - 1);
          }
        });
        break;
      case '=':
        try {
          final result = ScientificCalculatorLogic.evaluate(_currentExpression);
          setState(() {
            _currentResult = result.toString();
          });
          
          // Save to history if calculation was successful
          if (_currentExpression.isNotEmpty) {
            await HistoryService.saveScientificCalculation(_currentExpression, _currentResult);
          }
          
          if (_isTTSEnabled) {
            TTSService.speakCalculation(_currentExpression, _currentResult);
          }
        } catch (e) {
          setState(() {
            _currentResult = 'Error';
          });
        }
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'asin':
      case 'acos':
      case 'atan':
      case 'sinh':
      case 'cosh':
      case 'tanh':
      case 'asinh':
      case 'acosh':
      case 'atanh':
      case 'log':
      case 'ln':
      case 'log2':
      case 'exp':
      case 'exp10':
      case 'exp2':
        setState(() {
          _currentExpression += '$value(';
        });
        break;
      case '√':
        setState(() {
          _currentExpression += 'sqrt(';
        });
        break;
      case '∛':
        setState(() {
          _currentExpression += 'cbrt(';
        });
        break;
      case 'x²':
        setState(() {
          _currentExpression += '^2';
        });
        break;
      case 'x³':
        setState(() {
          _currentExpression += '^3';
        });
        break;
      case 'xʸ':
        setState(() {
          _currentExpression += '^';
        });
        break;
      case 'x!':
        setState(() {
          _currentExpression += '!';
        });
        break;
      case '1/x':
        setState(() {
          _currentExpression = '1/($_currentExpression)';
        });
        break;
      case 'π':
        setState(() {
          _currentExpression += 'pi';
        });
        break;
      case 'e':
        setState(() {
          _currentExpression += 'e';
        });
        break;
      case 'nPr':
        setState(() {
          _currentExpression += 'P';
        });
        break;
      case 'nCr':
        setState(() {
          _currentExpression += 'C';
        });
        break;
      case 'mod':
        setState(() {
          _currentExpression += '%';
        });
        break;
      case 'gcd':
      case 'lcm':
        setState(() {
          _currentExpression += '$value(';
        });
        break;
      case '±':
        setState(() {
          if (_currentExpression.isNotEmpty) {
            _currentExpression = '(-$_currentExpression)';
          }
        });
        break;
      default:
        setState(() {
          _currentExpression += value;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          // Degree/Radian Toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isDegreeMode = !_isDegreeMode;
              });
            },
            icon: Icon(_isDegreeMode ? Icons.straighten : Icons.radar),
            tooltip: _isDegreeMode ? 'Switch to Radians' : 'Switch to Degrees',
          ),
          
          // TTS Toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isTTSEnabled = !_isTTSEnabled;
              });
            },
            icon: Icon(_isTTSEnabled ? Icons.volume_up : Icons.volume_off),
            tooltip: _isTTSEnabled ? 'Disable Voice' : 'Enable Voice',
          ),
          
          // Share Button
          IconButton(
            onPressed: () {
              SharingService.shareText('Calculation: $_currentExpression = $_currentResult');
            },
            icon: const Icon(Icons.share),
            tooltip: 'Share Result',
          ),
        ],
      ),
      body: isLandscape ? _buildLandscapeLayout(theme) : _buildPortraitLayout(theme),
    );
  }

  Widget _buildPortraitLayout(ThemeData theme) {
    return Column(
      children: [
        // Display
        Expanded(
          flex: 2,
          child: DisplayScreen(
            expression: _currentExpression,
            result: _currentResult,
            isError: _currentResult == 'Error',
            memory: 0.0,
          ),
        ),
        
        // Mode indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isDegreeMode ? 'DEG' : 'RAD',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Scientific Mode',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Button Grid
        Expanded(
          flex: 4,
          child: _buildPortraitButtonGrid(theme),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(ThemeData theme) {
    return Row(
      children: [
        // Left side - Display and basic operations
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Display
              Expanded(
                flex: 2,
                child: DisplayScreen(
                  expression: _currentExpression,
                  result: _currentResult,
                  isError: _currentResult == 'Error',
                  memory: 0.0,
                ),
              ),
              
              // Mode indicator
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _isDegreeMode ? 'DEG' : 'RAD',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Scientific Mode',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Basic operations
              Expanded(
                flex: 3,
                child: _buildBasicOperationsGrid(theme),
              ),
            ],
          ),
        ),
        
        // Right side - Scientific functions
        Expanded(
          flex: 2,
          child: _buildScientificFunctionsGrid(theme),
        ),
      ],
    );
  }

  Widget _buildPortraitButtonGrid(ThemeData theme) {
    final basicButtons = [
      ['C', 'CE', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
    ];

    final scientificButtons = [
      ['sin', 'cos', 'tan', 'log'],
      ['asin', 'acos', 'atan', 'ln'],
      ['sinh', 'cosh', 'tanh', 'log2'],
      ['asinh', 'acosh', 'atanh', 'exp'],
      ['√', '∛', 'x²', 'x³'],
      ['xʸ', 'x!', '1/x', 'exp10'],
      ['π', 'e', 'nPr', 'nCr'],
      ['mod', 'gcd', 'lcm', 'exp2'],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Scientific buttons
          Expanded(
            flex: 2,
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
          
          // Basic buttons
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
      ),
    );
  }

  Widget _buildBasicOperationsGrid(ThemeData theme) {
    final basicButtons = [
      ['C', 'CE', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildScientificFunctionsGrid(ThemeData theme) {
    final scientificButtons = [
      ['sin', 'cos', 'tan', 'log'],
      ['asin', 'acos', 'atan', 'ln'],
      ['sinh', 'cosh', 'tanh', 'log2'],
      ['asinh', 'acosh', 'atanh', 'exp'],
      ['√', '∛', 'x²', 'x³'],
      ['xʸ', 'x!', '1/x', 'exp10'],
      ['π', 'e', 'nPr', 'nCr'],
      ['mod', 'gcd', 'lcm', 'exp2'],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Scientific Functions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }

  CalculatorButtonType _getButtonType(String button) {
    if (['+', '-', '×', '÷', '='].contains(button)) {
      return CalculatorButtonType.operator;
    } else if (['C', 'CE', '⌫'].contains(button)) {
      return CalculatorButtonType.function;
    } else if (['sin', 'cos', 'tan', 'asin', 'acos', 'atan', 'sinh', 'cosh', 'tanh', 'asinh', 'acosh', 'atanh', 
                 'log', 'ln', 'log2', 'exp', 'exp10', 'exp2', '√', '∛', 'x²', 'x³', 'xʸ', 'x!', '1/x', 
                 'π', 'e', 'nPr', 'nCr', 'mod', 'gcd', 'lcm'].contains(button)) {
      return CalculatorButtonType.scientific;
    } else if (['(', ')', '%', '±'].contains(button)) {
      return CalculatorButtonType.function;
    } else {
      return CalculatorButtonType.number;
    }
  }
}
