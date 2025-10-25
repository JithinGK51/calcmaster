import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/theme_model.dart';
import 'theme_constants.dart';

class AppThemeData {
  static ThemeData getTheme(AppTheme theme, {ThemeConfig? config}) {
    final colors = ThemeConstants.getThemeColors(theme);
    
    switch (theme) {
      case AppTheme.normal:
        return _buildNormalTheme(colors);
      case AppTheme.light:
        return _buildLightTheme(colors);
      case AppTheme.dark:
        return _buildDarkTheme(colors);
      case AppTheme.kali:
        return _buildKaliTheme(colors);
      case AppTheme.hacker:
        return _buildHackerTheme(colors);
      case AppTheme.study:
        return _buildStudyTheme(colors);
      case AppTheme.kids:
        return _buildKidsTheme(colors);
      case AppTheme.glass:
        return _buildGlassTheme(colors);
      case AppTheme.cyberpunk:
        return _buildCyberpunkTheme(colors);
      case AppTheme.nature:
        return _buildNatureTheme(colors);
      case AppTheme.galaxy:
        return _buildGalaxyTheme(colors);
      case AppTheme.retroPixel:
        return _buildRetroPixelTheme(colors);
      case AppTheme.custom:
        return _buildCustomTheme(colors, config);
    }
  }

  static ThemeData _buildNormalTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.light,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 4,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData _buildLightTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.light,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData _buildDarkTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['surface'],
        foregroundColor: colors['onSurface'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData _buildKaliTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['background'],
        foregroundColor: colors['onBackground'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colors['primary']!, width: 1),
        ),
      ),
    );
  }

  static ThemeData _buildHackerTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['background'],
        foregroundColor: colors['onBackground'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData _buildStudyTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.light,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 2,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData _buildKidsTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.light,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 4,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  static ThemeData _buildGlassTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['surface'],
        foregroundColor: colors['onSurface'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData _buildCyberpunkTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['background'],
        foregroundColor: colors['onBackground'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors['primary']!, width: 1),
        ),
      ),
    );
  }

  static ThemeData _buildNatureTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.light,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: colors['onPrimary'],
        elevation: 2,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData _buildGalaxyTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['surface'],
        foregroundColor: colors['onSurface'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData _buildRetroPixelTheme(Map<String, Color> colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors['primary']!,
        brightness: Brightness.dark,
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['background'],
        foregroundColor: colors['onBackground'],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colors['primary']!, width: 2),
        ),
      ),
    );
  }

  static ThemeData _buildCustomTheme(Map<String, Color> colors, ThemeConfig? config) {
    // Use custom colors from config if available
    final primaryColor = config?.customPrimaryColor != null
        ? Color(int.parse(config!.customPrimaryColor!.replaceFirst('#', '0xff')))
        : colors['primary']!;
    
    final secondaryColor = config?.customSecondaryColor != null
        ? Color(int.parse(config!.customSecondaryColor!.replaceFirst('#', '0xff')))
        : colors['secondary']!;
    
    final accentColor = config?.customAccentColor != null
        ? Color(int.parse(config!.customAccentColor!.replaceFirst('#', '0xff')))
        : colors['accent']!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: colors['onPrimary'],
        elevation: 4,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: colors['onPrimary'],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
