import 'package:flutter/material.dart';

class PageTransitions {
  // Slide transition from right
  static Widget slideFromRight(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }

  // Slide transition from left
  static Widget slideFromLeft(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }

  // Slide transition from bottom
  static Widget slideFromBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }

  // Slide transition from top
  static Widget slideFromTop(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }

  // Fade transition
  static Widget fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  // Scale transition
  static Widget scaleTransition(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      )),
      child: child,
    );
  }

  // Rotation transition
  static Widget rotationTransition(Widget child, Animation<double> animation) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }

  // Combined slide and fade
  static Widget slideAndFade(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  }

  // Combined scale and fade
  static Widget scaleAndFade(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  }

  // Custom transition for calculator screens
  static Widget calculatorTransition(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  }

  // Custom transition for modal dialogs
  static Widget modalTransition(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  }

  // Custom transition for theme changes
  static Widget themeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }
}

// Custom page route with transition
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final String transitionType;
  final Duration duration;

  CustomPageRoute({
    required this.child,
    this.transitionType = 'slideFromRight',
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (transitionType) {
              case 'slideFromLeft':
                return PageTransitions.slideFromLeft(child, animation);
              case 'slideFromBottom':
                return PageTransitions.slideFromBottom(child, animation);
              case 'slideFromTop':
                return PageTransitions.slideFromTop(child, animation);
              case 'fade':
                return PageTransitions.fadeTransition(child, animation);
              case 'scale':
                return PageTransitions.scaleTransition(child, animation);
              case 'rotation':
                return PageTransitions.rotationTransition(child, animation);
              case 'slideAndFade':
                return PageTransitions.slideAndFade(child, animation);
              case 'scaleAndFade':
                return PageTransitions.scaleAndFade(child, animation);
              case 'calculator':
                return PageTransitions.calculatorTransition(child, animation);
              case 'modal':
                return PageTransitions.modalTransition(child, animation);
              case 'theme':
                return PageTransitions.themeTransition(child, animation);
              default:
                return PageTransitions.slideFromRight(child, animation);
            }
          },
        );
}

// Custom page route for theme transitions
class ThemePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  ThemePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransitions.themeTransition(child, animation);
          },
        );
}

// Custom page route for modal dialogs
class ModalPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  ModalPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransitions.modalTransition(child, animation);
          },
        );
}
