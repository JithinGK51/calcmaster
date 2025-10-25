import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CalculatorButtonType {
  number,
  operator,
  function,
  memory,
  scientific,
}

class CalculatorButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final CalculatorButtonType buttonType;
  final ThemeData theme;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonType,
    required this.theme,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: _getButtonColor(),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _getButtonColor().withOpacity(0.3),
                      blurRadius: _isPressed ? 2 : 8,
                      spreadRadius: _isPressed ? 1 : 2,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: _getTextColor(),
                      fontSize: _getFontSize(),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calculator',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getButtonColor() {
    switch (widget.buttonType) {
      case CalculatorButtonType.number:
        return widget.theme.colorScheme.surface;
      case CalculatorButtonType.operator:
        return widget.theme.colorScheme.primary;
      case CalculatorButtonType.function:
        return widget.theme.colorScheme.secondary;
      case CalculatorButtonType.memory:
        return widget.theme.colorScheme.tertiary ?? widget.theme.colorScheme.secondary;
      case CalculatorButtonType.scientific:
        return widget.theme.colorScheme.primaryContainer;
    }
  }

  Color _getTextColor() {
    switch (widget.buttonType) {
      case CalculatorButtonType.number:
        return widget.theme.colorScheme.onSurface;
      case CalculatorButtonType.operator:
        return widget.theme.colorScheme.onPrimary;
      case CalculatorButtonType.function:
        return widget.theme.colorScheme.onSecondary;
      case CalculatorButtonType.memory:
        return widget.theme.colorScheme.onTertiary ?? widget.theme.colorScheme.onSecondary;
      case CalculatorButtonType.scientific:
        return widget.theme.colorScheme.onPrimaryContainer;
    }
  }

  double _getFontSize() {
    switch (widget.buttonType) {
      case CalculatorButtonType.number:
        return 24;
      case CalculatorButtonType.operator:
        return 20;
      case CalculatorButtonType.function:
        return 18;
      case CalculatorButtonType.memory:
        return 16;
      case CalculatorButtonType.scientific:
        return 14;
    }
  }
}
