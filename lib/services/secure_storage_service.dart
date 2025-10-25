import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  // Store encrypted data
  static Future<void> store(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      if (kDebugMode) print('Stored secure data for key: $key');
    } catch (e) {
      if (kDebugMode) print('Error storing secure data: $e');
      rethrow;
    }
  }
  
  // Retrieve encrypted data
  static Future<String?> retrieve(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (kDebugMode) print('Retrieved secure data for key: $key');
      return value;
    } catch (e) {
      if (kDebugMode) print('Error retrieving secure data: $e');
      return null;
    }
  }
  
  // Delete encrypted data
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      if (kDebugMode) print('Deleted secure data for key: $key');
    } catch (e) {
      if (kDebugMode) print('Error deleting secure data: $e');
      rethrow;
    }
  }
  
  // Delete all encrypted data
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      if (kDebugMode) print('Deleted all secure data');
    } catch (e) {
      if (kDebugMode) print('Error deleting all secure data: $e');
      rethrow;
    }
  }
  
  // Check if key exists
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      if (kDebugMode) print('Error checking key existence: $e');
      return false;
    }
  }
  
  // Get all keys
  static Future<Map<String, String>> getAll() async {
    try {
      final allData = await _storage.readAll();
      if (kDebugMode) print('Retrieved all secure data: ${allData.keys.length} keys');
      return allData;
    } catch (e) {
      if (kDebugMode) print('Error retrieving all secure data: $e');
      return {};
    }
  }
  
  // Store PIN
  static Future<void> storePIN(String pin) async {
    await store('user_pin', pin);
  }
  
  // Retrieve PIN
  static Future<String?> retrievePIN() async {
    return await retrieve('user_pin');
  }
  
  // Store biometric preference
  static Future<void> storeBiometricPreference(bool enabled) async {
    await store('biometric_enabled', enabled.toString());
  }
  
  // Retrieve biometric preference
  static Future<bool> retrieveBiometricPreference() async {
    final value = await retrieve('biometric_enabled');
    return value == 'true';
  }
  
  // Store encryption key
  static Future<void> storeEncryptionKey(String key) async {
    await store('encryption_key', key);
  }
  
  // Retrieve encryption key
  static Future<String?> retrieveEncryptionKey() async {
    return await retrieve('encryption_key');
  }
  
  // Store vault settings
  static Future<void> storeVaultSettings({
    required bool autoLock,
    required int autoLockMinutes,
    required bool showDecoy,
  }) async {
    await store('vault_auto_lock', autoLock.toString());
    await store('vault_auto_lock_minutes', autoLockMinutes.toString());
    await store('vault_show_decoy', showDecoy.toString());
  }
  
  // Retrieve vault settings
  static Future<Map<String, dynamic>> retrieveVaultSettings() async {
    final autoLock = await retrieve('vault_auto_lock');
    final autoLockMinutes = await retrieve('vault_auto_lock_minutes');
    final showDecoy = await retrieve('vault_show_decoy');
    
    return {
      'autoLock': autoLock == 'true',
      'autoLockMinutes': int.tryParse(autoLockMinutes ?? '5') ?? 5,
      'showDecoy': showDecoy == 'true',
    };
  }
  
  // Store TTS settings
  static Future<void> storeTTSSettings({
    required String voice,
    required double speed,
    required double pitch,
    required double volume,
  }) async {
    await store('tts_voice', voice);
    await store('tts_speed', speed.toString());
    await store('tts_pitch', pitch.toString());
    await store('tts_volume', volume.toString());
  }
  
  // Retrieve TTS settings
  static Future<Map<String, dynamic>> retrieveTTSSettings() async {
    final voice = await retrieve('tts_voice');
    final speed = await retrieve('tts_speed');
    final pitch = await retrieve('tts_pitch');
    final volume = await retrieve('tts_volume');
    
    return {
      'voice': voice ?? 'default',
      'speed': double.tryParse(speed ?? '1.0') ?? 1.0,
      'pitch': double.tryParse(pitch ?? '1.0') ?? 1.0,
      'volume': double.tryParse(volume ?? '1.0') ?? 1.0,
    };
  }
  
  // Store theme settings
  static Future<void> storeThemeSettings({
    required String themeName,
    required bool isDarkMode,
  }) async {
    await store('theme_name', themeName);
    await store('is_dark_mode', isDarkMode.toString());
  }
  
  // Retrieve theme settings
  static Future<Map<String, dynamic>> retrieveThemeSettings() async {
    final themeName = await retrieve('theme_name');
    final isDarkMode = await retrieve('is_dark_mode');
    
    return {
      'themeName': themeName ?? 'normal',
      'isDarkMode': isDarkMode == 'true',
    };
  }
  
  // Store app settings
  static Future<void> storeAppSettings({
    required bool hapticFeedback,
    required bool soundEffects,
    required bool autoSave,
    required String defaultCalculator,
  }) async {
    await store('haptic_feedback', hapticFeedback.toString());
    await store('sound_effects', soundEffects.toString());
    await store('auto_save', autoSave.toString());
    await store('default_calculator', defaultCalculator);
  }
  
  // Retrieve app settings
  static Future<Map<String, dynamic>> retrieveAppSettings() async {
    final hapticFeedback = await retrieve('haptic_feedback');
    final soundEffects = await retrieve('sound_effects');
    final autoSave = await retrieve('auto_save');
    final defaultCalculator = await retrieve('default_calculator');
    
    return {
      'hapticFeedback': hapticFeedback == 'true',
      'soundEffects': soundEffects == 'true',
      'autoSave': autoSave == 'true',
      'defaultCalculator': defaultCalculator ?? 'basic',
    };
  }
}
