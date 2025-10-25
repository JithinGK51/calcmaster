import 'dart:math' as math;

class ReminderManager {
  // Calculate time until reminder
  static Duration calculateTimeUntilReminder(DateTime reminderTime) {
    final now = DateTime.now();
    return reminderTime.difference(now);
  }
  
  // Check if reminder is overdue
  static bool isReminderOverdue(DateTime reminderTime) {
    return DateTime.now().isAfter(reminderTime);
  }
  
  // Calculate next occurrence for recurring reminders
  static DateTime calculateNextOccurrence(DateTime lastOccurrence, int intervalDays) {
    return lastOccurrence.add(Duration(days: intervalDays));
  }
  
  // Calculate reminder frequency in days
  static int calculateFrequencyInDays(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 1;
      case 'weekly':
        return 7;
      case 'monthly':
        return 30;
      case 'yearly':
        return 365;
      default:
        return 1;
    }
  }
  
  // Calculate total reminders in a period
  static int calculateTotalRemindersInPeriod(DateTime startDate, DateTime endDate, int intervalDays) {
    if (startDate.isAfter(endDate)) return 0;
    
    final duration = endDate.difference(startDate);
    final totalDays = duration.inDays;
    
    return (totalDays / intervalDays).floor() + 1;
  }
  
  // Calculate reminder priority score
  static double calculatePriorityScore({
    required DateTime dueDate,
    required String category,
    required bool isImportant,
  }) {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;
    
    double score = 100.0;
    
    // Time factor (closer to due date = higher priority)
    if (daysUntilDue < 0) {
      score += 50; // Overdue
    } else if (daysUntilDue <= 1) {
      score += 30; // Due today or tomorrow
    } else if (daysUntilDue <= 7) {
      score += 20; // Due this week
    } else if (daysUntilDue <= 30) {
      score += 10; // Due this month
    }
    
    // Category factor
    switch (category.toLowerCase()) {
      case 'urgent':
        score += 40;
        break;
      case 'important':
        score += 30;
        break;
      case 'work':
        score += 20;
        break;
      case 'personal':
        score += 10;
        break;
      case 'health':
        score += 25;
        break;
      case 'finance':
        score += 20;
        break;
    }
    
    // Importance factor
    if (isImportant) {
      score += 25;
    }
    
    return math.min(score, 200.0); // Cap at 200
  }
  
  // Calculate reminder completion rate
  static double calculateCompletionRate(int completedReminders, int totalReminders) {
    if (totalReminders <= 0) return 0;
    return (completedReminders / totalReminders) * 100;
  }
  
  // Calculate average time to complete reminders
  static Duration calculateAverageCompletionTime(List<Duration> completionTimes) {
    if (completionTimes.isEmpty) return Duration.zero;
    
    final totalMilliseconds = completionTimes.fold(0, (sum, duration) => sum + duration.inMilliseconds);
    final averageMilliseconds = totalMilliseconds / completionTimes.length;
    
    return Duration(milliseconds: averageMilliseconds.round());
  }
  
  // Calculate reminder efficiency score
  static double calculateEfficiencyScore({
    required double completionRate,
    required Duration averageCompletionTime,
    required int totalReminders,
  }) {
    // Base score from completion rate
    double score = completionRate;
    
    // Time efficiency factor (faster completion = higher score)
    final hoursToComplete = averageCompletionTime.inHours;
    if (hoursToComplete <= 1) {
      score += 20; // Very efficient
    } else if (hoursToComplete <= 24) {
      score += 10; // Efficient
    } else if (hoursToComplete <= 72) {
      score += 5; // Average
    }
    
    // Volume factor (more reminders handled = higher score)
    if (totalReminders >= 50) {
      score += 15; // High volume
    } else if (totalReminders >= 20) {
      score += 10; // Medium volume
    } else if (totalReminders >= 10) {
      score += 5; // Low volume
    }
    
    return math.min(score, 100.0);
  }
  
  // Calculate reminder distribution by category
  static Map<String, int> calculateReminderDistribution(List<Map<String, dynamic>> reminders) {
    final distribution = <String, int>{};
    
    for (final reminder in reminders) {
      final category = reminder['category'] as String? ?? 'uncategorized';
      distribution[category] = (distribution[category] ?? 0) + 1;
    }
    
    return distribution;
  }
  
  // Calculate reminder trends
  static Map<String, dynamic> calculateReminderTrends(List<Map<String, dynamic>> reminders) {
    if (reminders.isEmpty) {
      return {
        'totalReminders': 0,
        'completedReminders': 0,
        'overdueReminders': 0,
        'completionRate': 0.0,
        'averagePriority': 0.0,
      };
    }
    
    final now = DateTime.now();
    int completed = 0;
    int overdue = 0;
    double totalPriority = 0;
    
    for (final reminder in reminders) {
      final isCompleted = reminder['isCompleted'] as bool? ?? false;
      final dueDate = reminder['dueDate'] as DateTime?;
      final priority = reminder['priority'] as double? ?? 0.0;
      
      if (isCompleted) {
        completed++;
      }
      
      if (dueDate != null && dueDate.isBefore(now) && !isCompleted) {
        overdue++;
      }
      
      totalPriority += priority;
    }
    
    final completionRate = (completed / reminders.length) * 100;
    final averagePriority = totalPriority / reminders.length;
    
    return {
      'totalReminders': reminders.length,
      'completedReminders': completed,
      'overdueReminders': overdue,
      'completionRate': completionRate,
      'averagePriority': averagePriority,
    };
  }
  
  // Calculate optimal reminder timing
  static List<DateTime> calculateOptimalReminderTimes({
    required DateTime dueDate,
    required int numberOfReminders,
    required String reminderType,
  }) {
    final reminders = <DateTime>[];
    final now = DateTime.now();
    
    if (dueDate.isBefore(now)) {
      return reminders; // Can't set reminders for past dates
    }
    
    final totalDuration = dueDate.difference(now);
    final interval = totalDuration ~/ numberOfReminders;
    
    for (int i = 1; i <= numberOfReminders; i++) {
      final reminderTime = now.add(Duration(
        milliseconds: (interval.inMilliseconds * i).round(),
      ));
      
      if (reminderTime.isBefore(dueDate)) {
        reminders.add(reminderTime);
      }
    }
    
    // Add specific timing based on reminder type
    switch (reminderType.toLowerCase()) {
      case 'meeting':
        // Add reminders 1 hour and 15 minutes before
        final oneHourBefore = dueDate.subtract(const Duration(hours: 1));
        final fifteenMinBefore = dueDate.subtract(const Duration(minutes: 15));
        if (oneHourBefore.isAfter(now)) reminders.add(oneHourBefore);
        if (fifteenMinBefore.isAfter(now)) reminders.add(fifteenMinBefore);
        break;
      case 'deadline':
        // Add reminders 1 day and 1 week before
        final oneDayBefore = dueDate.subtract(const Duration(days: 1));
        final oneWeekBefore = dueDate.subtract(const Duration(days: 7));
        if (oneDayBefore.isAfter(now)) reminders.add(oneDayBefore);
        if (oneWeekBefore.isAfter(now)) reminders.add(oneWeekBefore);
        break;
      case 'appointment':
        // Add reminders 1 day and 2 hours before
        final oneDayBefore = dueDate.subtract(const Duration(days: 1));
        final twoHoursBefore = dueDate.subtract(const Duration(hours: 2));
        if (oneDayBefore.isAfter(now)) reminders.add(oneDayBefore);
        if (twoHoursBefore.isAfter(now)) reminders.add(twoHoursBefore);
        break;
    }
    
    // Remove duplicates and sort
    reminders.sort();
    return reminders.toSet().toList()..sort();
  }
}
