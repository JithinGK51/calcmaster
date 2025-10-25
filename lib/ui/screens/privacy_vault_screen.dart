import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:encrypt/encrypt.dart';
import '../../services/tts_service.dart';
import '../../services/sharing_service.dart';
import '../../core/privacy_manager.dart';
import '../../models/vault_item_model.dart';

class PrivacyVaultScreen extends ConsumerStatefulWidget {
  const PrivacyVaultScreen({super.key});

  @override
  ConsumerState<PrivacyVaultScreen> createState() => _PrivacyVaultScreenState();
}

class _PrivacyVaultScreenState extends ConsumerState<PrivacyVaultScreen> {
  String _selectedCategory = 'Photos';
  String _result = '';
  bool _isTTSEnabled = false;
  bool _isLocked = true;
  String _pin = '';

  final List<String> _categories = [
    'Photos', 'Videos', 'Documents', 'Audio', 'Archives', 'All Files'
  ];

  final List<Map<String, dynamic>> _vaultItems = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await TTSService.initialize();
    setState(() {
      _isTTSEnabled = TTSService.isInitialized;
    });
  }

  Future<void> _unlockVault() async {
    if (_pin.isEmpty) {
      _showError('Please enter PIN');
      return;
    }

    // Simple PIN validation (in real app, use proper authentication)
    if (_pin == '1234') {
      setState(() {
        _isLocked = false;
        _result = 'Vault unlocked successfully';
      });
    } else {
      _showError('Invalid PIN');
    }
  }

  Future<void> _lockVault() async {
    setState(() {
      _isLocked = true;
      _pin = '';
      _result = 'Vault locked';
    });
  }

  Future<void> _importFile() async {
    try {
      // Show file type selection dialog
      final fileType = await _showFileTypeDialog();
      if (fileType == null) return;

      FilePickerResult? result;
      
      switch (fileType) {
        case 'any':
          result = await FilePicker.platform.pickFiles(
            type: FileType.any,
            allowMultiple: true,
          );
          break;
        case 'image':
          result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: true,
          );
          break;
        case 'video':
          result = await FilePicker.platform.pickFiles(
            type: FileType.video,
            allowMultiple: true,
          );
          break;
        case 'audio':
          result = await FilePicker.platform.pickFiles(
            type: FileType.audio,
            allowMultiple: true,
          );
          break;
        case 'document':
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf'],
            allowMultiple: true,
          );
          break;
        case 'camera':
          await _importFromCamera();
          return;
      }

      if (result != null && result.files.isNotEmpty) {
        await _processImportedFiles(result.files);
      }
    } catch (e) {
      _showError('Error importing file: $e');
    }
  }

  Future<String?> _showFileTypeDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select File Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Any File'),
              onTap: () => Navigator.pop(context, 'any'),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Images'),
              onTap: () => Navigator.pop(context, 'image'),
            ),
            ListTile(
              leading: const Icon(Icons.video_file),
              title: const Text('Videos'),
              onTap: () => Navigator.pop(context, 'video'),
            ),
            ListTile(
              leading: const Icon(Icons.audio_file),
              title: const Text('Audio'),
              onTap: () => Navigator.pop(context, 'audio'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Documents'),
              onTap: () => Navigator.pop(context, 'document'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null) {
        final file = File(image.path);
        final bytes = await file.readAsBytes();
        await _processSingleFile(image.name, bytes, VaultItemType.image);
      }
    } catch (e) {
      _showError('Error capturing from camera: $e');
    }
  }

  Future<void> _processImportedFiles(List<PlatformFile> files) async {
    int successCount = 0;
    int errorCount = 0;
    
    for (final file in files) {
      try {
        if (file.path != null) {
          final fileBytes = await File(file.path!).readAsBytes();
          final vaultItemType = _getVaultItemType(file.extension ?? '');
          await _processSingleFile(file.name, fileBytes, vaultItemType);
          successCount++;
        } else if (file.bytes != null) {
          final vaultItemType = _getVaultItemType(file.extension ?? '');
          await _processSingleFile(file.name, file.bytes!, vaultItemType);
          successCount++;
        }
      } catch (e) {
        errorCount++;
        if (kDebugMode) print('Error processing file ${file.name}: $e');
      }
    }

    setState(() {
      _result = 'Import completed:\n'
               '✅ Successfully imported: $successCount files\n'
               '❌ Failed to import: $errorCount files\n'
               '📁 Total files in vault: ${_vaultItems.length}';
    });

    if (_isTTSEnabled) {
      await TTSService.speakVaultResult('import', 'Imported $successCount files successfully');
    }
  }

  Future<void> _processSingleFile(String fileName, Uint8List fileBytes, VaultItemType type) async {
    try {
      // Get vault directory
      final vaultDir = await _getVaultDirectory();
      if (!await vaultDir.exists()) {
        await vaultDir.create(recursive: true);
      }

      // Generate secure filename
      final secureFileName = PrivacyManager.generateSecureFileName(fileName);
      final vaultFilePath = path.join(vaultDir.path, secureFileName);

      // Encrypt file data
      final encryptedData = PrivacyManager.encryptFileData(fileBytes);
      
      // Write encrypted file to vault
      final vaultFile = File(vaultFilePath);
      await vaultFile.writeAsBytes(encryptedData.bytes);

      // Create vault item
      final vaultItem = VaultItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalName: fileName,
        filePath: vaultFilePath,
        fileSize: fileBytes.length,
        type: type,
        album: _selectedCategory,
        dateAdded: DateTime.now(),
        isFavorite: false,
        tags: [],
        thumbnailPath: null,
        checksum: '', // Will be calculated later
        encryptedName: secureFileName,
        encryptionKey: '', // Will be set by PrivacyManager
      );

      // Add to vault items list
      _vaultItems.add({
        'id': vaultItem.id,
        'name': vaultItem.originalName,
        'path': vaultItem.filePath,
        'size': vaultItem.fileSize,
        'category': vaultItem.album,
        'date': vaultItem.dateAdded,
        'type': vaultItem.type.name,
      });

      if (kDebugMode) print('Successfully imported and encrypted: $fileName');
    } catch (e) {
      throw Exception('Failed to process file $fileName: $e');
    }
  }

  VaultItemType _getVaultItemType(String extension) {
    final ext = extension.toLowerCase();
    
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'].contains(ext)) {
      return VaultItemType.image;
    } else if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mkv'].contains(ext)) {
      return VaultItemType.video;
    } else if (['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'].contains(ext)) {
      return VaultItemType.audio;
    } else if (['pdf', 'doc', 'docx', 'txt', 'rtf', 'xls', 'xlsx', 'ppt', 'pptx'].contains(ext)) {
      return VaultItemType.document;
    } else {
      return VaultItemType.other;
    }
  }

  Future<Directory> _getVaultDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory(path.join(appDir.path, 'vault'));
  }

  Future<void> _importPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _vaultItems.add({
          'name': image.name,
          'path': image.path,
          'size': await image.length(),
          'category': 'Photos',
          'date': DateTime.now(),
        });

        setState(() {
          _result = 'Imported photo: ${image.name}\n'
                   'Total files in vault: ${_vaultItems.length}';
        });

        // Speak result if TTS is enabled
        if (_isTTSEnabled) {
          await TTSService.speakVaultResult('import', _result);
        }
      }
    } catch (e) {
      _showError('Error importing photo: $e');
    }
  }

  Future<void> _importVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        _vaultItems.add({
          'name': video.name,
          'path': video.path,
          'size': await video.length(),
          'category': 'Videos',
          'date': DateTime.now(),
        });

        setState(() {
          _result = 'Imported video: ${video.name}\n'
                   'Total files in vault: ${_vaultItems.length}';
        });

        // Speak result if TTS is enabled
        if (_isTTSEnabled) {
          await TTSService.speakVaultResult('import', _result);
        }
      }
    } catch (e) {
      _showError('Error importing video: $e');
    }
  }

  void _deleteItem(int index) {
    if (index >= 0 && index < _vaultItems.length) {
      final item = _vaultItems[index];
      _vaultItems.removeAt(index);
      
      setState(() {
        _result = 'Deleted: ${item['name']}\n'
                 'Total files in vault: ${_vaultItems.length}';
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLocked) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Vault'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Vault is Locked',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter PIN to access your private files',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    _pin = value;
                  },
                  onSubmitted: (value) {
                    _unlockVault();
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _unlockVault,
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Unlock Vault'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Vault'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: _lockVault,
          ),
          if (_result.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await SharingService.shareVaultResult(_result);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vault Status
            Card(
              color: Colors.green.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vault Status: Unlocked',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Files Protected: ${_vaultItems.length}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Import Options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Import Files',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _importFile,
                            icon: const Icon(Icons.file_upload),
                            label: const Text('Import Files'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _importPhoto,
                            icon: const Icon(Icons.photo),
                            label: const Text('Import Photo'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _importVideo,
                            icon: const Icon(Icons.videocam),
                            label: const Text('Import Video'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Vault Items
            if (_vaultItems.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vault Contents',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._vaultItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return ListTile(
                          leading: Icon(
                            _getFileIcon(item['category']),
                            color: theme.colorScheme.primary,
                          ),
                          title: Text(item['name']),
                          subtitle: Text(
                            '${_formatFileSize(item['size'])} • ${item['category']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteItem(index),
                          ),
                        );
                      }).toList(),
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
                          Row(
                            children: [
                              if (_isTTSEnabled)
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await TTSService.speakVaultResult('export', _result);
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _result));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Result copied to clipboard')),
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

            // Security Tips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Tips',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSecurityTip('Use a strong PIN (4-6 digits)'),
                    _buildSecurityTip('Keep your PIN private and secure'),
                    _buildSecurityTip('Regularly backup your vault contents'),
                    _buildSecurityTip('Lock the vault when not in use'),
                    _buildSecurityTip('Be cautious when importing files'),
                    _buildSecurityTip('Review vault contents regularly'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String category) {
    switch (category) {
      case 'Photos':
        return Icons.photo;
      case 'Videos':
        return Icons.videocam;
      case 'Documents':
        return Icons.description;
      case 'Audio':
        return Icons.audiotrack;
      case 'Archives':
        return Icons.archive;
      default:
        return Icons.file_present;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Widget _buildSecurityTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.security,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced export functionality
  Future<void> _exportFile() async {
    if (_vaultItems.isEmpty) {
      setState(() {
        _result = 'No files to export';
      });
      return;
    }

    try {
      // Show export options dialog
      final exportOption = await _showExportOptionsDialog();
      if (exportOption == null) return;

      switch (exportOption) {
        case 'single':
          await _exportSingleFile();
          break;
        case 'multiple':
          await _exportMultipleFiles();
          break;
        case 'all':
          await _exportAllFiles();
          break;
        case 'category':
          await _exportByCategory();
          break;
      }
    } catch (e) {
      _showError('Error exporting file: $e');
    }
  }

  Future<String?> _showExportOptionsDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export Single File'),
              onTap: () => Navigator.pop(context, 'single'),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Export Multiple Files'),
              onTap: () => Navigator.pop(context, 'multiple'),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export All Files'),
              onTap: () => Navigator.pop(context, 'all'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Export by Category'),
              onTap: () => Navigator.pop(context, 'category'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportSingleFile() async {
    if (_vaultItems.isEmpty) return;

    // Show file selection dialog
    final selectedFile = await _showFileSelectionDialog();
    if (selectedFile == null) return;

    try {
      await _decryptAndExportFile(selectedFile);
    } catch (e) {
      _showError('Error exporting file: $e');
    }
  }

  Future<void> _exportMultipleFiles() async {
    // Show multi-select dialog
    final selectedFiles = await _showMultiFileSelectionDialog();
    if (selectedFiles.isEmpty) return;

    int successCount = 0;
    int errorCount = 0;

    for (final file in selectedFiles) {
      try {
        await _decryptAndExportFile(file);
        successCount++;
      } catch (e) {
        errorCount++;
        if (kDebugMode) print('Error exporting file ${file['name']}: $e');
      }
    }

    setState(() {
      _result = 'Export completed:\n'
               '✅ Successfully exported: $successCount files\n'
               '❌ Failed to export: $errorCount files';
    });

    if (_isTTSEnabled) {
      await TTSService.speakVaultResult('export', 'Exported $successCount files successfully');
    }
  }

  Future<void> _exportAllFiles() async {
    int successCount = 0;
    int errorCount = 0;

    for (final file in _vaultItems) {
      try {
        await _decryptAndExportFile(file);
        successCount++;
      } catch (e) {
        errorCount++;
        if (kDebugMode) print('Error exporting file ${file['name']}: $e');
      }
    }

    setState(() {
      _result = 'Export all completed:\n'
               '✅ Successfully exported: $successCount files\n'
               '❌ Failed to export: $errorCount files';
    });

    if (_isTTSEnabled) {
      await TTSService.speakVaultResult('export', 'Exported all $successCount files successfully');
    }
  }

  Future<void> _exportByCategory() async {
    final category = await _showCategorySelectionDialog();
    if (category == null) return;

    final categoryFiles = _vaultItems.where((file) => file['category'] == category).toList();
    
    if (categoryFiles.isEmpty) {
      setState(() {
        _result = 'No files found in category: $category';
      });
      return;
    }

    int successCount = 0;
    int errorCount = 0;

    for (final file in categoryFiles) {
      try {
        await _decryptAndExportFile(file);
        successCount++;
      } catch (e) {
        errorCount++;
        if (kDebugMode) print('Error exporting file ${file['name']}: $e');
      }
    }

    setState(() {
      _result = 'Category export completed:\n'
               '📁 Category: $category\n'
               '✅ Successfully exported: $successCount files\n'
               '❌ Failed to export: $errorCount files';
    });

    if (_isTTSEnabled) {
      await TTSService.speakVaultResult('export', 'Exported $successCount files from $category category');
    }
  }

  Future<void> _decryptAndExportFile(Map<String, dynamic> vaultItem) async {
    try {
      final vaultFilePath = vaultItem['path'] as String;
      final originalName = vaultItem['name'] as String;
      
      // Read encrypted file
      final encryptedFile = File(vaultFilePath);
      if (!await encryptedFile.exists()) {
        throw Exception('Vault file not found: $vaultFilePath');
      }

      final encryptedBytes = await encryptedFile.readAsBytes();
      
      // Decrypt file data
      final encryptedData = Encrypted(Uint8List.fromList(encryptedBytes));
      final decryptedBytes = PrivacyManager.decryptFileData(encryptedData);
      
      // Get export directory
      final exportDir = await _getExportDirectory();
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      // Write decrypted file
      final exportPath = path.join(exportDir.path, originalName);
      final exportFile = File(exportPath);
      await exportFile.writeAsBytes(decryptedBytes);

      if (kDebugMode) print('Successfully exported: $originalName to $exportPath');
    } catch (e) {
      throw Exception('Failed to decrypt and export file: $e');
    }
  }

  Future<Directory> _getExportDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory(path.join(appDir.path, 'exports'));
  }

  Future<Map<String, dynamic>?> _showFileSelectionDialog() async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select File to Export'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _vaultItems.length,
            itemBuilder: (context, index) {
              final file = _vaultItems[index];
              return ListTile(
                leading: Icon(_getFileIcon(file['name'] as String)),
                title: Text(file['name'] as String),
                subtitle: Text('${_formatFileSize(file['size'] as int)} • ${file['category']}'),
                onTap: () => Navigator.pop(context, file),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _showMultiFileSelectionDialog() async {
    final selectedFiles = <Map<String, dynamic>>[];
    
    final result = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Files to Export'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: _vaultItems.length,
              itemBuilder: (context, index) {
                final file = _vaultItems[index];
                final isSelected = selectedFiles.contains(file);
                
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedFiles.add(file);
                      } else {
                        selectedFiles.remove(file);
                      }
                    });
                  },
                  title: Text(file['name'] as String),
                  subtitle: Text('${_formatFileSize(file['size'] as int)} • ${file['category']}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, []),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedFiles),
              child: Text('Export (${selectedFiles.length})'),
            ),
          ],
        ),
      ),
    );
    
    return result ?? [];
  }

  Future<String?> _showCategorySelectionDialog() async {
    final categories = _vaultItems.map((file) => file['category'] as String).toSet().toList();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((category) => ListTile(
            title: Text(category),
            onTap: () => Navigator.pop(context, category),
          )).toList(),
        ),
      ),
    );
  }

}