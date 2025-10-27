import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/health_logic.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';
import '../../services/history_service.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  String _selectedCalculator = 'BMI Calculator';
  final Map<String, TextEditingController> _controllers = {};
  String _result = '';
  bool _isTTSEnabled = false;
  bool _isMale = true;
  String _activityLevel = 'sedentary';
  double _activityLevelValue = 1.2;

  final List<String> _calculators = [
    'BMI Calculator',
    'BMR Calculator',
    'Daily Calorie Needs',
    'Ideal Body Weight',
    'Body Fat Percentage',
    'Water Intake Calculator',
    'Pregnancy Weight Gain',
    'Child Growth Calculator',
    'Heart Rate Zones',
    'Blood Pressure Check',
    'Diabetes Risk Assessment',
    'Cholesterol Calculator',
    'Waist-to-Hip Ratio',
    'Metabolic Age',
    'Protein Calculator',
    'Macro Calculator',
    'Exercise Calorie Burn',
    'Sleep Calculator',
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
      'weight', 'height', 'age', 'waist', 'hip', 'neck', 'bodyFat',
      'activityLevel', 'pregnancyWeek', 'childAge', 'childHeight', 'childWeight',
      'restingHeartRate', 'maxHeartRate', 'systolic', 'diastolic',
      'familyHistory', 'exercise', 'smoking', 'cholesterol', 'hdl', 'ldl',
      'triglycerides', 'proteinGoal', 'carbsGoal', 'fatsGoal', 'calories',
      'exerciseType', 'duration', 'intensity', 'sleepHours', 'bedtime',
      'wakeTime', 'sleepQuality', 'stressLevel', 'caffeine', 'alcohol'
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
        case 'BMI Calculator':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final height = double.tryParse(_controllers['height']!.text) ?? 0;
          
          if (weight <= 0 || height <= 0) {
            _showError('Please enter valid weight and height');
            return;
          }
          
          final bmi = HealthLogic.calculateBMI(weight, height);
          final category = HealthLogic.getBMICategory(bmi);
          final idealWeight = HealthLogic.calculateIdealWeight(height, _isMale ? 'male' : 'female', 'cm');
          
          result = 'BMI: ${bmi.toStringAsFixed(1)}\n';
          result += 'Category: $category\n';
          result += 'Ideal Weight: ${idealWeight['min']?.toStringAsFixed(1) ?? 'N/A'} - ${idealWeight['max']?.toStringAsFixed(1) ?? 'N/A'} kg';
          break;
          
        case 'BMR Calculator':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final height = double.tryParse(_controllers['height']!.text) ?? 0;
          final age = int.tryParse(_controllers['age']!.text) ?? 0;
          
          if (weight <= 0 || height <= 0 || age <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final bmr = HealthLogic.calculateBMR(weight, height, age, _isMale ? 'male' : 'female');
          final tdee = HealthLogic.calculateTDEE(bmr, _activityLevel);
          final dailyCalories = HealthLogic.calculateCalorieNeeds(tdee, _activityLevel);
          
          result = 'BMR: ${bmr.toStringAsFixed(0)} calories/day\n';
          result += 'Daily Calorie Needs: ${dailyCalories['calories']?.toStringAsFixed(0) ?? 'N/A'} calories/day';
          break;
          
        case 'Daily Calorie Needs':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final height = double.tryParse(_controllers['height']!.text) ?? 0;
          final age = int.tryParse(_controllers['age']!.text) ?? 0;
          
          if (weight <= 0 || height <= 0 || age <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final bmr = HealthLogic.calculateBMR(weight, height, age, _isMale ? 'male' : 'female');
          final tdee = HealthLogic.calculateTDEE(bmr, _activityLevel);
          final dailyCalories = HealthLogic.calculateCalorieNeeds(tdee, _activityLevel);
          
          result = 'Daily Calorie Needs: ${dailyCalories['calories']?.toStringAsFixed(0) ?? 'N/A'} calories/day\n';
          result += 'Activity Level: ${_getActivityLevelText(_activityLevel)}';
          break;
          
        case 'Ideal Body Weight':
          final height = double.tryParse(_controllers['height']!.text) ?? 0;
          
          if (height <= 0) {
            _showError('Please enter valid height');
            return;
          }
          
          final idealWeight = HealthLogic.calculateIdealWeight(height, _isMale ? 'male' : 'female', 'cm');
          final weightRange = HealthLogic.calculateIdealWeight(height, _isMale ? 'male' : 'female', 'cm');
          
          result = 'Ideal Weight: ${idealWeight['min']?.toStringAsFixed(1) ?? 'N/A'} - ${idealWeight['max']?.toStringAsFixed(1) ?? 'N/A'} kg\n';
          result += 'Healthy Range: ${weightRange['min']?.toStringAsFixed(1) ?? 'N/A'} - ${weightRange['max']?.toStringAsFixed(1) ?? 'N/A'} kg';
          break;
          
        case 'Body Fat Percentage':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final height = double.tryParse(_controllers['height']!.text) ?? 0;
          final age = int.tryParse(_controllers['age']!.text) ?? 0;
          final waist = double.tryParse(_controllers['waist']!.text) ?? 0;
          final neck = double.tryParse(_controllers['neck']!.text) ?? 0;
          final hip = double.tryParse(_controllers['hip']!.text) ?? 0;
          
          if (weight <= 0 || height <= 0 || age <= 0 || waist <= 0 || neck <= 0) {
            _showError('Please enter valid measurements');
            return;
          }
          
          final bodyFat = HealthLogic.calculateBodyFatPercentage(weight, height, age, _isMale ? 'male' : 'female', waist, neck, hip: hip);
          final category = HealthLogic.getBodyFatCategory(bodyFat, _isMale ? 'male' : 'female');
          
          result = 'Body Fat: ${bodyFat.toStringAsFixed(1)}%\n';
          result += 'Category: $category';
          break;
          
        case 'Water Intake Calculator':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final age = int.tryParse(_controllers['age']!.text) ?? 0;
          final activityLevel = double.tryParse(_controllers['activityLevel']!.text) ?? 1.0;
          
          if (weight <= 0 || age <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final waterIntake = HealthLogic.calculateWaterIntake(weight, 'kg', _activityLevel, 'moderate');
          
          result = 'Daily Water Intake: ${waterIntake.toStringAsFixed(1)} liters\n';
          result += 'Glasses (250ml): ${(waterIntake * 4).toStringAsFixed(0)} glasses';
          break;
          
        case 'Heart Rate Zones':
          final age = int.tryParse(_controllers['age']!.text) ?? 0;
          final restingHeartRate = int.tryParse(_controllers['restingHeartRate']!.text) ?? 0;
          
          if (age <= 0 || restingHeartRate <= 0) {
            _showError('Please enter valid age and resting heart rate');
            return;
          }
          
          final heartRateZones = HealthLogic.calculateHeartRateZones(age, restingHeartRate);
          
          result = 'Heart Rate Zones:\n';
          result += 'Fat Burn: ${heartRateZones['fatBurnMin']}-${heartRateZones['fatBurnMax']} bpm\n';
          result += 'Cardio: ${heartRateZones['cardioMin']}-${heartRateZones['cardioMax']} bpm\n';
          result += 'Peak: ${heartRateZones['peakMin']}-${heartRateZones['peakMax']} bpm';
          break;
          
        case 'Blood Pressure Check':
          final systolic = int.tryParse(_controllers['systolic']!.text) ?? 0;
          final diastolic = int.tryParse(_controllers['diastolic']!.text) ?? 0;
          
          if (systolic <= 0 || diastolic <= 0) {
            _showError('Please enter valid blood pressure readings');
            return;
          }
          
          final bpCategory = _getBloodPressureCategory(systolic.toDouble(), diastolic.toDouble());
          final recommendations = _getBloodPressureRecommendations(bpCategory);
          
          result = 'Blood Pressure: $systolic/$diastolic mmHg\n';
          result += 'Category: $bpCategory\n';
          result += 'Recommendations: $recommendations';
          break;
          
        case 'Protein Calculator':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final activityLevel = double.tryParse(_controllers['activityLevel']!.text) ?? 1.0;
          
          if (weight <= 0) {
            _showError('Please enter valid weight');
            return;
          }
          
          final proteinNeeds = HealthLogic.calculateProteinNeeds(weight, 'kg', _activityLevel, 'maintain');
          
          result = 'Daily Protein Needs: ${proteinNeeds.toStringAsFixed(1)} grams\n';
          result += 'Per Meal (3 meals): ${(proteinNeeds / 3).toStringAsFixed(1)} grams';
          break;
          
        case 'Macro Calculator':
          final weight = double.tryParse(_controllers['weight']!.text) ?? 0;
          final height = double.tryParse(_controllers['height']!.text) ?? 0;
          final age = int.tryParse(_controllers['age']!.text) ?? 0;
          final goal = _controllers['goal']?.text ?? 'maintain';
          
          if (weight <= 0 || height <= 0 || age <= 0) {
            _showError('Please enter valid values');
            return;
          }
          
          final bmr = HealthLogic.calculateBMR(weight, height, age, _isMale ? 'male' : 'female');
          final tdee = HealthLogic.calculateTDEE(bmr, _activityLevel);
          final macros = _calculateMacros(tdee, goal);
          
          result = 'Daily Macros:\n';
          result += 'Calories: ${macros['calories']!.toStringAsFixed(0)}\n';
          result += 'Protein: ${macros['protein']!.toStringAsFixed(1)}g\n';
          result += 'Carbs: ${macros['carbs']!.toStringAsFixed(1)}g\n';
          result += 'Fats: ${macros['fats']!.toStringAsFixed(1)}g';
          break;
      }

      setState(() {
        _result = result;
      });

      // Save to history
      await HistoryService.saveHealthCalculation(
        '$_selectedCalculator: ${_getCalculationExpression()}',
        result,
        category: _selectedCalculator,
      );

      // Speak result if TTS is enabled
      if (_isTTSEnabled) {
        TTSService.speakHealthResult(_selectedCalculator, result, 'health');
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

  String _getActivityLevelText(String level) {
    switch (level.toLowerCase()) {
      case 'sedentary':
        return 'Sedentary';
      case 'lightly_active':
        return 'Lightly Active';
      case 'moderately_active':
        return 'Moderately Active';
      case 'very_active':
        return 'Very Active';
      case 'extra_active':
        return 'Extra Active';
      default:
        return 'Moderately Active';
    }
  }

  String _getActivityLevelFromValue(double value) {
    if (value <= 1.2) return 'sedentary';
    if (value <= 1.375) return 'lightly_active';
    if (value <= 1.55) return 'moderately_active';
    if (value <= 1.725) return 'very_active';
    return 'extra_active';
  }

  List<String> _getRequiredFields(String calculator) {
    switch (calculator) {
      case 'BMI Calculator':
        return ['weight', 'height'];
      case 'BMR Calculator':
        return ['weight', 'height', 'age'];
      case 'Daily Calorie Needs':
        return ['weight', 'height', 'age'];
      case 'Ideal Body Weight':
        return ['height'];
      case 'Body Fat Percentage':
        return ['weight', 'height', 'age', 'waist', 'neck'];
      case 'Water Intake Calculator':
        return ['weight', 'age'];
      case 'Heart Rate Zones':
        return ['age', 'restingHeartRate'];
      case 'Blood Pressure Check':
        return ['systolic', 'diastolic'];
      case 'Protein Calculator':
        return ['weight'];
      case 'Macro Calculator':
        return ['weight', 'height', 'age'];
      default:
        return [];
    }
  }

  String _getFieldLabel(String field) {
    final labels = {
      'weight': 'Weight (kg)',
      'height': 'Height (cm)',
      'age': 'Age (years)',
      'waist': 'Waist (cm)',
      'hip': 'Hip (cm)',
      'neck': 'Neck (cm)',
      'restingHeartRate': 'Resting Heart Rate (bpm)',
      'systolic': 'Systolic (mmHg)',
      'diastolic': 'Diastolic (mmHg)',
      'activityLevel': 'Activity Level',
      'goal': 'Goal (lose/maintain/gain)',
    };
    return labels[field] ?? field;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Calculator'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareHealthResult(_selectedCalculator, _result, 'health');
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

            // Gender Selection
            if (_selectedCalculator == 'BMI Calculator' || 
                _selectedCalculator == 'BMR Calculator' || 
                _selectedCalculator == 'Daily Calorie Needs' ||
                _selectedCalculator == 'Ideal Body Weight' ||
                _selectedCalculator == 'Body Fat Percentage' ||
                _selectedCalculator == 'Macro Calculator')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Male'),
                              value: true,
                              groupValue: _isMale,
                              onChanged: (value) {
                                setState(() {
                                  _isMale = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Female'),
                              value: false,
                              groupValue: _isMale,
                              onChanged: (value) {
                                setState(() {
                                  _isMale = value!;
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

            // Activity Level Slider
            if (_selectedCalculator == 'Daily Calorie Needs' || 
                _selectedCalculator == 'Macro Calculator')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activity Level: ${_getActivityLevelText(_activityLevel)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _activityLevelValue,
                        min: 1.2,
                        max: 1.9,
                        divisions: 7,
                        onChanged: (value) {
                          setState(() {
                            _activityLevelValue = value;
                            _activityLevel = _getActivityLevelFromValue(value);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sedentary\n(1.2)', style: theme.textTheme.bodySmall),
                          Text('Light\n(1.375)', style: theme.textTheme.bodySmall),
                          Text('Moderate\n(1.55)', style: theme.textTheme.bodySmall),
                          Text('Very Active\n(1.725)', style: theme.textTheme.bodySmall),
                          Text('Extra Active\n(1.9)', style: theme.textTheme.bodySmall),
                        ],
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
                            suffixText: _getFieldSuffix(field),
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
                                    await TTSService.speakHealthResult(_selectedCalculator, _result, 'health');
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

            // Health Tips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Tips',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildHealthTip('Maintain a balanced diet with fruits, vegetables, and whole grains'),
                    _buildHealthTip('Exercise regularly - aim for at least 150 minutes per week'),
                    _buildHealthTip('Stay hydrated - drink 8-10 glasses of water daily'),
                    _buildHealthTip('Get 7-9 hours of quality sleep each night'),
                    _buildHealthTip('Manage stress through meditation, yoga, or hobbies'),
                    _buildHealthTip('Regular health checkups and screenings are important'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFieldSuffix(String field) {
    if (field.contains('weight')) return 'kg';
    if (field.contains('height')) return 'cm';
    if (field.contains('age')) return 'years';
    if (field.contains('waist') || field.contains('hip') || field.contains('neck')) return 'cm';
    if (field.contains('Heart') || field.contains('Rate')) return 'bpm';
    if (field.contains('systolic') || field.contains('diastolic')) return 'mmHg';
    return '';
  }

  Widget _buildHealthTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getBloodPressureCategory(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 130 && diastolic < 80) return 'Elevated';
    if (systolic < 140 || diastolic < 90) return 'High Blood Pressure Stage 1';
    if (systolic < 180 || diastolic < 120) return 'High Blood Pressure Stage 2';
    return 'Hypertensive Crisis';
  }

  String _getBloodPressureRecommendations(String category) {
    switch (category) {
      case 'Normal':
        return 'Maintain healthy lifestyle';
      case 'Elevated':
        return 'Reduce sodium, increase exercise';
      case 'High Blood Pressure Stage 1':
        return 'Lifestyle changes recommended';
      case 'High Blood Pressure Stage 2':
        return 'Medical consultation advised';
      case 'Hypertensive Crisis':
        return 'Seek immediate medical attention';
      default:
        return 'Consult healthcare provider';
    }
  }

  Map<String, double> _calculateMacros(double calories, String goal) {
    double proteinRatio = 0.25;
    double carbRatio = 0.45;
    double fatRatio = 0.30;

    switch (goal.toLowerCase()) {
      case 'lose':
        proteinRatio = 0.30;
        carbRatio = 0.35;
        fatRatio = 0.35;
        break;
      case 'gain':
        proteinRatio = 0.20;
        carbRatio = 0.50;
        fatRatio = 0.30;
        break;
    }

    return {
      'calories': calories,
      'protein': calories * proteinRatio / 4, // 4 calories per gram
      'carbs': calories * carbRatio / 4, // 4 calories per gram
      'fat': calories * fatRatio / 9, // 9 calories per gram
    };
  }
}