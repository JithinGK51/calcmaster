import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/theme_model.dart';
import '../services/storage_service.dart';
import '../ui/themes/theme_data.dart';

class ThemeNotifier extends StateNotifier<ThemeConfig> {
  ThemeNotifier() : super(ThemeConfig()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = StorageService.getThemeConfig();
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  Future<void> changeTheme(AppTheme theme) async {
    state = state.copyWith(currentTheme: theme);
    await StorageService.saveThemeConfig(state);
  }

  Future<void> updateCustomColors({
    String? primaryColor,
    String? secondaryColor,
    String? accentColor,
  }) async {
    state = state.copyWith(
      customPrimaryColor: primaryColor,
      customSecondaryColor: secondaryColor,
      customAccentColor: accentColor,
    );
    await StorageService.saveThemeConfig(state);
  }

  Future<void> setAnimationDuration(double duration) async {
    state = state.copyWith(animationDuration: duration);
    await StorageService.saveThemeConfig(state);
  }

  Future<void> toggleSystemTheme() async {
    state = state.copyWith(useSystemTheme: !state.useSystemTheme);
    await StorageService.saveThemeConfig(state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeConfig>((ref) {
  return ThemeNotifier();
});

final currentThemeProvider = Provider<AppTheme>((ref) {
  return ref.watch(themeProvider).currentTheme;
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final themeConfig = ref.watch(themeProvider);
  return AppThemeData.getTheme(themeConfig.currentTheme, config: themeConfig);
});
