import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set system UI overlay style for full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));
    
    _startAnimations();
  }

  void _startAnimations() async {
    // Start background animation immediately
    _backgroundController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _textController.forward();
    
    // Add haptic feedback
    await Future.delayed(const Duration(milliseconds: 500));
    HapticFeedback.lightImpact();
    
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateToMain();
  }

  void _navigateToMain() {
    // Restore system UI before navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    // Restore system UI in case of early disposal
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                  theme.colorScheme.tertiary ?? theme.colorScheme.primary,
                ],
                stops: [
                  0.0,
                  0.5 + (_backgroundAnimation.value * 0.3),
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(20, (index) {
                  return Positioned(
                    left: (index * 50.0) % size.width,
                    top: (index * 30.0) % size.height,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onPrimary.withOpacity(
                          0.1 + (_backgroundAnimation.value * 0.2),
                        ),
                      ),
                    ).animate().fadeIn(
                      duration: (1000 + index * 100).ms,
                      delay: (index * 200).ms,
                    ).scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                    ),
                  );
                }),
                
                // Main content with proper padding for status bar
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      
                      // Enhanced Logo Animation
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: Transform.rotate(
                              angle: _logoAnimation.value * 0.1,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withOpacity(0.4),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                    BoxShadow(
                                      color: theme.colorScheme.secondary.withOpacity(0.2),
                                      blurRadius: 50,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Calculator icon
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Icon(
                                        Icons.calculate_rounded,
                                        size: 70,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ).animate().rotate(
                                      duration: 2000.ms,
                                      curve: Curves.easeInOut,
                                    ),
                                    
                                    // Pulsing ring
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                    ).animate().scale(
                                      duration: 2000.ms,
                                      curve: Curves.easeInOut,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Enhanced App Name Animation
                      SlideTransition(
                        position: _slideAnimation,
                        child: AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textAnimation.value,
                              child: Column(
                                children: [
                                  Text(
                                    'CalcMaster',
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                      shadows: [
                                        Shadow(
                                          color: theme.colorScheme.primary.withOpacity(0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ).animate().fadeIn(
                                    duration: 1000.ms,
                                    delay: 500.ms,
                                  ).slideY(
                                    begin: 0.3,
                                    end: 0,
                                    curve: Curves.easeOutBack,
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  Text(
                                    'Ultimate Calculator Hub',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ).animate().fadeIn(
                                    duration: 800.ms,
                                    delay: 800.ms,
                                  ).slideY(
                                    begin: 0.2,
                                    end: 0,
                                    curve: Curves.easeOut,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const Spacer(flex: 2),
                      
                      // Enhanced Loading Indicator
                      Column(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.onPrimary,
                                  ),
                                  strokeWidth: 4,
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(
                            duration: 1000.ms,
                            delay: 1500.ms,
                          ).scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1, 1),
                            curve: Curves.elasticOut,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Loading text
                          Text(
                            'Loading...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(0.7),
                              letterSpacing: 1,
                            ),
                          ).animate().fadeIn(
                            duration: 500.ms,
                            delay: 2000.ms,
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Version Text with enhanced styling
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.onPrimary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Version 1.0.0',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          ).animate().fadeIn(
                            duration: 800.ms,
                            delay: 2500.ms,
                          ).slideY(
                            begin: 0.3,
                            end: 0,
                            curve: Curves.easeOut,
                          ),
                        ],
                      ),
                      
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}