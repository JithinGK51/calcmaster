import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../ui/themes/theme_data.dart';
import '../../models/theme_model.dart';

class ThemeSelector extends ConsumerWidget {
  final bool showPreview;
  final bool showDescription;
  final Function(AppTheme)? onThemeSelected;

  const ThemeSelector({
    super.key,
    this.showPreview = true,
    this.showDescription = true,
    this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDescription) ...[
          Text(
            'Choose Theme',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a theme that matches your style and preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: AppTheme.values.length,
          itemBuilder: (context, index) {
            final theme = AppTheme.values[index];
            final isSelected = currentTheme == theme;
            
            return _ThemeCard(
              theme: theme,
              isSelected: isSelected,
              onTap: () {
                themeNotifier.changeTheme(theme);
                onThemeSelected?.call(theme);
              },
            );
          },
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
        final themeData = AppThemeData.getTheme(theme);
        final themeInfo = {
          'name': theme.name,
          'description': 'Theme description',
          'icon': Icons.palette,
          'gradient': LinearGradient(
            colors: [themeData.primaryColor, themeData.primaryColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Theme preview
              Container(
                decoration: BoxDecoration(
                  gradient: themeInfo['gradient'] as LinearGradient,
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: themeData.primaryColor.withOpacity(0.8),
                      ),
                      child: Center(
                        child: Text(
                          themeInfo['name'] as String,
                          style: TextStyle(
                            color: themeData.colorScheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Content area
                    Expanded(
                      child: Container(
                        color: themeData.scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            // Sample buttons
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _SampleButton(
                                    color: themeData.primaryColor,
                                    text: '1',
                                  ),
                                  _SampleButton(
                                    color: themeData.colorScheme.secondary,
                                    text: '2',
                                  ),
                                  _SampleButton(
                                    color: themeData.colorScheme.tertiary,
                                    text: '3',
                                  ),
                                ],
                              ),
                            ),
                            // Sample text
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Sample Text',
                                style: themeData.textTheme.bodySmall?.copyWith(
                                  color: themeData.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SampleButton extends StatelessWidget {
  final Color color;
  final String text;

  const _SampleButton({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ThemePreviewDialog extends ConsumerWidget {
  final AppTheme theme;

  const ThemePreviewDialog({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final themeData = AppThemeData.getTheme(theme);
        final themeInfo = {
          'name': theme.name,
          'description': 'Theme description',
          'icon': Icons.palette,
          'gradient': LinearGradient(
            colors: [themeData.primaryColor, themeData.primaryColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        };

    return Dialog(
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: themeInfo['gradient'] as LinearGradient,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeData.primaryColor.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    themeInfo['icon'] as IconData,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      themeInfo['name'] as String,
                      style: themeData.textTheme.headlineSmall?.copyWith(
                        color: themeData.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: themeData.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Container(
                color: themeData.scaffoldBackgroundColor,
                child: Column(
                  children: [
                    // Sample calculator display
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: themeData.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '123 + 456',
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              color: themeData.textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '579',
                            style: themeData.textTheme.headlineMedium?.copyWith(
                              color: themeData.textTheme.headlineMedium?.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sample buttons
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: [
                            _SampleCalculatorButton(
                              text: 'C',
                              color: themeData.colorScheme.error,
                              textColor: themeData.colorScheme.onError,
                            ),
                            _SampleCalculatorButton(
                              text: '÷',
                              color: themeData.colorScheme.secondary,
                              textColor: themeData.colorScheme.onSecondary,
                            ),
                            _SampleCalculatorButton(
                              text: '×',
                              color: themeData.colorScheme.secondary,
                              textColor: themeData.colorScheme.onSecondary,
                            ),
                            _SampleCalculatorButton(
                              text: '⌫',
                              color: themeData.colorScheme.tertiary,
                              textColor: themeData.colorScheme.onTertiary,
                            ),
                            _SampleCalculatorButton(
                              text: '7',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '8',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '9',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '-',
                              color: themeData.colorScheme.secondary,
                              textColor: themeData.colorScheme.onSecondary,
                            ),
                            _SampleCalculatorButton(
                              text: '4',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '5',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '6',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '+',
                              color: themeData.colorScheme.secondary,
                              textColor: themeData.colorScheme.onSecondary,
                            ),
                            _SampleCalculatorButton(
                              text: '1',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '2',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '3',
                              color: themeData.colorScheme.surface,
                              textColor: themeData.colorScheme.onSurface,
                            ),
                            _SampleCalculatorButton(
                              text: '=',
                              color: themeData.primaryColor,
                              textColor: themeData.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleCalculatorButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _SampleCalculatorButton({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
