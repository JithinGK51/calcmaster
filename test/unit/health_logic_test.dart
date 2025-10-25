import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/health_logic.dart';

void main() {
  group('HealthLogic', () {
    test('should calculate BMI correctly', () {
      final result = HealthLogic.calculateBMI(70, 1.75);
      expect(result['bmi'], closeTo(22.86, 0.1));
      expect(result['category'], 'Normal weight');
    });

    test('should categorize BMI correctly', () {
      expect(HealthLogic.calculateBMI(50, 1.70)['category'], 'Underweight');
      expect(HealthLogic.calculateBMI(70, 1.70)['category'], 'Normal weight');
      expect(HealthLogic.calculateBMI(80, 1.70)['category'], 'Overweight');
      expect(HealthLogic.calculateBMI(100, 1.70)['category'], 'Obese');
    });

    test('should calculate BMR using Mifflin-St Jeor equation', () {
      final result = HealthLogic.calculateBMR(70, 175, 25, 'male');
      expect(result['bmr'], closeTo(1706.0, 10.0));
      expect(result['method'], 'Mifflin-St Jeor');
    });

    test('should calculate BMR for females', () {
      final result = HealthLogic.calculateBMR(60, 165, 30, 'female');
      expect(result['bmr'], closeTo(1300.0, 50.0));
      expect(result['method'], 'Mifflin-St Jeor');
    });

    test('should calculate daily calorie needs correctly', () {
      final result = HealthLogic.calculateDailyCalorieNeeds(1700, 'moderate');
      expect(result['calories'], closeTo(2380.0, 50.0));
      expect(result['activityLevel'], 'moderate');
    });

    test('should calculate body fat percentage for males', () {
      final result = HealthLogic.calculateBodyFatPercentage(70, 175, 25, 'male', 80, 90);
      expect(result['bodyFatPercentage'], closeTo(15.0, 5.0));
      expect(result['category'], isA<String>());
    });

    test('should calculate body fat percentage for females', () {
      final result = HealthLogic.calculateBodyFatPercentage(60, 165, 30, 'female', 70, 80);
      expect(result['bodyFatPercentage'], closeTo(25.0, 5.0));
      expect(result['category'], isA<String>());
    });

    test('should calculate ideal weight correctly', () {
      final result = HealthLogic.calculateIdealWeight(175, 'male');
      expect(result['idealWeight'], closeTo(70.0, 5.0));
      expect(result['healthyRange'], isA<Map>());
    });

    test('should calculate water intake correctly', () {
      final result = HealthLogic.calculateWaterIntake(70, 25, 'male', 'moderate');
      expect(result['waterIntake'], closeTo(2.5, 0.5));
      expect(result['unit'], 'L');
    });

    test('should calculate protein needs correctly', () {
      final result = HealthLogic.calculateProteinNeeds(70, 'moderate');
      expect(result['proteinNeeds'], closeTo(84.0, 10.0));
      expect(result['unit'], 'g');
    });

    test('should calculate heart rate zones correctly', () {
      final result = HealthLogic.calculateHeartRateZones(30);
      expect(result['maxHeartRate'], 190);
      expect(result['zones'], isA<Map>());
      expect(result['zones']['fatBurn'], isA<Map>());
    });

    test('should calculate blood pressure category correctly', () {
      expect(HealthLogic.categorizeBloodPressure(110, 70)['category'], 'Normal');
      expect(HealthLogic.categorizeBloodPressure(130, 85)['category'], 'High Blood Pressure Stage 1');
      expect(HealthLogic.categorizeBloodPressure(150, 95)['category'], 'High Blood Pressure Stage 2');
      expect(HealthLogic.categorizeBloodPressure(180, 110)['category'], 'Hypertensive Crisis');
    });

    test('should calculate waist-to-hip ratio correctly', () {
      final result = HealthLogic.calculateWaistToHipRatio(80, 90, 'male');
      expect(result['ratio'], closeTo(0.89, 0.01));
      expect(result['category'], 'Low risk');
    });

    test('should calculate waist-to-height ratio correctly', () {
      final result = HealthLogic.calculateWaistToHeightRatio(80, 175);
      expect(result['ratio'], closeTo(0.46, 0.01));
      expect(result['category'], 'Low risk');
    });

    test('should calculate metabolic age correctly', () {
      final result = HealthLogic.calculateMetabolicAge(1700, 25, 'male');
      expect(result['metabolicAge'], closeTo(25.0, 5.0));
      expect(result['comparison'], isA<String>());
    });

    test('should calculate TDEE correctly', () {
      final result = HealthLogic.calculateTDEE(1700, 'moderate');
      expect(result['tdee'], closeTo(2380.0, 50.0));
      expect(result['activityMultiplier'], closeTo(1.4, 0.1));
    });

    test('should calculate calorie deficit for weight loss', () {
      final result = HealthLogic.calculateCalorieDeficit(2000, 0.5);
      expect(result['deficit'], 500.0);
      expect(result['targetCalories'], 1500.0);
      expect(result['weeklyWeightLoss'], 0.5);
    });

    test('should calculate calorie surplus for weight gain', () {
      final result = HealthLogic.calculateCalorieSurplus(2000, 0.5);
      expect(result['surplus'], 500.0);
      expect(result['targetCalories'], 2500.0);
      expect(result['weeklyWeightGain'], 0.5);
    });

    test('should calculate macronutrient distribution', () {
      final result = HealthLogic.calculateMacronutrientDistribution(2000, 'balanced');
      expect(result['carbohydrates'], closeTo(1000.0, 50.0));
      expect(result['protein'], closeTo(500.0, 50.0));
      expect(result['fat'], closeTo(500.0, 50.0));
    });

    test('should calculate pregnancy weight gain recommendations', () {
      final result = HealthLogic.calculatePregnancyWeightGain(60, 165, 30);
      expect(result['recommendedGain'], isA<Map>());
      expect(result['recommendedGain']['total'], isA<String>());
    });

    test('should calculate child growth percentiles', () {
      final result = HealthLogic.calculateChildGrowthPercentile(15, 100, 5, 'male');
      expect(result['percentile'], isA<String>());
      expect(result['category'], isA<String>());
    });

    test('should handle edge cases', () {
      expect(() => HealthLogic.calculateBMI(0, 1.70), throwsArgumentError);
      expect(() => HealthLogic.calculateBMI(70, 0), throwsArgumentError);
      expect(() => HealthLogic.calculateBMR(70, 175, 25, 'invalid'), throwsArgumentError);
    });

    test('should handle extreme values', () {
      final result1 = HealthLogic.calculateBMI(200, 1.50);
      expect(result1['category'], 'Obese');
      
      final result2 = HealthLogic.calculateBMI(30, 1.80);
      expect(result2['category'], 'Underweight');
    });

    test('should handle different activity levels', () {
      final sedentary = HealthLogic.calculateDailyCalorieNeeds(1700, 'sedentary');
      final moderate = HealthLogic.calculateDailyCalorieNeeds(1700, 'moderate');
      final active = HealthLogic.calculateDailyCalorieNeeds(1700, 'active');
      
      expect(sedentary['calories'], lessThan(moderate['calories']));
      expect(moderate['calories'], lessThan(active['calories']));
    });

    test('should handle different age groups', () {
      final young = HealthLogic.calculateBMR(70, 175, 20, 'male');
      final old = HealthLogic.calculateBMR(70, 175, 60, 'male');
      
      expect(young['bmr'], greaterThan(old['bmr']));
    });

    test('should handle different body compositions', () {
      final lean = HealthLogic.calculateBodyFatPercentage(70, 175, 25, 'male', 75, 90);
      final heavy = HealthLogic.calculateBodyFatPercentage(70, 175, 25, 'male', 85, 90);
      
      expect(lean['bodyFatPercentage'], lessThan(heavy['bodyFatPercentage']));
    });
  });
}
