import 'package:dio/dio.dart';
import 'dart:developer' as dev;
import '../features/worship/domain/worship_action.dart';

class ApiService {
  final Dio _dio = Dio();

  // Using Aladhan API to get random Ayah or Islamic content
  // For demonstration, we'll fetch a random Ayah with audio
  Future<WorshipAction?> fetchRandomAyah() async {
    try {
      // API to get a random Ayah from the Quran
      final response = await _dio.get('https://api.alquran.cloud/v1/ayah/${_getRandomAyahNumber()}/ar.alafasy');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final text = data['text'];
        final audio = data['audio'];
        final surah = data['surah']['name'];
        final numberInSurah = data['numberInSurah'];

        return WorshipAction(
          id: DateTime.now().millisecondsSinceEpoch,
          type: WorshipType.ayah,
          contentAr: text,
          contentEn: "$surah ($numberInSurah)",
          audioPath: audio, // This will be a URL, just_audio supports URLs too
          dayOfYear: DateTime.now().day + (DateTime.now().month - 1) * 30,
        );
      }
    } catch (e) {
      dev.log("Error fetching Ayah from API: $e");
    }
    return null;
  }

  int _getRandomAyahNumber() {
    // There are 6236 ayahs in the Quran
    return (DateTime.now().millisecondsSinceEpoch % 6236) + 1;
  }
}
