import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial());

  void updateTheme(String themeName) {
    state = state.copyWith(themeName: themeName);
  }

  void updateTTSVoice(String voice) {
    state = state.copyWith(ttsVoice: voice);
  }

  void updateTTSSpeed(double speed) {
    state = state.copyWith(ttsSpeed: speed);
  }

  void updateTTSPitch(double pitch) {
    state = state.copyWith(ttsPitch: pitch);
  }

  void updateTTSVolume(double volume) {
    state = state.copyWith(ttsVolume: volume);
  }

  void updateTTSEnabled(bool enabled) {
    state = state.copyWith(ttsEnabled: enabled);
  }

  void updateHapticFeedback(bool enabled) {
    state = state.copyWith(hapticFeedback: enabled);
  }

  void updateSoundEffects(bool enabled) {
    state = state.copyWith(soundEffects: enabled);
  }

  void updateAutoSave(bool enabled) {
    state = state.copyWith(autoSave: enabled);
  }

  void updateDefaultCalculator(String calculator) {
    state = state.copyWith(defaultCalculator: calculator);
  }

  void updateAngleMode(String angleMode) {
    state = state.copyWith(angleMode: angleMode);
  }

  void updateDecimalPlaces(int decimalPlaces) {
    state = state.copyWith(decimalPlaces: decimalPlaces);
  }

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void updateVaultPIN(String pin) {
    state = state.copyWith(vaultPIN: pin);
  }

  void updateVaultBiometricEnabled(bool enabled) {
    state = state.copyWith(vaultBiometricEnabled: enabled);
  }

  void updateVaultPattern(String pattern) {
    state = state.copyWith(vaultPattern: pattern);
  }

  void updateVaultDecoyPIN(String decoyPin) {
    state = state.copyWith(vaultDecoyPIN: decoyPin);
  }

  void updateVaultAutoLock(bool autoLock) {
    state = state.copyWith(vaultAutoLock: autoLock);
  }

  void updateVaultAutoLockMinutes(int minutes) {
    state = state.copyWith(vaultAutoLockMinutes: minutes);
  }

  void updateVaultShowDecoy(bool showDecoy) {
    state = state.copyWith(vaultShowDecoy: showDecoy);
  }

  void updateNotificationEnabled(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void updateNotificationSound(bool enabled) {
    state = state.copyWith(notificationSound: enabled);
  }

  void updateNotificationVibration(bool enabled) {
    state = state.copyWith(notificationVibration: enabled);
  }

  void updateDataBackup(bool enabled) {
    state = state.copyWith(dataBackup: enabled);
  }

  void updateDataSync(bool enabled) {
    state = state.copyWith(dataSync: enabled);
  }

  void updatePrivacyMode(bool enabled) {
    state = state.copyWith(privacyMode: enabled);
  }

  void updateAnalyticsEnabled(bool enabled) {
    state = state.copyWith(analyticsEnabled: enabled);
  }

  void updateCrashReporting(bool enabled) {
    state = state.copyWith(crashReporting: enabled);
  }

  void updateAutoUpdate(bool enabled) {
    state = state.copyWith(autoUpdate: enabled);
  }

  void updateBetaFeatures(bool enabled) {
    state = state.copyWith(betaFeatures: enabled);
  }

  void updateDeveloperMode(bool enabled) {
    state = state.copyWith(developerMode: enabled);
  }

  void resetToDefaults() {
    state = SettingsState.initial();
  }

  void resetThemeSettings() {
    state = state.copyWith(
      themeName: 'normal',
      ttsVoice: 'default',
      ttsSpeed: 1.0,
      ttsPitch: 1.0,
      ttsVolume: 1.0,
      ttsEnabled: false,
    );
  }

  void resetVaultSettings() {
    state = state.copyWith(
      vaultPIN: '',
      vaultBiometricEnabled: false,
      vaultPattern: '',
      vaultDecoyPIN: '',
      vaultAutoLock: true,
      vaultAutoLockMinutes: 5,
      vaultShowDecoy: false,
    );
  }

  void resetNotificationSettings() {
    state = state.copyWith(
      notificationsEnabled: true,
      notificationSound: true,
      notificationVibration: true,
    );
  }

  void resetPrivacySettings() {
    state = state.copyWith(
      privacyMode: false,
      analyticsEnabled: true,
      crashReporting: true,
      dataBackup: false,
      dataSync: false,
    );
  }

  Map<String, dynamic> getSettingsSummary() {
    return {
      'theme': state.themeName,
      'ttsEnabled': state.ttsEnabled,
      'hapticFeedback': state.hapticFeedback,
      'soundEffects': state.soundEffects,
      'autoSave': state.autoSave,
      'defaultCalculator': state.defaultCalculator,
      'angleMode': state.angleMode,
      'decimalPlaces': state.decimalPlaces,
      'language': state.language,
      'vaultSecured': state.vaultPIN.isNotEmpty,
      'vaultBiometric': state.vaultBiometricEnabled,
      'notificationsEnabled': state.notificationsEnabled,
      'privacyMode': state.privacyMode,
      'analyticsEnabled': state.analyticsEnabled,
    };
  }

  Map<String, dynamic> getVaultSecuritySummary() {
    return {
      'hasPIN': state.vaultPIN.isNotEmpty,
      'hasBiometric': state.vaultBiometricEnabled,
      'hasPattern': state.vaultPattern.isNotEmpty,
      'hasDecoyPIN': state.vaultDecoyPIN.isNotEmpty,
      'autoLock': state.vaultAutoLock,
      'autoLockMinutes': state.vaultAutoLockMinutes,
      'showDecoy': state.vaultShowDecoy,
    };
  }

  Map<String, dynamic> getTTSSummary() {
    return {
      'enabled': state.ttsEnabled,
      'voice': state.ttsVoice,
      'speed': state.ttsSpeed,
      'pitch': state.ttsPitch,
      'volume': state.ttsVolume,
    };
  }

  Map<String, dynamic> getNotificationSummary() {
    return {
      'enabled': state.notificationsEnabled,
      'sound': state.notificationSound,
      'vibration': state.notificationVibration,
    };
  }

  Map<String, dynamic> getPrivacySummary() {
    return {
      'privacyMode': state.privacyMode,
      'analyticsEnabled': state.analyticsEnabled,
      'crashReporting': state.crashReporting,
      'dataBackup': state.dataBackup,
      'dataSync': state.dataSync,
    };
  }

  bool hasUnsavedChanges() {
    // This would compare current state with saved state
    // For now, we'll return false
    return false;
  }

  void saveSettings() {
    // This would save settings to persistent storage
    // Implementation would depend on the storage service
  }

  void loadSettings() {
    // This would load settings from persistent storage
    // Implementation would depend on the storage service
  }
}

class SettingsState {
  // Theme settings
  final String themeName;
  final String ttsVoice;
  final double ttsSpeed;
  final double ttsPitch;
  final double ttsVolume;
  final bool ttsEnabled;

  // UI settings
  final bool hapticFeedback;
  final bool soundEffects;
  final bool autoSave;
  final String defaultCalculator;
  final String angleMode;
  final int decimalPlaces;
  final String language;

  // Vault settings
  final String vaultPIN;
  final bool vaultBiometricEnabled;
  final String vaultPattern;
  final String vaultDecoyPIN;
  final bool vaultAutoLock;
  final int vaultAutoLockMinutes;
  final bool vaultShowDecoy;

  // Notification settings
  final bool notificationsEnabled;
  final bool notificationSound;
  final bool notificationVibration;

  // Privacy settings
  final bool privacyMode;
  final bool analyticsEnabled;
  final bool crashReporting;
  final bool dataBackup;
  final bool dataSync;

  // Advanced settings
  final bool autoUpdate;
  final bool betaFeatures;
  final bool developerMode;

  // State
  final bool isLoading;
  final String? error;

  const SettingsState({
    required this.themeName,
    required this.ttsVoice,
    required this.ttsSpeed,
    required this.ttsPitch,
    required this.ttsVolume,
    required this.ttsEnabled,
    required this.hapticFeedback,
    required this.soundEffects,
    required this.autoSave,
    required this.defaultCalculator,
    required this.angleMode,
    required this.decimalPlaces,
    required this.language,
    required this.vaultPIN,
    required this.vaultBiometricEnabled,
    required this.vaultPattern,
    required this.vaultDecoyPIN,
    required this.vaultAutoLock,
    required this.vaultAutoLockMinutes,
    required this.vaultShowDecoy,
    required this.notificationsEnabled,
    required this.notificationSound,
    required this.notificationVibration,
    required this.privacyMode,
    required this.analyticsEnabled,
    required this.crashReporting,
    required this.dataBackup,
    required this.dataSync,
    required this.autoUpdate,
    required this.betaFeatures,
    required this.developerMode,
    required this.isLoading,
    this.error,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      themeName: 'normal',
      ttsVoice: 'default',
      ttsSpeed: 1.0,
      ttsPitch: 1.0,
      ttsVolume: 1.0,
      ttsEnabled: false,
      hapticFeedback: true,
      soundEffects: true,
      autoSave: true,
      defaultCalculator: 'basic',
      angleMode: 'degrees',
      decimalPlaces: 2,
      language: 'en',
      vaultPIN: '',
      vaultBiometricEnabled: false,
      vaultPattern: '',
      vaultDecoyPIN: '',
      vaultAutoLock: true,
      vaultAutoLockMinutes: 5,
      vaultShowDecoy: false,
      notificationsEnabled: true,
      notificationSound: true,
      notificationVibration: true,
      privacyMode: false,
      analyticsEnabled: true,
      crashReporting: true,
      dataBackup: false,
      dataSync: false,
      autoUpdate: true,
      betaFeatures: false,
      developerMode: false,
      isLoading: false,
      error: null,
    );
  }

  SettingsState copyWith({
    String? themeName,
    String? ttsVoice,
    double? ttsSpeed,
    double? ttsPitch,
    double? ttsVolume,
    bool? ttsEnabled,
    bool? hapticFeedback,
    bool? soundEffects,
    bool? autoSave,
    String? defaultCalculator,
    String? angleMode,
    int? decimalPlaces,
    String? language,
    String? vaultPIN,
    bool? vaultBiometricEnabled,
    String? vaultPattern,
    String? vaultDecoyPIN,
    bool? vaultAutoLock,
    int? vaultAutoLockMinutes,
    bool? vaultShowDecoy,
    bool? notificationsEnabled,
    bool? notificationSound,
    bool? notificationVibration,
    bool? privacyMode,
    bool? analyticsEnabled,
    bool? crashReporting,
    bool? dataBackup,
    bool? dataSync,
    bool? autoUpdate,
    bool? betaFeatures,
    bool? developerMode,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      themeName: themeName ?? this.themeName,
      ttsVoice: ttsVoice ?? this.ttsVoice,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      ttsPitch: ttsPitch ?? this.ttsPitch,
      ttsVolume: ttsVolume ?? this.ttsVolume,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      autoSave: autoSave ?? this.autoSave,
      defaultCalculator: defaultCalculator ?? this.defaultCalculator,
      angleMode: angleMode ?? this.angleMode,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      language: language ?? this.language,
      vaultPIN: vaultPIN ?? this.vaultPIN,
      vaultBiometricEnabled: vaultBiometricEnabled ?? this.vaultBiometricEnabled,
      vaultPattern: vaultPattern ?? this.vaultPattern,
      vaultDecoyPIN: vaultDecoyPIN ?? this.vaultDecoyPIN,
      vaultAutoLock: vaultAutoLock ?? this.vaultAutoLock,
      vaultAutoLockMinutes: vaultAutoLockMinutes ?? this.vaultAutoLockMinutes,
      vaultShowDecoy: vaultShowDecoy ?? this.vaultShowDecoy,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationSound: notificationSound ?? this.notificationSound,
      notificationVibration: notificationVibration ?? this.notificationVibration,
      privacyMode: privacyMode ?? this.privacyMode,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReporting: crashReporting ?? this.crashReporting,
      dataBackup: dataBackup ?? this.dataBackup,
      dataSync: dataSync ?? this.dataSync,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      betaFeatures: betaFeatures ?? this.betaFeatures,
      developerMode: developerMode ?? this.developerMode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
