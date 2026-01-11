import 'package:hive/hive.dart';

part 'monthly_challenge.g.dart';

@HiveType(typeId: 3)
class MonthlyChallenge {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int monthIndex; // 1-12 (Islamic months)
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final bool isCompleted;

  MonthlyChallenge({
    required this.id,
    required this.monthIndex,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  factory MonthlyChallenge.fromJson(Map<String, dynamic> json) {
    return MonthlyChallenge(
      id: json['id'],
      monthIndex: json['monthIndex'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  MonthlyChallenge copyWith({
    bool? isCompleted,
  }) {
    return MonthlyChallenge(
      id: id,
      monthIndex: monthIndex,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
