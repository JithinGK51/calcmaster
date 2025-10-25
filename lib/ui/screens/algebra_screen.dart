import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/advanced_solver_service.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class AlgebraScreen extends ConsumerStatefulWidget {
  const AlgebraScreen({super.key});

  @override
  ConsumerState<AlgebraScreen> createState() => _AlgebraScreenState();
}

class _AlgebraScreenState extends ConsumerState<AlgebraScreen> {
  final TextEditingController _equationController = TextEditingController();
  final TextEditingController _variableController = TextEditingController(text: 'x');
  String _result = '';
  List<String> _solutionSteps = [];
  bool _isLoading = false;
  bool _isTTSEnabled = false;

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
    _equationController.dispose();
    _variableController.dispose();
    super.dispose();
  }

  Future<void> _solveEquation() async {
    if (_equationController.text.isEmpty) {
      _showError('Please enter an equation');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
      _solutionSteps = [];
    });

    try {
      final result = await AdvancedSolverService.solveEquation(
        _equationController.text,
        _variableController.text,
      );

      setState(() {
        _isLoading = false;
        if (result['success']) {
          _result = result['solution'].toString();
          _solutionSteps = List<String>.from(result['steps'] ?? []);
        } else {
          _result = 'Error: ${result['error']}';
        }
      });

      // Speak result if TTS is enabled
      if (_isTTSEnabled && result['success']) {
        await TTSService.speakCalculation(
          _equationController.text,
          _result,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Error: $e';
      });
    }
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
        title: const Text('Algebra Solver'),
        actions: [
          if (_result.isNotEmpty && !_result.startsWith('Error'))
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareCalculation(
                  _equationController.text,
                  _result,
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
            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Equation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _equationController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., 2x + 5 = 13 or x^2 - 4x + 3 = 0',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.functions),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _variableController,
                            decoration: const InputDecoration(
                              labelText: 'Variable',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.abc),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _solveEquation,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.calculate),
                          label: Text(_isLoading ? 'Solving...' : 'Solve'),
                        ),
                      ],
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
                            'Solution',
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
                                    if (!_result.startsWith('Error')) {
                                      await TTSService.speakCalculation(
                                        _equationController.text,
                                        _result,
                                      );
                                    }
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
                          color: _result.startsWith('Error')
                              ? theme.colorScheme.errorContainer
                              : theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _result,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: _result.startsWith('Error')
                                ? theme.colorScheme.onErrorContainer
                                : theme.colorScheme.onPrimaryContainer,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Solution Steps
            if (_solutionSteps.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step-by-Step Solution',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._solutionSteps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  step,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Examples Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example Equations',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildExampleButton('2x + 5 = 13', 'Linear equation'),
                    _buildExampleButton('x^2 - 4x + 3 = 0', 'Quadratic equation'),
                    _buildExampleButton('3x - 7 = 2x + 1', 'Linear with variables on both sides'),
                    _buildExampleButton('x^2 + 6x + 9 = 0', 'Perfect square quadratic'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleButton(String equation, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          _equationController.text = equation;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      equation,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
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