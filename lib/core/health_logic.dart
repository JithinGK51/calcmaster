import 'dart:math' as math;

class HealthLogic {
  // BMI (Body Mass Index) Calculator
  static double calculateBMI(double weight, double height) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');
    
    return weight / (height * height);
  }
  
  // BMI Category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
  
  // BMI with different units
  static double calculateBMIWithUnits(double weight, double height, String weightUnit, String heightUnit) {
    // Convert to kg and meters
    double weightInKg = _convertWeightToKg(weight, weightUnit);
    double heightInMeters = _convertHeightToMeters(height, heightUnit);
    
    return calculateBMI(weightInKg, heightInMeters);
  }
  
  // BMR (Basal Metabolic Rate) Calculator - Mifflin-St Jeor Equation
  static double calculateBMR(double weight, double height, int age, String gender) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');
    if (age <= 0) throw ArgumentError('Age must be positive');
    
    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        return (10 * weight) + (6.25 * height) - (5 * age) + 5;
      case 'female':
      case 'f':
        return (10 * weight) + (6.25 * height) - (5 * age) - 161;
      default:
        throw ArgumentError('Gender must be male or female');
    }
  }
  
  // BMR with different units
  static double calculateBMRWithUnits(double weight, double height, int age, String gender, String weightUnit, String heightUnit) {
    double weightInKg = _convertWeightToKg(weight, weightUnit);
    double heightInCm = _convertHeightToCm(height, heightUnit);
    
    return calculateBMR(weightInKg, heightInCm, age, gender);
  }
  
  // TDEE (Total Daily Energy Expenditure) Calculator
  static double calculateTDEE(double bmr, String activityLevel) {
    if (bmr <= 0) throw ArgumentError('BMR must be positive');
    
    final activityMultipliers = {
      'sedentary': 1.2,      // Little or no exercise
      'light': 1.375,        // Light exercise 1-3 days/week
      'moderate': 1.55,      // Moderate exercise 3-5 days/week
      'active': 1.725,       // Heavy exercise 6-7 days/week
      'very_active': 1.9,    // Very heavy exercise, physical job
    };
    
    final multiplier = activityMultipliers[activityLevel.toLowerCase()];
    if (multiplier == null) {
      throw ArgumentError('Invalid activity level');
    }
    
    return bmr * multiplier;
  }
  
  // Calorie Calculator for Weight Goals
  static Map<String, double> calculateCalorieNeeds(double tdee, String goal) {
    double calorieAdjustment;
    
    switch (goal.toLowerCase()) {
      case 'lose_weight':
      case 'weight_loss':
        calorieAdjustment = -500; // 1 lb per week
        break;
      case 'lose_weight_aggressive':
        calorieAdjustment = -1000; // 2 lbs per week
        break;
      case 'maintain_weight':
        calorieAdjustment = 0;
        break;
      case 'gain_weight':
      case 'weight_gain':
        calorieAdjustment = 500; // 1 lb per week
        break;
      case 'gain_weight_aggressive':
        calorieAdjustment = 1000; // 2 lbs per week
        break;
      default:
        throw ArgumentError('Invalid weight goal');
    }
    
    return {
      'dailyCalories': tdee + calorieAdjustment,
      'weeklyDeficit': calorieAdjustment * 7,
      'monthlyDeficit': calorieAdjustment * 30,
    };
  }
  
  // Body Fat Percentage Calculator
  static double calculateBodyFatPercentage(double weight, double height, int age, String gender, double waist, double neck, {double? hip}) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');
    if (age <= 0) throw ArgumentError('Age must be positive');
    if (waist <= 0) throw ArgumentError('Waist measurement must be positive');
    if (neck <= 0) throw ArgumentError('Neck measurement must be positive');
    
    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        return 495 / (1.0324 - 0.19077 * (math.log(waist - neck) / math.ln10) + 0.15456 * (math.log(height) / math.ln10)) - 450;
      case 'female':
      case 'f':
        if (hip == null) throw ArgumentError('Hip measurement required for females');
        if (hip <= 0) throw ArgumentError('Hip measurement must be positive');
        return 495 / (1.29579 - 0.35004 * (math.log(waist + hip - neck) / math.ln10) + 0.22100 * (math.log(height) / math.ln10)) - 450;
      default:
        throw ArgumentError('Gender must be male or female');
    }
  }
  
  // Body Fat Category
  static String getBodyFatCategory(double bodyFatPercentage, String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        if (bodyFatPercentage < 6) return 'Essential fat';
        if (bodyFatPercentage < 14) return 'Athletes';
        if (bodyFatPercentage < 18) return 'Fitness';
        if (bodyFatPercentage < 25) return 'Average';
        return 'Obese';
      case 'female':
      case 'f':
        if (bodyFatPercentage < 10) return 'Essential fat';
        if (bodyFatPercentage < 16) return 'Athletes';
        if (bodyFatPercentage < 20) return 'Fitness';
        if (bodyFatPercentage < 25) return 'Average';
        return 'Obese';
      default:
        return 'Unknown';
    }
  }
  
  // Ideal Weight Calculator
  static Map<String, double> calculateIdealWeight(double height, String gender, String heightUnit) {
    if (height <= 0) throw ArgumentError('Height must be positive');
    
    double heightInMeters = _convertHeightToMeters(height, heightUnit);
    double heightInInches = heightInMeters * 39.3701;
    
    double idealWeightKg;
    double idealWeightLbs;
    
    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        // Robinson formula
        idealWeightKg = 52 + (1.9 * (heightInInches - 60));
        break;
      case 'female':
      case 'f':
        // Robinson formula
        idealWeightKg = 49 + (1.7 * (heightInInches - 60));
        break;
      default:
        throw ArgumentError('Gender must be male or female');
    }
    
    idealWeightLbs = idealWeightKg * 2.20462;
    
    return {
      'idealWeightKg': idealWeightKg,
      'idealWeightLbs': idealWeightLbs,
      'weightRangeKg': idealWeightKg * 0.9, // ±10% range
      'weightRangeLbs': idealWeightLbs * 0.9,
    };
  }
  
  // Water Intake Calculator
  static double calculateWaterIntake(double weight, String weightUnit, String activityLevel, String climate) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    
    double weightInKg = _convertWeightToKg(weight, weightUnit);
    double baseWaterIntake = weightInKg * 35; // 35ml per kg
    
    // Activity level adjustment
    double activityMultiplier = 1.0;
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        activityMultiplier = 1.0;
        break;
      case 'light':
        activityMultiplier = 1.2;
        break;
      case 'moderate':
        activityMultiplier = 1.4;
        break;
      case 'active':
        activityMultiplier = 1.6;
        break;
      case 'very_active':
        activityMultiplier = 1.8;
        break;
    }
    
    // Climate adjustment
    double climateMultiplier = 1.0;
    switch (climate.toLowerCase()) {
      case 'cool':
        climateMultiplier = 1.0;
        break;
      case 'moderate':
        climateMultiplier = 1.1;
        break;
      case 'hot':
        climateMultiplier = 1.3;
        break;
      case 'very_hot':
        climateMultiplier = 1.5;
        break;
    }
    
    return baseWaterIntake * activityMultiplier * climateMultiplier;
  }
  
  // Heart Rate Zones Calculator
  static Map<String, int> calculateHeartRateZones(int age, int restingHeartRate) {
    if (age <= 0) throw ArgumentError('Age must be positive');
    if (restingHeartRate <= 0) throw ArgumentError('Resting heart rate must be positive');
    
    final maxHeartRate = 220 - age;
    final heartRateReserve = maxHeartRate - restingHeartRate;
    
    return {
      'maxHeartRate': maxHeartRate,
      'restingHeartRate': restingHeartRate,
      'zone1Min': (restingHeartRate + heartRateReserve * 0.5).round(),
      'zone1Max': (restingHeartRate + heartRateReserve * 0.6).round(),
      'zone2Min': (restingHeartRate + heartRateReserve * 0.6).round(),
      'zone2Max': (restingHeartRate + heartRateReserve * 0.7).round(),
      'zone3Min': (restingHeartRate + heartRateReserve * 0.7).round(),
      'zone3Max': (restingHeartRate + heartRateReserve * 0.8).round(),
      'zone4Min': (restingHeartRate + heartRateReserve * 0.8).round(),
      'zone4Max': (restingHeartRate + heartRateReserve * 0.9).round(),
      'zone5Min': (restingHeartRate + heartRateReserve * 0.9).round(),
      'zone5Max': maxHeartRate,
    };
  }
  
  // Protein Requirements Calculator
  static double calculateProteinNeeds(double weight, String weightUnit, String activityLevel, String goal) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    
    double weightInKg = _convertWeightToKg(weight, weightUnit);
    double proteinPerKg;
    
    switch (goal.toLowerCase()) {
      case 'maintenance':
        proteinPerKg = 0.8;
        break;
      case 'weight_loss':
        proteinPerKg = 1.2;
        break;
      case 'muscle_gain':
        proteinPerKg = 1.6;
        break;
      case 'endurance':
        proteinPerKg = 1.2;
        break;
      default:
        proteinPerKg = 1.0;
    }
    
    // Activity level adjustment
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        proteinPerKg *= 1.0;
        break;
      case 'light':
        proteinPerKg *= 1.1;
        break;
      case 'moderate':
        proteinPerKg *= 1.2;
        break;
      case 'active':
        proteinPerKg *= 1.3;
        break;
      case 'very_active':
        proteinPerKg *= 1.4;
        break;
    }
    
    return weightInKg * proteinPerKg;
  }
  
  // Waist-to-Hip Ratio Calculator
  static double calculateWaistToHipRatio(double waist, double hip) {
    if (waist <= 0) throw ArgumentError('Waist measurement must be positive');
    if (hip <= 0) throw ArgumentError('Hip measurement must be positive');
    
    return waist / hip;
  }
  
  // Waist-to-Hip Ratio Category
  static String getWaistToHipCategory(double ratio, String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        if (ratio < 0.9) return 'Low risk';
        if (ratio < 1.0) return 'Moderate risk';
        return 'High risk';
      case 'female':
      case 'f':
        if (ratio < 0.8) return 'Low risk';
        if (ratio < 0.85) return 'Moderate risk';
        return 'High risk';
      default:
        return 'Unknown';
    }
  }
  
  // Body Surface Area Calculator (Mosteller formula)
  static double calculateBodySurfaceArea(double weight, double height, String weightUnit, String heightUnit) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');
    
    double weightInKg = _convertWeightToKg(weight, weightUnit);
    double heightInCm = _convertHeightToCm(height, heightUnit);
    
    return math.sqrt((weightInKg * heightInCm) / 3600);
  }
  
  // Lean Body Mass Calculator
  static double calculateLeanBodyMass(double weight, double bodyFatPercentage, String weightUnit) {
    if (weight <= 0) throw ArgumentError('Weight must be positive');
    if (bodyFatPercentage < 0 || bodyFatPercentage > 100) {
      throw ArgumentError('Body fat percentage must be between 0 and 100');
    }
    
    double weightInKg = _convertWeightToKg(weight, weightUnit);
    return weightInKg * (1 - bodyFatPercentage / 100);
  }
  
  // Helper functions for unit conversion
  static double _convertWeightToKg(double weight, String unit) {
    switch (unit.toLowerCase()) {
      case 'kg':
      case 'kilogram':
        return weight;
      case 'lbs':
      case 'pound':
        return weight * 0.453592;
      case 'g':
      case 'gram':
        return weight / 1000;
      case 'oz':
      case 'ounce':
        return weight * 0.0283495;
      default:
        throw ArgumentError('Unknown weight unit: $unit');
    }
  }
  
  static double _convertHeightToMeters(double height, String unit) {
    switch (unit.toLowerCase()) {
      case 'm':
      case 'meter':
        return height;
      case 'cm':
      case 'centimeter':
        return height / 100;
      case 'ft':
      case 'foot':
        return height * 0.3048;
      case 'in':
      case 'inch':
        return height * 0.0254;
      default:
        throw ArgumentError('Unknown height unit: $unit');
    }
  }
  
  static double _convertHeightToCm(double height, String unit) {
    switch (unit.toLowerCase()) {
      case 'm':
      case 'meter':
        return height * 100;
      case 'cm':
      case 'centimeter':
        return height;
      case 'ft':
      case 'foot':
        return height * 30.48;
      case 'in':
      case 'inch':
        return height * 2.54;
      default:
        throw ArgumentError('Unknown height unit: $unit');
    }
  }
  
  // Metabolic Age Calculator (simplified)
  static double calculateMetabolicAge(double bmr, String gender, int actualAge) {
    if (bmr <= 0) throw ArgumentError('BMR must be positive');
    if (actualAge <= 0) throw ArgumentError('Age must be positive');
    
    // This is a simplified calculation - real metabolic age requires more complex analysis
    double averageBMR;
    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        averageBMR = 1500 + (actualAge * 10); // Rough approximation
        break;
      case 'female':
      case 'f':
        averageBMR = 1200 + (actualAge * 8); // Rough approximation
        break;
      default:
        throw ArgumentError('Gender must be male or female');
    }
    
    // Calculate metabolic age based on BMR comparison
    if (bmr > averageBMR) {
      return actualAge - ((bmr - averageBMR) / 50);
    } else {
      return actualAge + ((averageBMR - bmr) / 50);
    }
  }
}
