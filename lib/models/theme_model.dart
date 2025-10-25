import 'package:hive/hive.dart';

part 'theme_model.g.dart';

@HiveType(typeId: 0)
enum AppTheme {
  @HiveField(0)
  normal,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
  @HiveField(3)
  kali,
  @HiveField(4)
  hacker,
  @HiveField(5)
  study,
  @HiveField(6)
  kids,
  @HiveField(7)
  glass,
  @HiveField(8)
  cyberpunk,
  @HiveField(9)
  nature,
  @HiveField(10)
  galaxy,
  @HiveField(11)
  retroPixel,
  @HiveField(12)
  custom,
}

@HiveType(typeId: 1)
class ThemeConfig extends HiveObject {
  @HiveField(0)
  AppTheme currentTheme;

  @HiveField(1)
  String? customPrimaryColor;

  @HiveField(2)
  String? customSecondaryColor;

  @HiveField(3)
  String? customAccentColor;

  @HiveField(4)
  bool useSystemTheme;

  @HiveField(5)
  double animationDuration;

  ThemeConfig({
    this.currentTheme = AppTheme.normal,
    this.customPrimaryColor,
    this.customSecondaryColor,
    this.customAccentColor,
    this.useSystemTheme = false,
    this.animationDuration = 300.0,
  });

  ThemeConfig copyWith({
    AppTheme? currentTheme,
    String? customPrimaryColor,
    String? customSecondaryColor,
    String? customAccentColor,
    bool? useSystemTheme,
    double? animationDuration,
  }) {
    return ThemeConfig(
      currentTheme: currentTheme ?? this.currentTheme,
      customPrimaryColor: customPrimaryColor ?? this.customPrimaryColor,
      customSecondaryColor: customSecondaryColor ?? this.customSecondaryColor,
      customAccentColor: customAccentColor ?? this.customAccentColor,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
