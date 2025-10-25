import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'services/storage_service.dart';
import 'services/performance_service.dart';
import 'services/memory_service.dart';
import 'services/resource_service.dart';
import 'ui/screens/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/performance_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage services
  await StorageService.initialize();
  
  // Initialize performance monitoring services
  PerformanceService.initialize();
  MemoryService.initialize();
  ResourceService.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    const ProviderScope(
      child: CalcMasterApp(),
    ),
  );
}

class CalcMasterApp extends ConsumerWidget {
  const CalcMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeProvider);
    final themeData = ref.watch(themeDataProvider);
    
    return ThemeProvider(
      initTheme: themeData,
      duration: Duration(milliseconds: themeConfig.animationDuration.toInt()),
      builder: (context, theme) {
        return MaterialApp(
          title: 'CalcMaster',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0), // Disable text scaling
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
