import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/calculator_logic.dart';
import '../core/scientific_calculator_logic.dart';
import '../models/calculation_model.dart';

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(CalculatorState.initial());

  void inputNumber(String number) {
    state = state.copyWith(
      expression: state.expression + number,
      result: '',
      error: '',
    );
  }

  void inputOperator(String operator) {
    if (state.expression.isNotEmpty) {
      state = state.copyWith(
        expression: state.expression + operator,
        result: '',
        error: '',
      );
    }
  }

  void inputFunction(String function) {
    state = state.copyWith(
      expression: state.expression + function + '(',
      result: '',
      error: '',
    );
  }

  void inputConstant(String constant) {
    state = state.copyWith(
      expression: state.expression + constant,
      result: '',
      error: '',
    );
  }

  void clear() {
    state = state.copyWith(
      expression: '',
      result: '',
      error: '',
    );
  }

  void backspace() {
    if (state.expression.isNotEmpty) {
      state = state.copyWith(
        expression: state.expression.substring(0, state.expression.length - 1),
        result: '',
        error: '',
      );
    }
  }

  void calculate() {
    try {
      final result = CalculatorLogic.evaluate(state.expression);
      state = state.copyWith(
        result: result.toString(),
        error: '',
      );
      
      // Add to history
      _addToHistory(state.expression, result.toString());
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        result: '',
      );
    }
  }

  void calculateScientific() {
    try {
      final result = ScientificCalculatorLogic.evaluate(state.expression);
      state = state.copyWith(
        result: result.toString(),
        error: '',
      );
      
      // Add to history
      _addToHistory(state.expression, result.toString());
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        result: '',
      );
    }
  }

  void setMode(CalculatorMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setAngleMode(AngleMode angleMode) {
    state = state.copyWith(angleMode: angleMode);
  }

  void memoryStore() {
    if (state.result.isNotEmpty) {
      final value = double.tryParse(state.result);
      if (value != null) {
        state = state.copyWith(memory: value);
      }
    }
  }

  void memoryRecall() {
    if (state.memory != null) {
      state = state.copyWith(
        expression: state.memory.toString(),
        result: '',
        error: '',
      );
    }
  }

  void memoryClear() {
    state = state.copyWith(memory: null);
  }

  void memoryAdd() {
    if (state.result.isNotEmpty && state.memory != null) {
      final result = double.tryParse(state.result);
      if (result != null) {
        state = state.copyWith(memory: state.memory! + result);
      }
    }
  }

  void memorySubtract() {
    if (state.result.isNotEmpty && state.memory != null) {
      final result = double.tryParse(state.result);
      if (result != null) {
        state = state.copyWith(memory: state.memory! - result);
      }
    }
  }

  void _addToHistory(String expression, String result) {
    final calculation = CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
      type: state.mode == CalculatorMode.basic ? CalculationType.basic : CalculationType.scientific,
    );
    
    state = state.copyWith(
      history: [calculation, ...state.history],
    );
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }

  void deleteFromHistory(String id) {
    state = state.copyWith(
      history: state.history.where((calc) => calc.id != id).toList(),
    );
  }
}

class CalculatorState {
  final String expression;
  final String result;
  final String error;
  final CalculatorMode mode;
  final AngleMode angleMode;
  final double? memory;
  final List<CalculationHistory> history;

  const CalculatorState({
    required this.expression,
    required this.result,
    required this.error,
    required this.mode,
    required this.angleMode,
    this.memory,
    required this.history,
  });

  factory CalculatorState.initial() {
    return const CalculatorState(
      expression: '',
      result: '',
      error: '',
      mode: CalculatorMode.basic,
      angleMode: AngleMode.degrees,
      memory: null,
      history: [],
    );
  }

  CalculatorState copyWith({
    String? expression,
    String? result,
    String? error,
    CalculatorMode? mode,
    AngleMode? angleMode,
    double? memory,
    List<CalculationHistory>? history,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      error: error ?? this.error,
      mode: mode ?? this.mode,
      angleMode: angleMode ?? this.angleMode,
      memory: memory ?? this.memory,
      history: history ?? this.history,
    );
  }
}

enum CalculatorMode {
  basic,
  scientific,
}

enum AngleMode {
  degrees,
  radians,
}

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});
