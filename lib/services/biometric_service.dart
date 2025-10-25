import 'package:flutter/foundation.dart';

class BiometricService {
  static bool _isInitialized = false;
  static bool _isAvailable = false;
  static List<String> _availableBiometrics = [];
  
  // Available biometric types
  static const String fingerprint = 'fingerprint';
  static const String face = 'face';
  static const String iris = 'iris';
  static const String voice = 'voice';
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize biometric service
      _isAvailable = await _checkBiometricAvailability();
      _availableBiometrics = await _getAvailableBiometrics();
      _isInitialized = true;
      
      if (kDebugMode) print('Biometric service initialized. Available: $_isAvailable');
    } catch (e) {
      if (kDebugMode) print('Failed to initialize biometric service: $e');
      _isInitialized = false;
      _isAvailable = false;
    }
  }
  
  static Future<bool> _checkBiometricAvailability() async {
    try {
      // In a real implementation, this would check if biometrics are available
      // For now, we'll simulate availability
      return true;
    } catch (e) {
      if (kDebugMode) print('Biometric availability check error: $e');
      return false;
    }
  }
  
  static Future<List<String>> _getAvailableBiometrics() async {
    try {
      // In a real implementation, this would return actual available biometrics
      // For now, we'll simulate available biometrics
      return [fingerprint, face];
    } catch (e) {
      if (kDebugMode) print('Get available biometrics error: $e');
      return [];
    }
  }
  
  static Future<bool> authenticate({String? reason}) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isAvailable) {
      throw Exception('Biometric authentication not available');
    }
    
    try {
      if (kDebugMode) print('Starting biometric authentication: ${reason ?? 'Authentication required'}');
      
      // In a real implementation, this would perform actual biometric authentication
      // For now, we'll simulate authentication
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate success
      if (kDebugMode) print('Biometric authentication successful');
      return true;
      
    } catch (e) {
      if (kDebugMode) print('Biometric authentication failed: $e');
      return false;
    }
  }
  
  static Future<bool> authenticateWithBiometrics({
    String? reason,
    String? cancelButton,
    bool allowCredentials = true,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isAvailable) {
      throw Exception('Biometric authentication not available');
    }
    
    try {
      if (kDebugMode) print('Starting biometric authentication with options');
      
      // In a real implementation, this would perform biometric authentication with options
      await Future.delayed(const Duration(seconds: 1));
      
      if (kDebugMode) print('Biometric authentication with options successful');
      return true;
      
    } catch (e) {
      if (kDebugMode) print('Biometric authentication with options failed: $e');
      return false;
    }
  }
  
  static Future<bool> stopAuthentication() async {
    try {
      if (kDebugMode) print('Stopping biometric authentication');
      return true;
    } catch (e) {
      if (kDebugMode) print('Error stopping biometric authentication: $e');
      return false;
    }
  }
  
  static Future<bool> isDeviceSupported() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return _isAvailable;
  }
  
  static Future<List<String>> getAvailableBiometrics() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return List.from(_availableBiometrics);
  }
  
  static Future<bool> canCheckBiometrics() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return _isAvailable;
  }
  
  static Future<bool> isDeviceSecure() async {
    try {
      // In a real implementation, this would check if device has secure lock screen
      return true;
    } catch (e) {
      if (kDebugMode) print('Device security check error: $e');
      return false;
    }
  }
  
  static Future<Map<String, dynamic>> getBiometricStatus() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return {
      'isInitialized': _isInitialized,
      'isAvailable': _isAvailable,
      'availableBiometrics': _availableBiometrics,
      'isDeviceSupported': _isAvailable,
      'isDeviceSecure': await isDeviceSecure(),
    };
  }
  
  // Check if specific biometric type is available
  static Future<bool> isBiometricTypeAvailable(String biometricType) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return _availableBiometrics.contains(biometricType);
  }
  
  // Get biometric strength score
  static Future<int> getBiometricStrength() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isAvailable) return 0;
    
    int strength = 0;
    
    // Fingerprint adds 40 points
    if (_availableBiometrics.contains(fingerprint)) {
      strength += 40;
    }
    
    // Face recognition adds 30 points
    if (_availableBiometrics.contains(face)) {
      strength += 30;
    }
    
    // Iris adds 50 points (highest security)
    if (_availableBiometrics.contains(iris)) {
      strength += 50;
    }
    
    // Voice adds 20 points
    if (_availableBiometrics.contains(voice)) {
      strength += 20;
    }
    
    return strength.clamp(0, 100);
  }
  
  // Get recommended biometric type
  static Future<String?> getRecommendedBiometricType() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isAvailable) return null;
    
    // Prioritize by security level
    if (_availableBiometrics.contains(iris)) return iris;
    if (_availableBiometrics.contains(fingerprint)) return fingerprint;
    if (_availableBiometrics.contains(face)) return face;
    if (_availableBiometrics.contains(voice)) return voice;
    
    return null;
  }
  
  // Validate biometric settings
  static Future<Map<String, dynamic>> validateBiometricSettings() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final status = await getBiometricStatus();
    final strength = await getBiometricStrength();
    final recommended = await getRecommendedBiometricType();
    
    return {
      'isValid': _isAvailable && _isInitialized,
      'status': status,
      'strength': strength,
      'recommendedType': recommended,
      'recommendations': _getRecommendations(strength, _availableBiometrics),
    };
  }
  
  static List<String> _getRecommendations(int strength, List<String> available) {
    final recommendations = <String>[];
    
    if (strength < 30) {
      recommendations.add('Consider enabling additional biometric types for better security');
    }
    
    if (!available.contains(fingerprint) && !available.contains(face)) {
      recommendations.add('Fingerprint or face recognition is recommended for optimal security');
    }
    
    if (available.length == 1) {
      recommendations.add('Having multiple biometric types provides better security');
    }
    
    if (strength >= 70) {
      recommendations.add('Excellent biometric security setup');
    }
    
    return recommendations;
  }
  
  static Future<void> dispose() async {
    if (!_isInitialized) return;
    
    try {
      _isInitialized = false;
      _isAvailable = false;
      _availableBiometrics.clear();
      
      if (kDebugMode) print('Biometric service disposed');
    } catch (e) {
      if (kDebugMode) print('Biometric service dispose error: $e');
    }
  }
}
