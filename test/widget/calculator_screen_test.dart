import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calcmaster/ui/screens/calculator_screen.dart';

void main() {
  group('CalculatorScreen Widget Tests', () {
    testWidgets('should display calculator screen with all elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Check if the screen displays
      expect(find.byType(CalculatorScreen), findsOneWidget);
      
      // Check for basic calculator elements
      expect(find.text('Calculator'), findsOneWidget);
      
      // Check for number buttons
      expect(find.text('0'), findsWidgets);
      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);
      expect(find.text('4'), findsWidgets);
      expect(find.text('5'), findsWidgets);
      expect(find.text('6'), findsWidgets);
      expect(find.text('7'), findsWidgets);
      expect(find.text('8'), findsWidgets);
      expect(find.text('9'), findsWidgets);
      
      // Check for operation buttons
      expect(find.text('+'), findsWidgets);
      expect(find.text('-'), findsWidgets);
      expect(find.text('×'), findsWidgets);
      expect(find.text('÷'), findsWidgets);
      expect(find.text('='), findsWidgets);
      
      // Check for function buttons
      expect(find.text('C'), findsWidgets);
      expect(find.text('⌫'), findsWidgets);
    });

    testWidgets('should handle number button taps', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Tap number buttons
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      // Check if the display shows the numbers
      expect(find.text('53'), findsOneWidget);
    });

    testWidgets('should handle operation button taps', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter a calculation
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('+'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pump();
      
      // Check if the result is displayed
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('should handle clear button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter some numbers
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      // Clear
      await tester.tap(find.text('C'));
      await tester.pump();
      
      // Check if display is cleared
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should handle backspace button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter some numbers
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      // Backspace
      await tester.tap(find.text('⌫'));
      await tester.pump();
      
      // Check if last digit is removed
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should handle decimal input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter decimal number
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('.'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      // Check if decimal is displayed
      expect(find.text('5.3'), findsOneWidget);
    });

    testWidgets('should handle scientific mode toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Look for scientific mode button
      expect(find.byIcon(Icons.science), findsOneWidget);
      
      // Tap to toggle scientific mode
      await tester.tap(find.byIcon(Icons.science));
      await tester.pump();
      
      // Check if scientific functions are visible
      expect(find.text('sin'), findsOneWidget);
      expect(find.text('cos'), findsOneWidget);
      expect(find.text('tan'), findsOneWidget);
    });

    testWidgets('should handle degree/radian mode toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Toggle to scientific mode first
      await tester.tap(find.byIcon(Icons.science));
      await tester.pump();
      
      // Look for degree/radian toggle
      expect(find.text('DEG'), findsOneWidget);
      
      // Tap to toggle
      await tester.tap(find.text('DEG'));
      await tester.pump();
      
      // Check if mode changed
      expect(find.text('RAD'), findsOneWidget);
    });

    testWidgets('should handle memory functions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Toggle to scientific mode to access memory functions
      await tester.tap(find.byIcon(Icons.science));
      await tester.pump();
      
      // Enter a number
      await tester.tap(find.text('5'));
      await tester.pump();
      
      // Add to memory
      await tester.tap(find.text('M+'));
      await tester.pump();
      
      // Clear display
      await tester.tap(find.text('C'));
      await tester.pump();
      
      // Recall from memory
      await tester.tap(find.text('MR'));
      await tester.pump();
      
      // Check if memory value is displayed
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should handle TTS button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter a calculation
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('+'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pump();
      
      // Look for TTS button
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      
      // Tap TTS button
      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();
    });

    testWidgets('should handle share button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter a calculation
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('+'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pump();
      
      // Look for share button
      expect(find.byIcon(Icons.share), findsOneWidget);
      
      // Tap share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();
    });

    testWidgets('should handle complex calculations', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Enter complex calculation: (5 + 3) * 2
      await tester.tap(find.text('('));
      await tester.pump();
      
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('+'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text(')'));
      await tester.pump();
      
      await tester.tap(find.text('×'));
      await tester.pump();
      
      await tester.tap(find.text('2'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pump();
      
      // Check if result is correct
      expect(find.text('16'), findsOneWidget);
    });

    testWidgets('should handle error cases', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Try division by zero
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('÷'));
      await tester.pump();
      
      await tester.tap(find.text('0'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pump();
      
      // Check if error is displayed
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('should handle scientific functions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CalculatorScreen(),
          ),
        ),
      );

      // Toggle to scientific mode
      await tester.tap(find.byIcon(Icons.science));
      await tester.pump();
      
      // Test sine function
      await tester.tap(find.text('sin'));
      await tester.pump();
      
      await tester.tap(find.text('0'));
      await tester.pump();
      
      await tester.tap(find.text(')'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pump();
      
      // Check if result is correct (sin(0) = 0)
      expect(find.text('0'), findsOneWidget);
    });
  });
}
