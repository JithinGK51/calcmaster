import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EncryptionService {
  static final _encrypter = Encrypter(AES(Key.fromSecureRandom(32)));
  static const _ivLength = 16;

  /// Generate a secure encryption key from a PIN
  static String generateKeyFromPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Encrypt a string
  static String encryptString(String plainText, String key) {
    final keyBytes = Key.fromBase64(key);
    final encrypter = Encrypter(AES(keyBytes));
    final iv = IV.fromSecureRandom(_ivLength);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypt a string
  static String decryptString(String encryptedText, String key) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw Exception('Invalid encrypted text format');
    }
    
    final keyBytes = Key.fromBase64(key);
    final encrypter = Encrypter(AES(keyBytes));
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  /// Encrypt a file
  static Future<String> encryptFile(String filePath, String key) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    
    final keyBytes = Key.fromBase64(key);
    final encrypter = Encrypter(AES(keyBytes));
    final iv = IV.fromSecureRandom(_ivLength);
    
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    
    // Save encrypted file
    final encryptedPath = '${filePath}.enc';
    final encryptedFile = File(encryptedPath);
    await encryptedFile.writeAsBytes(encrypted.bytes);
    
    return encryptedPath;
  }

  /// Decrypt a file
  static Future<String> decryptFile(String encryptedFilePath, String key) async {
    final encryptedFile = File(encryptedFilePath);
    final encryptedBytes = await encryptedFile.readAsBytes();
    
    final keyBytes = Key.fromBase64(key);
    final encrypter = Encrypter(AES(keyBytes));
    final iv = IV.fromSecureRandom(_ivLength);
    
    final encrypted = Encrypted(encryptedBytes);
    final decryptedBytes = encrypter.decryptBytes(encrypted, iv: iv);
    
    // Save decrypted file
    final decryptedPath = encryptedFilePath.replaceAll('.enc', '');
    final decryptedFile = File(decryptedPath);
    await decryptedFile.writeAsBytes(decryptedBytes);
    
    return decryptedPath;
  }

  /// Generate file checksum
  static Future<String> generateFileChecksum(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify file integrity
  static Future<bool> verifyFileIntegrity(String filePath, String expectedChecksum) async {
    final actualChecksum = await generateFileChecksum(filePath);
    return actualChecksum == expectedChecksum;
  }

  /// Generate a secure random key
  static String generateSecureKey() {
    final key = Key.fromSecureRandom(32);
    return key.base64;
  }

  /// Hash a password for storage
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify password
  static bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }

  /// Encrypt data for vault storage
  static Future<Map<String, String>> encryptVaultData({
    required String filePath,
    required String key,
    required String originalName,
  }) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    
    final keyBytes = Key.fromBase64(key);
    final encrypter = Encrypter(AES(keyBytes));
    final iv = IV.fromSecureRandom(_ivLength);
    
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    final checksum = sha256.convert(bytes).toString();
    
    // Generate encrypted filename
    final encryptedName = encryptString(originalName, key);
    
    return {
      'encryptedData': encrypted.base64,
      'iv': iv.base64,
      'checksum': checksum,
      'encryptedName': encryptedName,
    };
  }

  /// Decrypt vault data
  static Future<Uint8List> decryptVaultData({
    required String encryptedData,
    required String iv,
    required String key,
  }) async {
    final keyBytes = Key.fromBase64(key);
    final encrypter = Encrypter(AES(keyBytes));
    final ivBytes = IV.fromBase64(iv);
    final encrypted = Encrypted.fromBase64(encryptedData);
    
    final decryptedBytes = encrypter.decryptBytes(encrypted, iv: ivBytes);
    return Uint8List.fromList(decryptedBytes);
  }

  /// Get vault directory
  static Future<Directory> getVaultDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final vaultDir = Directory(path.join(appDir.path, 'vault'));
    
    if (!await vaultDir.exists()) {
      await vaultDir.create(recursive: true);
    }
    
    return vaultDir;
  }

  /// Get temporary directory for decrypted files
  static Future<Directory> getTempDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final decryptDir = Directory(path.join(tempDir.path, 'decrypted'));
    
    if (!await decryptDir.exists()) {
      await decryptDir.create(recursive: true);
    }
    
    return decryptDir;
  }

  /// Clean up temporary files
  static Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTempDirectory();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Secure file deletion (overwrite with random data)
  static Future<void> secureDeleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      // Overwrite with random data multiple times
      for (int i = 0; i < 3; i++) {
        final randomBytes = List.generate(1024, (index) => DateTime.now().millisecondsSinceEpoch % 256);
        await file.writeAsBytes(randomBytes);
      }
      await file.delete();
    }
  }
}
