import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:path/path.dart' as path;

class PrivacyManager {
  static final _encrypter = Encrypter(AES(Key.fromSecureRandom(32)));
  
  // Encrypt file data
  static Encrypted encryptFileData(Uint8List fileData) {
    return _encrypter.encryptBytes(fileData);
  }
  
  // Decrypt file data
  static Uint8List decryptFileData(Encrypted encryptedData) {
    return Uint8List.fromList(_encrypter.decryptBytes(encryptedData));
  }
  
  // Generate secure file name
  static String generateSecureFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalName);
    final nameWithoutExtension = path.basenameWithoutExtension(originalName);
    final hash = _generateHash(nameWithoutExtension);
    return '${hash}_$timestamp$extension';
  }
  
  // Generate hash for file name
  static String _generateHash(String input) {
    // Simple hash function for demonstration
    // In production, use a proper cryptographic hash
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash + input.codeUnitAt(i)) & 0xffffffff;
    }
    return hash.abs().toRadixString(16);
  }
  
  // Calculate file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  // Get file type category
  static String getFileTypeCategory(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    
    switch (extension) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
      case '.webp':
        return 'Images';
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.wmv':
      case '.flv':
      case '.mkv':
        return 'Videos';
      case '.mp3':
      case '.wav':
      case '.flac':
      case '.aac':
      case '.ogg':
        return 'Audio';
      case '.pdf':
        return 'Documents';
      case '.doc':
      case '.docx':
        return 'Word Documents';
      case '.xls':
      case '.xlsx':
        return 'Spreadsheets';
      case '.ppt':
      case '.pptx':
        return 'Presentations';
      case '.txt':
      case '.rtf':
        return 'Text Files';
      case '.zip':
      case '.rar':
      case '.7z':
        return 'Archives';
      default:
        return 'Other';
    }
  }
  
  // Calculate storage usage by category
  static Map<String, int> calculateStorageUsageByCategory(List<Map<String, dynamic>> files) {
    final usage = <String, int>{};
    
    for (final file in files) {
      final category = file['category'] as String? ?? 'Other';
      final size = file['size'] as int? ?? 0;
      usage[category] = (usage[category] ?? 0) + size;
    }
    
    return usage;
  }
  
  // Calculate total storage usage
  static int calculateTotalStorageUsage(List<Map<String, dynamic>> files) {
    return files.fold(0, (total, file) => total + (file['size'] as int? ?? 0));
  }
  
  // Calculate storage percentage used
  static double calculateStoragePercentageUsed(int usedBytes, int totalBytes) {
    if (totalBytes <= 0) return 0;
    return (usedBytes / totalBytes) * 100;
  }
  
  // Check if file type is supported
  static bool isFileTypeSupported(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    final supportedExtensions = [
      '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', // Images
      '.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv', // Videos
      '.mp3', '.wav', '.flac', '.aac', '.ogg', // Audio
      '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', // Documents
      '.txt', '.rtf', '.zip', '.rar', '.7z', // Other
    ];
    
    return supportedExtensions.contains(extension);
  }
  
  // Calculate file age in days
  static int calculateFileAgeInDays(DateTime fileDate) {
    final now = DateTime.now();
    return now.difference(fileDate).inDays;
  }
  
  // Get file age description
  static String getFileAgeDescription(DateTime fileDate) {
    final ageInDays = calculateFileAgeInDays(fileDate);
    
    if (ageInDays == 0) {
      return 'Today';
    } else if (ageInDays == 1) {
      return 'Yesterday';
    } else if (ageInDays < 7) {
      return '$ageInDays days ago';
    } else if (ageInDays < 30) {
      final weeks = (ageInDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (ageInDays < 365) {
      final months = (ageInDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (ageInDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
  
  // Calculate vault security score
  static double calculateVaultSecurityScore({
    required bool hasPin,
    required bool hasBiometric,
    required bool hasPattern,
    required int totalFiles,
    required bool hasDecoyPin,
  }) {
    double score = 0;
    
    // Authentication methods
    if (hasPin) score += 30;
    if (hasBiometric) score += 40;
    if (hasPattern) score += 20;
    
    // File count factor (more files = higher security need)
    if (totalFiles > 100) {
      score += 20;
    } else if (totalFiles > 50) {
      score += 15;
    } else if (totalFiles > 10) {
      score += 10;
    }
    
    // Decoy PIN bonus
    if (hasDecoyPin) score += 10;
    
    return score.clamp(0, 100);
  }
  
  // Calculate vault usage statistics
  static Map<String, dynamic> calculateVaultUsageStats(List<Map<String, dynamic>> files) {
    if (files.isEmpty) {
      return {
        'totalFiles': 0,
        'totalSize': 0,
        'averageFileSize': 0,
        'mostCommonType': 'None',
        'oldestFile': null,
        'newestFile': null,
      };
    }
    
    final totalFiles = files.length;
    final totalSize = calculateTotalStorageUsage(files);
    final averageFileSize = totalSize / totalFiles;
    
    // Find most common file type
    final typeCount = <String, int>{};
    for (final file in files) {
      final type = file['category'] as String? ?? 'Other';
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    
    String mostCommonType = 'Other';
    int maxCount = 0;
    typeCount.forEach((type, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonType = type;
      }
    });
    
    // Find oldest and newest files
    DateTime? oldestDate;
    DateTime? newestDate;
    
    for (final file in files) {
      final date = file['dateAdded'] as DateTime?;
      if (date != null) {
        if (oldestDate == null || date.isBefore(oldestDate)) {
          oldestDate = date;
        }
        if (newestDate == null || date.isAfter(newestDate)) {
          newestDate = date;
        }
      }
    }
    
    return {
      'totalFiles': totalFiles,
      'totalSize': totalSize,
      'averageFileSize': averageFileSize,
      'mostCommonType': mostCommonType,
      'oldestFile': oldestDate,
      'newestFile': newestDate,
    };
  }
  
  // Calculate vault health score
  static double calculateVaultHealthScore({
    required int totalFiles,
    required int corruptedFiles,
    required int duplicateFiles,
    required double storagePercentageUsed,
  }) {
    double score = 100;
    
    // Deduct for corrupted files
    if (totalFiles > 0) {
      final corruptionRate = (corruptedFiles / totalFiles) * 100;
      score -= corruptionRate * 2; // Heavy penalty for corruption
    }
    
    // Deduct for duplicate files
    if (totalFiles > 0) {
      final duplicateRate = (duplicateFiles / totalFiles) * 100;
      score -= duplicateRate; // Moderate penalty for duplicates
    }
    
    // Deduct for high storage usage
    if (storagePercentageUsed > 90) {
      score -= 20; // Heavy penalty for near-full storage
    } else if (storagePercentageUsed > 80) {
      score -= 10; // Moderate penalty for high storage usage
    }
    
    return score.clamp(0, 100);
  }
}
