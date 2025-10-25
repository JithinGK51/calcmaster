import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  String _result = '';
  bool _isTTSEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  void _generateAboutInfo() {
    setState(() {
      _result = 'CalcMaster - Ultimate Multi-Themed Smart Calculator\n\n'
               'Version: 1.0.0\n'
               'Build: 2024.01.01\n'
               'Platform: Flutter\n'
               'License: MIT\n\n'
               'Features:\n'
               '• Advanced Calculator with Scientific Functions\n'
               '• Algebra Solver with Step-by-Step Solutions\n'
               '• Geometry and Statistics Tools\n'
               '• Unit and Currency Converter\n'
               '• Finance and Health Calculators\n'
               '• Budget Management System\n'
               '• Reminder Manager with Notifications\n'
               '• Privacy Vault with Encryption\n'
               '• 13+ Beautiful Themes\n'
               '• Text-to-Speech Support\n'
               '• Graph Plotting and Charts\n'
               '• Usage Statistics and Insights\n\n'
               'Developed with ❤️ using Flutter & Dart\n'
               '© 2024 CalcMaster Team. All rights reserved.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About CalcMaster'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareAboutInfo(_result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Logo and Title
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.calculate,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CalcMaster',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ultimate Multi-Themed Smart Calculator',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About CalcMaster',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CalcMaster is a comprehensive, all-in-one calculator app that goes beyond basic arithmetic. '
                      'It combines advanced mathematical tools, financial calculators, health metrics, and productivity features '
                      'in a beautiful, user-friendly interface.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Whether you\'re a student, professional, or anyone who needs reliable calculation tools, '
                      'CalcMaster provides everything you need in one powerful app.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Key Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Features',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem('Advanced Calculator', 'Scientific functions, memory, and history'),
                    _buildFeatureItem('Algebra Solver', 'Step-by-step equation solving'),
                    _buildFeatureItem('Geometry Tools', 'Area, volume, and angle calculations'),
                    _buildFeatureItem('Unit Converter', 'Length, weight, temperature, and more'),
                    _buildFeatureItem('Currency Converter', 'Real-time exchange rates'),
                    _buildFeatureItem('Finance Calculators', 'EMI, interest, and investment tools'),
                    _buildFeatureItem('Health Calculators', 'BMI, BMR, and fitness metrics'),
                    _buildFeatureItem('Budget Manager', 'Income, expenses, and financial planning'),
                    _buildFeatureItem('Reminder System', 'Smart notifications and scheduling'),
                    _buildFeatureItem('Privacy Vault', 'Secure file storage with encryption'),
                    _buildFeatureItem('Multiple Themes', '13+ beautiful themes to choose from'),
                    _buildFeatureItem('Voice Support', 'Text-to-speech for accessibility'),
                    _buildFeatureItem('Graph Plotting', 'Visualize functions and data'),
                    _buildFeatureItem('Usage Analytics', 'Track your productivity and insights'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Technical Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technical Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTechItem('Framework', 'Flutter'),
                    _buildTechItem('Language', 'Dart'),
                    _buildTechItem('State Management', 'Riverpod'),
                    _buildTechItem('Local Storage', 'Hive'),
                    _buildTechItem('Encryption', 'AES-256'),
                    _buildTechItem('Charts', 'fl_chart & Syncfusion'),
                    _buildTechItem('Voice', 'flutter_tts'),
                    _buildTechItem('Notifications', 'flutter_local_notifications'),
                    _buildTechItem('File Handling', 'file_picker & image_picker'),
                    _buildTechItem('Security', 'flutter_screen_lock & local_auth'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Generate Info Button
            ElevatedButton.icon(
              onPressed: _generateAboutInfo,
              icon: const Icon(Icons.info),
              label: const Text('Generate About Information'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Result Section
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'About Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (_isTTSEnabled)
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await TTSService.speakAboutInfo(_result);
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _result));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('About info copied to clipboard')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _result,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Credits
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credits & Acknowledgments',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CalcMaster is built using open-source technologies and libraries. '
                      'We thank the Flutter community and all contributors who made this project possible.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Special thanks to:\n'
                      '• Flutter Team for the amazing framework\n'
                      '• Riverpod for state management\n'
                      '• Hive for local storage\n'
                      '• All package maintainers and contributors\n'
                      '• The open-source community',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Contact Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact & Support',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem('Email', 'support@calcmaster.app'),
                    _buildContactItem('Website', 'www.calcmaster.app'),
                    _buildContactItem('GitHub', 'github.com/calcmaster'),
                    _buildContactItem('Twitter', '@CalcMasterApp'),
                    _buildContactItem('License', 'MIT License'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                '© 2024 CalcMaster Team. All rights reserved.\n'
                'Made with ❤️ using Flutter & Dart',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}