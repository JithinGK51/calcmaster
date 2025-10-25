import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static FlutterTts? _flutterTts;
  static bool _isInitialized = false;
  static bool _isSpeaking = false;
  static String _currentVoice = 'default';
  static double _speechRate = 1.0;
  static double _pitch = 1.0;
  static double _volume = 1.0;
  static List<dynamic> _voices = [];
  
  // Available voices (will be populated from device)
  static List<String> _availableVoices = [
    'default',
    'male_1',
    'male_2', 
    'male_3',
    'male_4',
    'male_5',
    'female_1',
    'female_2',
    'female_3',
    'female_4',
    'female_5',
  ];
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _flutterTts = FlutterTts();
      
      // Get available voices from device
      _voices = await _flutterTts!.getVoices;
      if (_voices.isNotEmpty) {
        _availableVoices = _voices.map((voice) => voice['name'] as String).toList();
        if (kDebugMode) print('Available TTS voices: $_availableVoices');
      }
      
      // Set default language
      await _flutterTts!.setLanguage("en-US");
      
      // Set default parameters
      await _flutterTts!.setSpeechRate(_speechRate);
      await _flutterTts!.setVolume(_volume);
      await _flutterTts!.setPitch(_pitch);
      
      // Set completion handler
      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        if (kDebugMode) print('TTS completed');
      });
      
      // Set error handler
      _flutterTts!.setErrorHandler((msg) {
        _isSpeaking = false;
        if (kDebugMode) print('TTS error: $msg');
      });
      
      _isInitialized = true;
      if (kDebugMode) print('TTS initialized successfully with ${_voices.length} voices');
    } catch (e) {
      if (kDebugMode) print('Error initializing TTS: $e');
      _isInitialized = false;
    }
  }
  
  static Future<void> speak(String text) async {
    if (!_isInitialized || _flutterTts == null) {
      if (kDebugMode) print('TTS not initialized. Cannot speak: $text');
      return;
    }
    
    if (_isSpeaking) {
      await stop();
    }
    
    try {
      _isSpeaking = true;
      await _flutterTts!.speak(text);
      if (kDebugMode) print('Speaking: "$text" with voice $_currentVoice, rate $_speechRate, pitch $_pitch, volume $_volume');
    } catch (e) {
      _isSpeaking = false;
      if (kDebugMode) print('Error speaking: $e');
    }
  }
  
  static Future<void> stop() async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      await _flutterTts!.stop();
      _isSpeaking = false;
      if (kDebugMode) print('TTS stopped');
    } catch (e) {
      if (kDebugMode) print('Error stopping TTS: $e');
    }
  }
  
  static Future<void> pause() async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      await _flutterTts!.pause();
      if (kDebugMode) print('TTS paused');
    } catch (e) {
      if (kDebugMode) print('Error pausing TTS: $e');
    }
  }
  
  static Future<void> setVoice(String voice) async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      _currentVoice = voice;
      
      // Find the voice in the available voices list
      final voiceData = _voices.firstWhere(
        (v) => v['name'] == voice,
        orElse: () => _voices.isNotEmpty ? _voices.first : null,
      );
      
      if (voiceData != null) {
        await _flutterTts!.setVoice(voiceData);
        if (kDebugMode) print('TTS voice set to: $_currentVoice');
      }
    } catch (e) {
      if (kDebugMode) print('Error setting voice: $e');
    }
  }
  
  static Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      _speechRate = rate.clamp(0.1, 2.0);
      await _flutterTts!.setSpeechRate(_speechRate);
      if (kDebugMode) print('TTS speech rate set to: $_speechRate');
    } catch (e) {
      if (kDebugMode) print('Error setting speech rate: $e');
    }
  }
  
  static Future<void> setPitch(double pitch) async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      _pitch = pitch.clamp(0.1, 2.0);
      await _flutterTts!.setPitch(_pitch);
      if (kDebugMode) print('TTS pitch set to: $_pitch');
    } catch (e) {
      if (kDebugMode) print('Error setting pitch: $e');
    }
  }
  
  static Future<void> setVolume(double volume) async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _flutterTts!.setVolume(_volume);
      if (kDebugMode) print('TTS volume set to: $_volume');
    } catch (e) {
      if (kDebugMode) print('Error setting volume: $e');
    }
  }
  
  static Future<void> setLanguage(String language) async {
    if (!_isInitialized || _flutterTts == null) return;
    
    try {
      await _flutterTts!.setLanguage(language);
      if (kDebugMode) print('TTS language set to: $language');
    } catch (e) {
      if (kDebugMode) print('Error setting language: $e');
    }
  }
  
  // Getters
  static String getCurrentVoice() => _currentVoice;
  static double getSpeechRate() => _speechRate;
  static double getPitch() => _pitch;
  static double getVolume() => _volume;
  static bool getIsSpeaking() => _isSpeaking;
  static bool get isInitialized => _isInitialized;
  static List<String> getAvailableVoices() => List.from(_availableVoices);
  
  // Convenience methods for different types of results
  static Future<void> speakCalculation(String expression, String result) async {
    final text = 'The result of $expression is $result';
    await speak(text);
  }
  
  static Future<void> speakHealthResult(String calculator, String result, String category) async {
    final text = '$calculator result: $result';
    await speak(text);
  }

  static Future<void> speakFinanceResult(String calculator, String result) async {
    final text = 'Finance $calculator result: $result';
    await speak(text);
  }

  static Future<void> speakConversion(String from, String to, String result) async {
    final text = 'Conversion result: $result';
    await speak(text);
  }
  
  static Future<void> speakBudgetResult(String action, String result) async {
    final text = 'Budget $action: $result';
    await speak(text);
  }
  
  static Future<void> speakCurrencyResult(String from, String to, String amount, String result) async {
    final text = '$amount $from equals $result $to';
    await speak(text);
  }
  
  static Future<void> speakGraphResult(String function, String result) async {
    final text = 'Graph result for $function: $result';
    await speak(text);
  }
  
  static Future<void> speakReminderResult(String action, String result) async {
    final text = 'Reminder $action: $result';
    await speak(text);
  }
  
  static Future<void> speakVaultResult(String action, String result) async {
    final text = 'Vault $action: $result';
    await speak(text);
  }
  
  static Future<void> speakStatsResult(String category, String result) async {
    final text = 'Statistics for $category: $result';
    await speak(text);
  }
  
  static Future<void> speakAboutInfo(String info) async {
    final text = 'About: $info';
    await speak(text);
  }
  
  static Future<void> speakHistoryResult(String action, String result) async {
    final text = 'History $action: $result';
    await speak(text);
  }
  
  // Voice preview functionality
  static Future<void> previewVoice(String voice) async {
    if (!_isInitialized) return;
    
    final currentVoice = _currentVoice;
    await setVoice(voice);
    await speak('This is a preview of the $voice voice');
    await Future.delayed(const Duration(seconds: 2));
    await setVoice(currentVoice);
  }
  
  // Get voice information
  static Map<String, dynamic> getVoiceInfo(String voice) {
    final voiceData = _voices.firstWhere(
      (v) => v['name'] == voice,
      orElse: () => null,
    );
    
    if (voiceData != null) {
      return {
        'name': voiceData['name'],
        'locale': voiceData['locale'],
        'quality': voiceData['quality'],
        'latency': voiceData['latency'],
        'network': voiceData['network'],
      };
    }
    
    return {
      'name': voice,
      'locale': 'en-US',
      'quality': 'default',
      'latency': 'low',
      'network': 'offline',
    };
  }
  
  // Dispose resources
  static Future<void> dispose() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
      _flutterTts = null;
    }
    _isInitialized = false;
    _isSpeaking = false;
  }
}