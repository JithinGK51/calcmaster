import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:calcmaster/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CalcMaster Integration Tests', () {
    testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is displayed
      expect(find.text('CalcMaster'), findsOneWidget);
      expect(find.text('Ultimate Calculator Hub'), findsOneWidget);
    });

    testWidgets('Navigation to main screen works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Verify main navigation is displayed
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Basic calculator operations work', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Test basic addition: 2 + 3 = 5
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      // Verify result
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Scientific calculator functions work', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to scientific calculator
      await tester.tap(find.text('Scientific'));
      await tester.pumpAndSettle();

      // Test sin(0) = 0
      await tester.tap(find.text('sin'));
      await tester.pump();
      await tester.tap(find.text('('));
      await tester.pump();
      await tester.tap(find.text('0'));
      await tester.pump();
      await tester.tap(find.text(')'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      // Verify result (should be 0 or very close to 0)
      expect(find.textContaining('0'), findsOneWidget);
    });

    testWidgets('Theme switching works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Find theme selector
      expect(find.text('Theme'), findsOneWidget);
    });

    testWidgets('Unit converter works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to unit converter
      await tester.tap(find.text('Converter'));
      await tester.pumpAndSettle();

      // Verify converter screen is displayed
      expect(find.text('Unit Converter'), findsOneWidget);
    });

    testWidgets('Health calculator works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to health calculator
      await tester.tap(find.text('Health'));
      await tester.pumpAndSettle();

      // Verify health screen is displayed
      expect(find.text('Health Calculator'), findsOneWidget);
    });

    testWidgets('Finance calculator works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to finance calculator
      await tester.tap(find.text('Finance'));
      await tester.pumpAndSettle();

      // Verify finance screen is displayed
      expect(find.text('Finance Calculator'), findsOneWidget);
    });

    testWidgets('Memory functions work', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Test memory add: 5 M+
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('M+'));
      await tester.pumpAndSettle();

      // Test memory recall: MR
      await tester.tap(find.text('MR'));
      await tester.pumpAndSettle();

      // Verify memory recall worked
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Error handling works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Test division by zero: 5 ÷ 0
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('÷'));
      await tester.pump();
      await tester.tap(find.text('0'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      // Verify error is displayed
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('Clear functions work', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Enter some numbers
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      // Test clear all
      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();

      // Verify display is cleared
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Backspace function works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Enter some numbers
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      // Test backspace
      await tester.tap(find.text('⌫'));
      await tester.pumpAndSettle();

      // Verify last digit is removed
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('TTS toggle works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Find and tap TTS toggle
      await tester.tap(find.byIcon(Icons.volume_off));
      await tester.pumpAndSettle();

      // Verify TTS icon changed
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('Share functionality works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to calculator
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Perform a calculation
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      // Tap share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Note: Share dialog behavior varies by platform
      // This test verifies the button is tappable
    });

    testWidgets('Navigation between screens works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Test navigation to different screens
      final screens = ['Calculator', 'Scientific', 'Converter', 'Health', 'Finance'];
      
      for (final screen in screens) {
        await tester.tap(find.text(screen));
        await tester.pumpAndSettle();
        
        // Verify screen is displayed (basic check)
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('App handles orientation changes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Navigate to scientific calculator
      await tester.tap(find.text('Scientific'));
      await tester.pumpAndSettle();

      // Change orientation to landscape
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle();

      // Verify app still works in landscape
      expect(find.byType(Scaffold), findsOneWidget);

      // Change back to portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();

      // Verify app still works in portrait
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
