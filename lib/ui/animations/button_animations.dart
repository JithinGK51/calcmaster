import 'package:flutter/material.dart';

class ButtonAnimations {
  // Scale animation for button press
  static Widget scaleAnimation({
    required Widget child,
    required VoidCallback onPressed,
    double scale = 0.95,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return _ScaleAnimation(
      scale: scale,
      duration: duration,
      onPressed: onPressed,
      child: child,
    );
  }

  // Bounce animation for button press
  static Widget bounceAnimation({
    required Widget child,
    required VoidCallback onPressed,
    double scale = 0.9,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return _BounceAnimation(
      scale: scale,
      duration: duration,
      onPressed: onPressed,
      child: child,
    );
  }

  // Pulse animation for button press
  static Widget pulseAnimation({
    required Widget child,
    required VoidCallback onPressed,
    double scale = 1.1,
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return _PulseAnimation(
      scale: scale,
      duration: duration,
      onPressed: onPressed,
      child: child,
    );
  }

  // Shake animation for button press
  static Widget shakeAnimation({
    required Widget child,
    required VoidCallback onPressed,
    double offset = 10.0,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return _ShakeAnimation(
      offset: offset,
      duration: duration,
      onPressed: onPressed,
      child: child,
    );
  }

  // Ripple animation for button press
  static Widget rippleAnimation({
    required Widget child,
    required VoidCallback onPressed,
    Color rippleColor = Colors.white,
    double radius = 20.0,
  }) {
    return _RippleAnimation(
      rippleColor: rippleColor,
      radius: radius,
      onPressed: onPressed,
      child: child,
    );
  }

  // Glow animation for button press
  static Widget glowAnimation({
    required Widget child,
    required VoidCallback onPressed,
    Color glowColor = Colors.blue,
    double blurRadius = 10.0,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return _GlowAnimation(
      glowColor: glowColor,
      blurRadius: blurRadius,
      duration: duration,
      onPressed: onPressed,
      child: child,
    );
  }

  // Custom calculator button animation
  static Widget calculatorButtonAnimation({
    required Widget child,
    required VoidCallback onPressed,
    bool isOperator = false,
    bool isFunction = false,
  }) {
    if (isOperator) {
      return glowAnimation(
        onPressed: onPressed,
        glowColor: Colors.orange,
        child: child,
      );
    } else if (isFunction) {
      return pulseAnimation(
        onPressed: onPressed,
        child: child,
      );
    } else {
      return scaleAnimation(
        onPressed: onPressed,
        child: child,
      );
    }
  }
}

class _ScaleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scale;
  final Duration duration;

  const _ScaleAnimation({
    required this.child,
    required this.onPressed,
    required this.scale,
    required this.duration,
  });

  @override
  State<_ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<_ScaleAnimation>
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
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _BounceAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scale;
  final Duration duration;

  const _BounceAnimation({
    required this.child,
    required this.onPressed,
    required this.scale,
    required this.duration,
  });

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation>
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
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scale;
  final Duration duration;

  const _PulseAnimation({
    required this.child,
    required this.onPressed,
    required this.scale,
    required this.duration,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
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
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double offset;
  final Duration duration;

  const _ShakeAnimation({
    required this.child,
    required this.onPressed,
    required this.offset,
    required this.duration,
  });

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
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
      end: widget.offset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _RippleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color rippleColor;
  final double radius;

  const _RippleAnimation({
    required this.child,
    required this.onPressed,
    required this.rippleColor,
    required this.radius,
  });

  @override
  State<_RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<_RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.radius,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.rippleColor.withOpacity(0.3),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _GlowAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color glowColor;
  final double blurRadius;
  final Duration duration;

  const _GlowAnimation({
    required this.child,
    required this.onPressed,
    required this.glowColor,
    required this.blurRadius,
    required this.duration,
  });

  @override
  State<_GlowAnimation> createState() => _GlowAnimationState();
}

class _GlowAnimationState extends State<_GlowAnimation>
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
      end: widget.blurRadius,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.5),
                  blurRadius: _animation.value,
                  spreadRadius: _animation.value * 0.5,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
