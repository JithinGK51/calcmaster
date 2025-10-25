import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../models/theme_model.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _result = '';
  bool _isTTSEnabled = false;
  bool _notificationsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _autoSaveEnabled = true;
  double _ttsRate = 0.5;
  double _ttsPitch = 1.0;
  double _ttsVolume = 1.0;
  String _selectedVoice = 'Default';

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

  void _saveSettings() {
    setState(() {
      _result = 'Settings Saved\n\n'
               'TTS Enabled: $_isTTSEnabled\n'
               'TTS Rate: ${_ttsRate.toStringAsFixed(1)}\n'
               'TTS Pitch: ${_ttsPitch.toStringAsFixed(1)}\n'
               'TTS Volume: ${_ttsVolume.toStringAsFixed(1)}\n'
               'Selected Voice: $_selectedVoice\n'
               'Notifications: $_notificationsEnabled\n'
               'Haptic Feedback: $_hapticFeedbackEnabled\n'
               'Auto Save: $_autoSaveEnabled';
    });
  }

  void _resetSettings() {
    setState(() {
      _notificationsEnabled = true;
      _hapticFeedbackEnabled = true;
      _autoSaveEnabled = true;
      _ttsRate = 0.5;
      _ttsPitch = 1.0;
      _ttsVolume = 1.0;
      _selectedVoice = 'Default';
      _result = 'Settings reset to default values';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(currentThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareSettingsResult(_result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Current Theme: ${currentTheme.name}'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showThemeSelector();
                          },
                          child: const Text('Change Theme'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // TTS Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text-to-Speech Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Enable TTS'),
                      subtitle: const Text('Speak calculation results'),
                      value: _isTTSEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isTTSEnabled = value;
                        });
                      },
                    ),
                    if (_isTTSEnabled) ...[
                      const SizedBox(height: 16),
                      Text('Speech Rate: ${_ttsRate.toStringAsFixed(1)}'),
                      Slider(
                        value: _ttsRate,
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            _ttsRate = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Speech Pitch: ${_ttsPitch.toStringAsFixed(1)}'),
                      Slider(
                        value: _ttsPitch,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        onChanged: (value) {
                          setState(() {
                            _ttsPitch = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Speech Volume: ${_ttsVolume.toStringAsFixed(1)}'),
                      Slider(
                        value: _ttsVolume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _ttsVolume = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedVoice,
                        decoration: const InputDecoration(
                          labelText: 'Voice',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Default', child: Text('Default')),
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedVoice = value!;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // General Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Notifications'),
                      subtitle: const Text('Enable reminder notifications'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Haptic Feedback'),
                      subtitle: const Text('Vibrate on button press'),
                      value: _hapticFeedbackEnabled,
                      onChanged: (value) {
                        setState(() {
                          _hapticFeedbackEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Auto Save'),
                      subtitle: const Text('Automatically save calculations'),
                      value: _autoSaveEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoSaveEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveSettings,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Settings'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetSettings,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                            'Result',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _result));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Settings copied to clipboard')),
                              );
                            },
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

            // App Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem('App Name', 'CalcMaster'),
                    _buildInfoItem('Version', '1.0.0'),
                    _buildInfoItem('Build', '2024.01.01'),
                    _buildInfoItem('Developer', 'CalcMaster Team'),
                    _buildInfoItem('Platform', 'Flutter'),
                    _buildInfoItem('License', 'MIT'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppTheme.values.map((theme) {
            return ListTile(
              title: Text(theme.name),
              onTap: () {
                ref.read(themeProvider.notifier).changeTheme(theme);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
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
}