import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 2)
class UserProgress {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final int actionId;
  @HiveField(2)
  final bool isCompleted;
  @HiveField(3)
  final DateTime? completionTime;

  UserProgress({
    required this.date,
    required this.actionId,
    this.isCompleted = false,
    this.completionTime,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      date: DateTime.parse(json['date']),
      actionId: json['action_id'],
      isCompleted: json['is_completed'] ?? false,
      completionTime: json['completion_time'] != null
          ? DateTime.parse(json['completion_time'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'action_id': actionId,
      'is_completed': isCompleted,
      'completion_time': completionTime?.toIso8601String(),
    };
  }
}
