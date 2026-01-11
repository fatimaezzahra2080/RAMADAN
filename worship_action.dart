import 'package:hive/hive.dart';

part 'worship_action.g.dart';

@HiveType(typeId: 0)
enum WorshipType {
  @HiveField(0)
  dhikr,
  @HiveField(1)
  dua,
  @HiveField(2)
  ayah,
  @HiveField(3)
  deed,
  @HiveField(4)
  fact,
}

extension WorshipTypeExtension on WorshipType {
  String get displayNameAr {
    switch (this) {
      case WorshipType.dhikr:
        return "ذكر";
      case WorshipType.dua:
        return "دعاء";
      case WorshipType.ayah:
        return "آية قرأنية";
      case WorshipType.deed:
        return "فعل خير";
      case WorshipType.fact:
        return "معلومة دينية";
    }
  }

  String get displayNameEn {
    switch (this) {
      case WorshipType.dhikr:
        return "Dhikr";
      case WorshipType.dua:
        return "Dua";
      case WorshipType.ayah:
        return "Ayah";
      case WorshipType.deed:
        return "Good Deed";
      case WorshipType.fact:
        return "Quick Fact";
    }
  }
}

@HiveType(typeId: 1)
class WorshipAction {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final WorshipType type;
  @HiveField(2)
  final String contentAr;
  @HiveField(3)
  final String contentEn;
  @HiveField(4)
  final String? audioPath;
  @HiveField(5)
  final int dayOfYear;

  WorshipAction({
    required this.id,
    required this.type,
    required this.contentAr,
    required this.contentEn,
    this.audioPath,
    required this.dayOfYear,
  });

  factory WorshipAction.fromJson(Map<String, dynamic> json) {
    return WorshipAction(
      id: json['id'],
      type: WorshipType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WorshipType.dhikr,
      ),
      contentAr: json['content_ar'] ?? '',
      contentEn: json['content_en'],
      audioPath: json['audio_path'],
      dayOfYear: json['day_of_year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content_ar': contentAr,
      'content_en': contentEn,
      'audio_path': audioPath,
      'day_of_year': dayOfYear,
    };
  }
}
