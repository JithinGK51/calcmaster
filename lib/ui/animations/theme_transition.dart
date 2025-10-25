import 'package:flutter/material.dart';

class ThemeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ThemeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ThemeTransition> createState() => _ThemeTransitionState();
}

class _ThemeTransitionState extends State<ThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ThemeColorTransition extends StatefulWidget {
  final Widget child;
  final Color fromColor;
  final Color toColor;
  final Duration duration;
  final Curve curve;

  const ThemeColorTransition({
    super.key,
    required this.child,
    required this.fromColor,
    required this.toColor,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ThemeColorTransition> createState() => _ThemeColorTransitionState();
}

class _ThemeColorTransitionState extends State<ThemeColorTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: widget.fromColor,
      end: widget.toColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: _colorAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

class ThemeGradientTransition extends StatefulWidget {
  final Widget child;
  final List<Color> fromColors;
  final List<Color> toColors;
  final Duration duration;
  final Curve curve;
  final Alignment begin;
  final Alignment end;

  const ThemeGradientTransition({
    super.key,
    required this.child,
    required this.fromColors,
    required this.toColors,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  State<ThemeGradientTransition> createState() => _ThemeGradientTransitionState();
}

class _ThemeGradientTransitionState extends State<ThemeGradientTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: [
                Color.lerp(widget.fromColors[0], widget.toColors[0], _animation.value)!,
                Color.lerp(widget.fromColors[1], widget.toColors[1], _animation.value)!,
                if (widget.fromColors.length > 2 && widget.toColors.length > 2)
                  Color.lerp(widget.fromColors[2], widget.toColors[2], _animation.value)!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class ThemeSlideTransition extends StatefulWidget {
  final Widget child;
  final Offset fromOffset;
  final Offset toOffset;
  final Duration duration;
  final Curve curve;

  const ThemeSlideTransition({
    super.key,
    required this.child,
    this.fromOffset = const Offset(1.0, 0.0),
    this.toOffset = Offset.zero,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ThemeSlideTransition> createState() => _ThemeSlideTransitionState();
}

class _ThemeSlideTransitionState extends State<ThemeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.fromOffset,
      end: widget.toOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ThemeRotationTransition extends StatefulWidget {
  final Widget child;
  final double fromRotation;
  final double toRotation;
  final Duration duration;
  final Curve curve;

  const ThemeRotationTransition({
    super.key,
    required this.child,
    this.fromRotation = 0.0,
    this.toRotation = 1.0,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ThemeRotationTransition> createState() => _ThemeRotationTransitionState();
}

class _ThemeRotationTransitionState extends State<ThemeRotationTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: widget.fromRotation,
      end: widget.toRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RotationTransition(
          turns: _rotationAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class ThemeMorphTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ThemeMorphTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ThemeMorphTransition> createState() => _ThemeMorphTransitionState();
}

class _ThemeMorphTransitionState extends State<ThemeMorphTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: widget.curve),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.8, curve: widget.curve),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.4, curve: widget.curve),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
