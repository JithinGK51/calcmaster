import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:calcmaster/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should navigate through all main screens', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if main navigation is displayed
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Test navigation to different screens
      await tester.tap(find.text('Algebra'));
      await tester.pumpAndSettle();
      expect(find.text('Algebra Calculator'), findsOneWidget);

      await tester.tap(find.text('Geometry'));
      await tester.pumpAndSettle();
      expect(find.text('Geometry Calculator'), findsOneWidget);

      await tester.tap(find.text('Finance'));
      await tester.pumpAndSettle();
      expect(find.text('Finance Calculator'), findsOneWidget);

      await tester.tap(find.text('Health'));
      await tester.pumpAndSettle();
      expect(find.text('Health Calculator'), findsOneWidget);

      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();
      expect(find.text('Calculator'), findsOneWidget);
    });

    testWidgets('should perform complete calculation workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Perform calculation
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('+'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      // Verify result
      expect(find.text('8'), findsOneWidget);

      // Test TTS
      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pumpAndSettle();

      // Test share
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle theme switching', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Change theme
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Verify theme changed
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle privacy vault workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to privacy vault
      await tester.tap(find.text('Privacy Vault'));
      await tester.pumpAndSettle();

      // Enter PIN (assuming default is 1234)
      await tester.tap(find.text('1'));
      await tester.pump();
      
      await tester.tap(find.text('2'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      // Verify vault is unlocked
      expect(find.text('Vault unlocked successfully'), findsOneWidget);
    });

    testWidgets('should handle budget management workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to budget
      await tester.tap(find.text('Budget'));
      await tester.pumpAndSettle();

      // Add income
      await tester.tap(find.text('Add Income'));
      await tester.pumpAndSettle();

      // Fill income form
      await tester.enterText(find.byType(TextField).first, '5000');
      await tester.pump();
      
      await tester.enterText(find.byType(TextField).at(1), 'Salary');
      await tester.pump();
      
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify income added
      expect(find.text('5000'), findsOneWidget);
    });

    testWidgets('should handle reminder management workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to reminders
      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      // Add reminder
      await tester.tap(find.text('Add Reminder'));
      await tester.pumpAndSettle();

      // Fill reminder form
      await tester.enterText(find.byType(TextField).first, 'Test Reminder');
      await tester.pump();
      
      await tester.enterText(find.byType(TextField).at(1), 'This is a test reminder');
      await tester.pump();
      
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify reminder added
      expect(find.text('Test Reminder'), findsOneWidget);
    });

    testWidgets('should handle unit conversion workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to unit converter
      await tester.tap(find.text('Unit Converter'));
      await tester.pumpAndSettle();

      // Select length conversion
      await tester.tap(find.text('Length'));
      await tester.pumpAndSettle();

      // Enter value
      await tester.enterText(find.byType(TextField).first, '100');
      await tester.pump();

      // Select units
      await tester.tap(find.text('cm'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('m'));
      await tester.pumpAndSettle();

      // Verify conversion
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should handle currency conversion workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to currency converter
      await tester.tap(find.text('Currency Converter'));
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField).first, '100');
      await tester.pump();

      // Select currencies
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('EUR'));
      await tester.pumpAndSettle();

      // Verify conversion
      expect(find.text('85'), findsOneWidget);
    });

    testWidgets('should handle graph plotting workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to graphs
      await tester.tap(find.text('Graphs'));
      await tester.pumpAndSettle();

      // Select function plot
      await tester.tap(find.text('Function Plot'));
      await tester.pumpAndSettle();

      // Enter function
      await tester.enterText(find.byType(TextField).first, 'x^2');
      await tester.pump();

      // Generate graph
      await tester.tap(find.text('Generate Graph'));
      await tester.pumpAndSettle();

      // Verify graph is displayed
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('should handle settings and preferences', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Test TTS settings
      await tester.tap(find.text('Voice Settings'));
      await tester.pumpAndSettle();

      // Change voice
      await tester.tap(find.text('Female Voice 1'));
      await tester.pumpAndSettle();

      // Test notification settings
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      // Toggle notifications
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle app lifecycle events', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Perform some actions
      await tester.tap(find.text('5'));
      await tester.pump();
      
      await tester.tap(find.text('+'));
      await tester.pump();
      
      await tester.tap(find.text('3'));
      await tester.pump();
      
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      // Simulate app going to background
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.paused', null),
        ),
        (data) {},
      );
      await tester.pumpAndSettle();

      // Simulate app coming back to foreground
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.resumed', null),
        ),
        (data) {},
      );
      await tester.pumpAndSettle();

      // Verify app state is preserved
      expect(find.text('8'), findsOneWidget);
    });
  });
}
