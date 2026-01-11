import 'package:hive/hive.dart';

part 'adhkar_item.g.dart';

@HiveType(typeId: 3)
class AdhkarItem {
  @HiveField(0)
  final String contentAr;
  @HiveField(1)
  final String contentEn;
  @HiveField(2)
  final String? descriptionAr;
  @HiveField(3)
  final String? descriptionEn;
  @HiveField(4)
  final int count;
  @HiveField(5)
  final String type; // 'morning' or 'evening'
  @HiveField(6)
  final String? audioPath;

  AdhkarItem({
    required this.contentAr,
    required this.contentEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.count,
    required this.type,
    this.audioPath,
  });

  factory AdhkarItem.fromJson(Map<String, dynamic> json) {
    return AdhkarItem(
      contentAr: json['content_ar'],
      contentEn: json['content_en'],
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
      count: json['count'] ?? 1,
      type: json['type'],
      audioPath: json['audio_path'],
    );
  }
}
