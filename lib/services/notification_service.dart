import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  
  // Notification channels
  static const String _reminderChannelId = 'reminder_channel';
  static const String _calculationChannelId = 'calculation_channel';
  static const String _budgetChannelId = 'budget_channel';
  static const String _generalChannelId = 'general_channel';
  static const String _healthChannelId = 'health_channel';
  static const String _financeChannelId = 'finance_channel';
  static const String _achievementChannelId = 'achievement_channel';
  
  // Initialize notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      // Create notification channels for Android
      await _createNotificationChannels();
      
      _isInitialized = true;
      if (kDebugMode) print('Notification service initialized');
    } catch (e) {
      if (kDebugMode) print('Failed to initialize notification service: $e');
      _isInitialized = false;
    }
  }
  
  // Create notification channels
  static Future<void> _createNotificationChannels() async {
    const reminderChannel = AndroidNotificationChannel(
      _reminderChannelId,
      'Reminders',
      description: 'Notifications for reminders and alerts',
      importance: Importance.high,
      playSound: true,
    );
    
    const calculationChannel = AndroidNotificationChannel(
      _calculationChannelId,
      'Calculations',
      description: 'Notifications for calculation results',
      importance: Importance.defaultImportance,
      playSound: false,
    );
    
    const budgetChannel = AndroidNotificationChannel(
      _budgetChannelId,
      'Budget Alerts',
      description: 'Notifications for budget and finance alerts',
      importance: Importance.high,
      playSound: true,
    );
    
    const generalChannel = AndroidNotificationChannel(
      _generalChannelId,
      'General',
      description: 'General app notifications',
      importance: Importance.defaultImportance,
      playSound: false,
    );
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(calculationChannel);
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(budgetChannel);
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);
  }
  
  // Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) print('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }
  
  // Show simple notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = _generalChannelId,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _generalChannelId,
      'General',
      channelDescription: 'General app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  // Show reminder notification
  static Future<void> showReminderNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _reminderChannelId,
      'Reminders',
      channelDescription: 'Notifications for reminders and alerts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  // Show calculation result notification
  static Future<void> showCalculationNotification({
    required int id,
    required String expression,
    required String result,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _calculationChannelId,
      'Calculations',
      channelDescription: 'Notifications for calculation results',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      id,
      'Calculation Result',
      '$expression = $result',
      details,
    );
  }
  
  // Show budget alert notification
  static Future<void> showBudgetAlert({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _budgetChannelId,
      'Budget Alerts',
      channelDescription: 'Notifications for budget and finance alerts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  // Schedule reminder notification
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _reminderChannelId,
      'Reminders',
      channelDescription: 'Notifications for reminders and alerts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  
  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  // Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
  
  // Check if notification is scheduled
  static Future<bool> isNotificationScheduled(int id) async {
    final pending = await getPendingNotifications();
    return pending.any((notification) => notification.id == id);
  }
  
  // Show daily calculation summary
  static Future<void> showDailySummary({
    required int calculationsCount,
    required String mostUsedFunction,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _calculationChannelId,
      'Calculations',
      channelDescription: 'Notifications for calculation results',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      999, // Special ID for daily summary
      'Daily Summary',
      'You performed $calculationsCount calculations today. Most used: $mostUsedFunction',
      details,
    );
  }
  
  // Show budget overspend alert
  static Future<void> showBudgetOverspendAlert({
    required String budgetName,
    required String category,
    required double overspendAmount,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    const androidDetails = AndroidNotificationDetails(
      _budgetChannelId,
      'Budget Alerts',
      channelDescription: 'Notifications for budget and finance alerts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      998, // Special ID for budget alerts
      'Budget Alert',
      '$budgetName: You\'ve overspent by \$${overspendAmount.toStringAsFixed(2)} in $category',
      details,
    );
  }
  
  
  // Request notification permissions
  static Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return false;
    
    try {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }
      
      return true; // iOS permissions are handled in initialization
    } catch (e) {
      if (kDebugMode) print('Error requesting notification permissions: $e');
      return false;
    }
  }
  
  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return false;
    
    try {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        final enabled = await androidPlugin.areNotificationsEnabled();
        return enabled ?? false;
      }
      
      return true; // iOS permissions are handled in initialization
    } catch (e) {
      if (kDebugMode) print('Error checking notification permissions: $e');
      return false;
    }
  }
  
  // Open notification settings
  static Future<void> openNotificationSettings() async {
    try {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        // Note: openNotificationSettings method may not be available in all versions
        // You can implement custom settings navigation here
      }
    } catch (e) {
      if (kDebugMode) print('Error opening notification settings: $e');
    }
  }
  
  // Schedule recurring reminder
  static Future<void> scheduleRecurringReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required RecurrenceType recurrence,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    try {
      final androidDetails = AndroidNotificationDetails(
        _reminderChannelId,
        'Reminders',
        channelDescription: 'Reminder notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );
      
      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      switch (recurrence) {
        case RecurrenceType.daily:
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          break;
        case RecurrenceType.weekly:
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
          break;
        case RecurrenceType.monthly:
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          );
          break;
        case RecurrenceType.yearly:
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          );
          break;
        case RecurrenceType.once:
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          break;
      }
      
      if (kDebugMode) print('Recurring reminder scheduled: $title');
    } catch (e) {
      if (kDebugMode) print('Error scheduling recurring reminder: $e');
    }
  }
  
  // Show achievement notification
  static Future<void> showAchievementNotification({
    required String title,
    required String body,
    required String achievementType,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    try {
      final androidDetails = AndroidNotificationDetails(
        _achievementChannelId,
        'Achievements',
        channelDescription: 'Achievement notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        color: const Color(0xFF4CAF50), // Green for achievements
      );
      
      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
      
      if (kDebugMode) print('Achievement notification shown: $title');
    } catch (e) {
      if (kDebugMode) print('Error showing achievement notification: $e');
    }
  }
  
  // Show health reminder
  static Future<void> showHealthReminder({
    required String title,
    required String body,
    required String healthType,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    try {
      final androidDetails = AndroidNotificationDetails(
        _healthChannelId,
        'Health Reminders',
        channelDescription: 'Health and fitness reminders',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        color: const Color(0xFF2196F3), // Blue for health
      );
      
      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
      
      if (kDebugMode) print('Health reminder shown: $title');
    } catch (e) {
      if (kDebugMode) print('Error showing health reminder: $e');
    }
  }
  
  // Show finance alert
  static Future<void> showFinanceAlert({
    required String title,
    required String body,
    required String alertType,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_isInitialized) return;
    
    try {
      final androidDetails = AndroidNotificationDetails(
        _financeChannelId,
        'Finance Alerts',
        channelDescription: 'Financial alerts and reminders',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        color: const Color(0xFFFF9800), // Orange for finance
      );
      
      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
      
      if (kDebugMode) print('Finance alert shown: $title');
    } catch (e) {
      if (kDebugMode) print('Error showing finance alert: $e');
    }
  }
}

enum RecurrenceType {
  once,
  daily,
  weekly,
  monthly,
  yearly,
}
