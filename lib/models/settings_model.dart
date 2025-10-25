import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 17)
enum AngleMode {
  @HiveField(0)
  degrees,
  @HiveField(1)
  radians,
}

@HiveType(typeId: 18)
enum CalculatorMode {
  @HiveField(0)
  basic,
  @HiveField(1)
  scientific,
}

@HiveType(typeId: 19)
class AppSettings extends HiveObject {
  @HiveField(0)
  CalculatorMode defaultCalculatorMode;

  @HiveField(1)
  AngleMode angleMode;

  @HiveField(2)
  int decimalPlaces;

  @HiveField(3)
  bool autoSaveHistory;

  @HiveField(4)
  bool hapticFeedback;

  @HiveField(5)
  bool soundEffects;

  @HiveField(6)
  bool showTutorial;

  @HiveField(7)
  String language;

  @HiveField(8)
  bool biometricEnabled;

  @HiveField(9)
  bool autoLockEnabled;

  @HiveField(10)
  int autoLockTimeout;

  @HiveField(11)
  bool notificationsEnabled;

  @HiveField(12)
  bool dataBackupEnabled;

  @HiveField(13)
  DateTime? lastBackupDate;

  @HiveField(14)
  Map<String, dynamic> customSettings;

  AppSettings({
    this.defaultCalculatorMode = CalculatorMode.basic,
    this.angleMode = AngleMode.degrees,
    this.decimalPlaces = 2,
    this.autoSaveHistory = true,
    this.hapticFeedback = true,
    this.soundEffects = true,
    this.showTutorial = true,
    this.language = 'en',
    this.biometricEnabled = false,
    this.autoLockEnabled = true,
    this.autoLockTimeout = 5, // minutes
    this.notificationsEnabled = true,
    this.dataBackupEnabled = false,
    this.lastBackupDate,
    this.customSettings = const {},
  });

  AppSettings copyWith({
    CalculatorMode? defaultCalculatorMode,
    AngleMode? angleMode,
    int? decimalPlaces,
    bool? autoSaveHistory,
    bool? hapticFeedback,
    bool? soundEffects,
    bool? showTutorial,
    String? language,
    bool? biometricEnabled,
    bool? autoLockEnabled,
    int? autoLockTimeout,
    bool? notificationsEnabled,
    bool? dataBackupEnabled,
    DateTime? lastBackupDate,
    Map<String, dynamic>? customSettings,
  }) {
    return AppSettings(
      defaultCalculatorMode: defaultCalculatorMode ?? this.defaultCalculatorMode,
      angleMode: angleMode ?? this.angleMode,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      autoSaveHistory: autoSaveHistory ?? this.autoSaveHistory,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      showTutorial: showTutorial ?? this.showTutorial,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockEnabled: autoLockEnabled ?? this.autoLockEnabled,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dataBackupEnabled: dataBackupEnabled ?? this.dataBackupEnabled,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      customSettings: customSettings ?? this.customSettings,
    );
  }
}
