import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reminder_model.dart';

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier() : super(ReminderState.initial());

  void addReminder(Reminder reminder) {
    state = state.copyWith(
      reminders: [...state.reminders, reminder],
    );
  }

  void updateReminder(Reminder reminder) {
    state = state.copyWith(
      reminders: state.reminders.map((r) => r.id == reminder.id ? reminder : r).toList(),
    );
  }

  void deleteReminder(String reminderId) {
    state = state.copyWith(
      reminders: state.reminders.where((r) => r.id != reminderId).toList(),
    );
  }

  void markReminderCompleted(String reminderId) {
    final reminder = state.reminders.firstWhere((r) => r.id == reminderId);
    final updatedReminder = reminder.copyWith(
      lastTriggered: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    updateReminder(updatedReminder);
  }

  void markReminderIncomplete(String reminderId) {
    final reminder = state.reminders.firstWhere((r) => r.id == reminderId);
    final updatedReminder = reminder.copyWith(
      lastTriggered: null,
      updatedAt: DateTime.now(),
    );
    updateReminder(updatedReminder);
  }

  // Priority and category functionality removed as Reminder model doesn't have these properties

  void setReminderRepeat(String reminderId, RepeatPattern repeatPattern) {
    final reminder = state.reminders.firstWhere((r) => r.id == reminderId);
    final updatedReminder = reminder.copyWith(repeatPattern: repeatPattern);
    updateReminder(updatedReminder);
  }

  List<Reminder> getUpcomingReminders({int days = 7}) {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    return state.reminders.where((reminder) {
      return reminder.isActive &&
             reminder.scheduledTime.isAfter(now) &&
             reminder.scheduledTime.isBefore(futureDate);
    }).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  List<Reminder> getOverdueReminders() {
    final now = DateTime.now();
    
    return state.reminders.where((reminder) {
      return reminder.isActive && reminder.scheduledTime.isBefore(now);
    }).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  List<Reminder> getRemindersByType(ReminderType type) {
    return state.reminders.where((reminder) => reminder.type == type).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Priority-based filtering removed as Reminder model doesn't have priority property

  // Completed reminders functionality removed as Reminder model doesn't have completion properties

  Map<String, dynamic> getReminderStats() {
    final total = state.reminders.length;
    final active = state.reminders.where((r) => r.isActive).length;
    final overdue = getOverdueReminders().length;
    final upcoming = getUpcomingReminders().length;
    
    final activeRate = total > 0 ? (active / total) * 100 : 0;
    
    return {
      'total': total,
      'active': active,
      'overdue': overdue,
      'upcoming': upcoming,
      'activeRate': activeRate,
    };
  }

  Map<String, int> getReminderDistributionByType() {
    final distribution = <String, int>{};
    
    for (final reminder in state.reminders) {
      distribution[reminder.type.name] = (distribution[reminder.type.name] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Priority distribution removed as Reminder model doesn't have priority property

  List<Reminder> searchReminders(String query) {
    if (query.isEmpty) return state.reminders;
    
    final lowercaseQuery = query.toLowerCase();
    return state.reminders.where((reminder) {
      return reminder.title.toLowerCase().contains(lowercaseQuery) ||
             reminder.description.toLowerCase().contains(lowercaseQuery) ||
             reminder.type.name.toLowerCase().contains(lowercaseQuery);
    }).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  void clearInactiveReminders() {
    state = state.copyWith(
      reminders: state.reminders.where((r) => r.isActive).toList(),
    );
  }

  void clearAllReminders() {
    state = state.copyWith(reminders: []);
  }

  void setFilter(ReminderFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSortBy(ReminderSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  List<Reminder> getFilteredReminders() {
    List<Reminder> filtered = state.reminders;
    
    // Apply filter
    switch (state.filter) {
      case ReminderFilter.all:
        break;
      case ReminderFilter.completed:
        filtered = filtered.where((r) => !r.isActive).toList();
        break;
      case ReminderFilter.pending:
        filtered = filtered.where((r) => r.isActive).toList();
        break;
      case ReminderFilter.overdue:
        final now = DateTime.now();
        filtered = filtered.where((r) => r.isActive && r.scheduledTime.isBefore(now)).toList();
        break;
      case ReminderFilter.upcoming:
        final now = DateTime.now();
        final futureDate = now.add(const Duration(days: 7));
        filtered = filtered.where((r) => r.isActive && r.scheduledTime.isAfter(now) && r.scheduledTime.isBefore(futureDate)).toList();
        break;
    }
    
    // Apply sorting
    switch (state.sortBy) {
      case ReminderSortBy.dueDate:
        filtered.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
        break;
      case ReminderSortBy.priority:
        filtered.sort((a, b) => a.type.index.compareTo(b.type.index));
        break;
      case ReminderSortBy.category:
        filtered.sort((a, b) => a.type.name.compareTo(b.type.name));
        break;
      case ReminderSortBy.title:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case ReminderSortBy.createdDate:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    
    return filtered;
  }
}

class ReminderState {
  final List<Reminder> reminders;
  final ReminderFilter filter;
  final ReminderSortBy sortBy;
  final bool isLoading;
  final String? error;

  const ReminderState({
    required this.reminders,
    required this.filter,
    required this.sortBy,
    required this.isLoading,
    this.error,
  });

  factory ReminderState.initial() {
    return const ReminderState(
      reminders: [],
      filter: ReminderFilter.all,
      sortBy: ReminderSortBy.dueDate,
      isLoading: false,
      error: null,
    );
  }

  ReminderState copyWith({
    List<Reminder>? reminders,
    ReminderFilter? filter,
    ReminderSortBy? sortBy,
    bool? isLoading,
    String? error,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

enum ReminderFilter {
  all,
  completed,
  pending,
  overdue,
  upcoming,
}

enum ReminderSortBy {
  dueDate,
  priority,
  category,
  title,
  createdDate,
}

final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});
