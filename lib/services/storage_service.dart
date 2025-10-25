import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/theme_model.dart';
import '../models/calculation_model.dart';
import '../models/budget_model.dart';
import '../models/reminder_model.dart';
import '../models/voice_model.dart';
import '../models/vault_item_model.dart';
import '../models/settings_model.dart';

class StorageService {
  static const String _encryptionKey = 'calc_master_encryption_key';
  static const String _themeBoxName = 'themes';
  static const String _calculationBoxName = 'calculations';
  static const String _budgetBoxName = 'budgets';
  static const String _transactionBoxName = 'transactions';
  static const String _reminderBoxName = 'reminders';
  static const String _voiceBoxName = 'voices';
  static const String _vaultBoxName = 'vault_items';
  static const String _albumBoxName = 'vault_albums';
  static const String _settingsBoxName = 'settings';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static late Box<ThemeConfig> _themeBox;
  static late Box<CalculationHistory> _calculationBox;
  static late Box<Budget> _budgetBox;
  static late Box<Transaction> _transactionBox;
  static late Box<Reminder> _reminderBox;
  static late Box<VoiceConfig> _voiceBox;
  static late Box<VaultItem> _vaultBox;
  static late Box<VaultAlbum> _albumBox;
  static late Box<AppSettings> _settingsBox;

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ThemeConfigAdapter());
    Hive.registerAdapter(AppThemeAdapter());
    Hive.registerAdapter(CalculationHistoryAdapter());
    Hive.registerAdapter(CalculationTypeAdapter());
    Hive.registerAdapter(BudgetAdapter());
    Hive.registerAdapter(BudgetTypeAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(ReminderTypeAdapter());
    Hive.registerAdapter(RepeatPatternAdapter());
    Hive.registerAdapter(VoiceConfigAdapter());
    Hive.registerAdapter(VoiceGenderAdapter());
    Hive.registerAdapter(TTSConfigAdapter());
    Hive.registerAdapter(VaultItemAdapter());
    Hive.registerAdapter(VaultItemTypeAdapter());
    Hive.registerAdapter(VaultAlbumAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(AngleModeAdapter());
    Hive.registerAdapter(CalculatorModeAdapter());

    // Get encryption key
    String? encryptionKey = await _secureStorage.read(key: _encryptionKey);
    if (encryptionKey == null) {
      encryptionKey = _generateEncryptionKey();
      await _secureStorage.write(key: _encryptionKey, value: encryptionKey);
    }

    // Open boxes with encryption
    _themeBox = await Hive.openBox<ThemeConfig>(
      _themeBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _calculationBox = await Hive.openBox<CalculationHistory>(
      _calculationBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _budgetBox = await Hive.openBox<Budget>(
      _budgetBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _transactionBox = await Hive.openBox<Transaction>(
      _transactionBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _reminderBox = await Hive.openBox<Reminder>(
      _reminderBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _voiceBox = await Hive.openBox<VoiceConfig>(
      _voiceBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _vaultBox = await Hive.openBox<VaultItem>(
      _vaultBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _albumBox = await Hive.openBox<VaultAlbum>(
      _albumBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
    _settingsBox = await Hive.openBox<AppSettings>(
      _settingsBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );

    _isInitialized = true;
  }

  static String _generateEncryptionKey() {
    // Generate a random 32-character encryption key
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(32, (index) => chars[random % chars.length]).join();
  }

  // Theme operations
  static Future<void> saveThemeConfig(ThemeConfig config) async {
    await _themeBox.put('current_theme', config);
  }

  static ThemeConfig? getThemeConfig() {
    return _themeBox.get('current_theme');
  }

  // Calculation history operations
  static Future<void> saveCalculation(CalculationHistory calculation) async {
    await _calculationBox.put(calculation.id, calculation);
  }

  static List<CalculationHistory> getAllCalculations() {
    return _calculationBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Future<void> deleteCalculation(String id) async {
    await _calculationBox.delete(id);
  }

  static Future<void> clearAllCalculations() async {
    await _calculationBox.clear();
  }

  // Budget operations
  static Future<void> saveBudget(Budget budget) async {
    await _budgetBox.put(budget.id, budget);
  }

  static List<Budget> getAllBudgets() {
    return _budgetBox.values.toList();
  }

  static Budget? getBudget(String id) {
    return _budgetBox.get(id);
  }

  static Future<void> deleteBudget(String id) async {
    await _budgetBox.delete(id);
  }

  // Transaction operations
  static Future<void> saveTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  static List<Transaction> getTransactionsByBudget(String budgetId) {
    return _transactionBox.values
        .where((transaction) => transaction.budgetId == budgetId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  // Reminder operations
  static Future<void> saveReminder(Reminder reminder) async {
    await _reminderBox.put(reminder.id, reminder);
  }

  static List<Reminder> getAllReminders() {
    return _reminderBox.values.toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  static Reminder? getReminder(String id) {
    return _reminderBox.get(id);
  }

  static Future<void> deleteReminder(String id) async {
    await _reminderBox.delete(id);
  }

  // Voice operations
  static Future<void> saveVoiceConfig(VoiceConfig voice) async {
    await _voiceBox.put(voice.voiceId, voice);
  }

  static List<VoiceConfig> getAllVoices() {
    return _voiceBox.values.toList();
  }

  static VoiceConfig? getVoice(String voiceId) {
    return _voiceBox.get(voiceId);
  }

  // Vault operations
  static Future<void> saveVaultItem(VaultItem item) async {
    await _vaultBox.put(item.id, item);
  }

  static List<VaultItem> getAllVaultItems() {
    return _vaultBox.values.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
  }

  static VaultItem? getVaultItem(String id) {
    return _vaultBox.get(id);
  }

  static Future<void> deleteVaultItem(String id) async {
    await _vaultBox.delete(id);
  }

  // Album operations
  static Future<void> saveAlbum(VaultAlbum album) async {
    await _albumBox.put(album.id, album);
  }

  static List<VaultAlbum> getAllAlbums() {
    return _albumBox.values.toList();
  }

  static VaultAlbum? getAlbum(String id) {
    return _albumBox.get(id);
  }

  static Future<void> deleteAlbum(String id) async {
    await _albumBox.delete(id);
  }

  // Settings operations
  static Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('app_settings', settings);
  }

  static AppSettings? getSettings() {
    return _settingsBox.get('app_settings');
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await _themeBox.clear();
    await _calculationBox.clear();
    await _budgetBox.clear();
    await _transactionBox.clear();
    await _reminderBox.clear();
    await _voiceBox.clear();
    await _vaultBox.clear();
    await _albumBox.clear();
    await _settingsBox.clear();
  }

  static Future<void> close() async {
    await _themeBox.close();
    await _calculationBox.close();
    await _budgetBox.close();
    await _transactionBox.close();
    await _reminderBox.close();
    await _voiceBox.close();
    await _vaultBox.close();
    await _albumBox.close();
    await _settingsBox.close();
  }

  // Secure storage operations
  static Future<void> saveSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }
}
