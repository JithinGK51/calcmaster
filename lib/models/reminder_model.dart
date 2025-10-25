import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 8)
enum ReminderType {
  @HiveField(0)
  bill,
  @HiveField(1)
  task,
  @HiveField(2)
  payment,
  @HiveField(3)
  health,
  @HiveField(4)
  general,
}

@HiveType(typeId: 9)
enum RepeatPattern {
  @HiveField(0)
  once,
  @HiveField(1)
  daily,
  @HiveField(2)
  weekly,
  @HiveField(3)
  monthly,
  @HiveField(4)
  yearly,
}

@HiveType(typeId: 10)
class Reminder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime scheduledTime;

  @HiveField(4)
  ReminderType type;

  @HiveField(5)
  RepeatPattern repeatPattern;

  @HiveField(6)
  bool isActive;

  @HiveField(7)
  bool useVoiceAlert;

  @HiveField(8)
  String? linkedBudgetId;

  @HiveField(9)
  String? linkedHealthGoal;

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  DateTime updatedAt;

  @HiveField(12)
  DateTime? lastTriggered;

  @HiveField(13)
  int notificationId;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.type,
    this.repeatPattern = RepeatPattern.once,
    this.isActive = true,
    this.useVoiceAlert = false,
    this.linkedBudgetId,
    this.linkedHealthGoal,
    required this.createdAt,
    required this.updatedAt,
    this.lastTriggered,
    required this.notificationId,
  });

  DateTime? get nextScheduledTime {
    if (!isActive || repeatPattern == RepeatPattern.once) {
      return null;
    }

    // final now = DateTime.now(); // Commented out as not currently used
    final scheduled = scheduledTime;

    switch (repeatPattern) {
      case RepeatPattern.daily:
        return DateTime(scheduled.year, scheduled.month, scheduled.day + 1);
      case RepeatPattern.weekly:
        return scheduled.add(const Duration(days: 7));
      case RepeatPattern.monthly:
        return DateTime(scheduled.year, scheduled.month + 1, scheduled.day);
      case RepeatPattern.yearly:
        return DateTime(scheduled.year + 1, scheduled.month, scheduled.day);
      case RepeatPattern.once:
        return null;
    }
  }

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledTime,
    ReminderType? type,
    RepeatPattern? repeatPattern,
    bool? isActive,
    bool? useVoiceAlert,
    String? linkedBudgetId,
    String? linkedHealthGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastTriggered,
    int? notificationId,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      type: type ?? this.type,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      isActive: isActive ?? this.isActive,
      useVoiceAlert: useVoiceAlert ?? this.useVoiceAlert,
      linkedBudgetId: linkedBudgetId ?? this.linkedBudgetId,
      linkedHealthGoal: linkedHealthGoal ?? this.linkedHealthGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
