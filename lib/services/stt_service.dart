import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class STTService {
  static final SpeechToText _speechToText = SpeechToText();
  static bool _isInitialized = false;
  static bool _isListening = false;
  static String _currentLanguage = 'en_US';
  static List<LocaleName> _availableLocales = [];
  
  // Available languages
  static const List<String> _availableLanguages = [
    'en_US',
    'en_GB',
    'es_ES',
    'fr_FR',
    'de_DE',
    'it_IT',
    'pt_BR',
    'ru_RU',
    'ja_JP',
    'ko_KR',
    'zh_CN',
    'hi_IN',
  ];
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Request microphone permission
      final permission = await Permission.microphone.request();
      if (permission != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      
      // Initialize speech to text
      final available = await _speechToText.initialize(
        onError: (error) {
          if (kDebugMode) print('STT Error: $error');
        },
        onStatus: (status) {
          if (kDebugMode) print('STT Status: $status');
          _isListening = status == 'listening';
        },
      );
      
      if (available) {
        _availableLocales = await _speechToText.locales();
        _isInitialized = true;
        if (kDebugMode) print('STT initialized successfully');
        if (kDebugMode) print('Available locales: ${_availableLocales.length}');
      } else {
        throw Exception('Speech to text not available');
      }
    } catch (e) {
      if (kDebugMode) print('Failed to initialize STT: $e');
      _isInitialized = false;
    }
  }
  
  static Future<String> listen() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      throw Exception('STT not initialized');
    }
    
    try {
      String recognizedText = '';
      
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
          if (kDebugMode) print('STT Result: $recognizedText');
        },
        localeId: _currentLanguage,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
      
      // Wait for listening to complete
      while (_speechToText.isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      return recognizedText;
    } catch (e) {
      if (kDebugMode) print('STT Error: $e');
      rethrow;
    }
  }
  
  static Future<void> stop() async {
    try {
      await _speechToText.stop();
      _isListening = false;
      if (kDebugMode) print('STT stopped');
    } catch (e) {
      if (kDebugMode) print('STT stop error: $e');
    }
  }
  
  static Future<void> setLanguage(String language) async {
    if (_availableLanguages.contains(language)) {
      _currentLanguage = language;
      if (kDebugMode) print('STT language set to: $language');
    }
  }
  
  static List<String> getAvailableLanguages() {
    return List.from(_availableLanguages);
  }
  
  static List<LocaleName> getAvailableLocales() {
    return List.from(_availableLocales);
  }
  
  static String getCurrentLanguage() => _currentLanguage;
  static bool getIsListening() => _speechToText.isListening;
  static bool getIsInitialized() => _isInitialized;
  
  // Check if STT is available on the device
  static Future<bool> isAvailable() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return _isInitialized && _speechToText.isAvailable;
    } catch (e) {
      if (kDebugMode) print('STT availability check error: $e');
      return false;
    }
  }
  
  // Get supported languages for the current device
  static Future<List<String>> getSupportedLanguages() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return _availableLocales.map((locale) => locale.localeId).toList();
    } catch (e) {
      if (kDebugMode) print('STT supported languages error: $e');
      return ['en_US'];
    }
  }
  
  // Start continuous listening
  static Future<void> startContinuousListening({
    required Function(String) onResult,
    required Function(String) onError,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      onError('STT not initialized');
      return;
    }
    
    try {
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        localeId: _currentLanguage,
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      );
      
      if (kDebugMode) print('STT continuous listening started');
    } catch (e) {
      onError('STT continuous listening error: $e');
    }
  }
  
  // Stop continuous listening
  static Future<void> stopContinuousListening() async {
    try {
      await _speechToText.stop();
      if (kDebugMode) print('STT continuous listening stopped');
    } catch (e) {
      if (kDebugMode) print('STT stop continuous listening error: $e');
    }
  }
  
  // Cancel listening
  static Future<void> cancel() async {
    try {
      await _speechToText.cancel();
      if (kDebugMode) print('STT cancelled');
    } catch (e) {
      if (kDebugMode) print('STT cancel error: $e');
    }
  }
  
  // Get listening status
  static Map<String, dynamic> getListeningStatus() {
    return {
      'isListening': _speechToText.isListening,
      'isInitialized': _isInitialized,
      'currentLanguage': _currentLanguage,
      'isAvailable': _speechToText.isAvailable,
      'lastError': _speechToText.lastError,
    };
  }
  
  // Listen for specific duration
  static Future<String> listenForDuration(Duration duration) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      throw Exception('STT not initialized');
    }
    
    try {
      String recognizedText = '';
      
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        localeId: _currentLanguage,
        listenFor: duration,
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
      
      // Wait for listening to complete
      while (_speechToText.isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      return recognizedText;
    } catch (e) {
      if (kDebugMode) print('STT Error: $e');
      rethrow;
    }
  }
  
  // Listen with custom settings
  static Future<String> listenWithSettings({
    Duration? listenFor,
    Duration? pauseFor,
    bool partialResults = true,
    bool cancelOnError = true,
    ListenMode listenMode = ListenMode.confirmation,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) {
      throw Exception('STT not initialized');
    }
    
    try {
      String recognizedText = '';
      
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        localeId: _currentLanguage,
        listenFor: listenFor ?? const Duration(seconds: 30),
        pauseFor: pauseFor ?? const Duration(seconds: 3),
        partialResults: partialResults,
        cancelOnError: cancelOnError,
        listenMode: listenMode,
      );
      
      // Wait for listening to complete
      while (_speechToText.isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      return recognizedText;
    } catch (e) {
      if (kDebugMode) print('STT Error: $e');
      rethrow;
    }
  }
  
  // Get confidence level of last recognition
  static double getLastConfidence() {
    return _speechToText.lastRecognizedWords?.confidence ?? 0.0;
  }
  
  // Check if device has speech recognition capability
  static Future<bool> hasPermission() async {
    try {
      final permission = await Permission.microphone.status;
      return permission == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) print('Permission check error: $e');
      return false;
    }
  }
  
  // Request microphone permission
  static Future<bool> requestPermission() async {
    try {
      final permission = await Permission.microphone.request();
      return permission == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) print('Permission request error: $e');
      return false;
    }
  }
  
  // Dispose STT service
  static Future<void> dispose() async {
    if (!_isInitialized) return;
    
    try {
      await _speechToText.stop();
      _isInitialized = false;
      
      if (kDebugMode) print('STT disposed');
    } catch (e) {
      if (kDebugMode) print('STT dispose error: $e');
    }
  }
}
