import 'package:hive/hive.dart';
import '../domain/monthly_challenge.dart';

class ChallengeRepository {
  final Box<MonthlyChallenge> _box;

  ChallengeRepository(this._box);

  List<MonthlyChallenge> getChallengesForMonth(int monthIndex) {
    return _box.values.where((c) => c.monthIndex == monthIndex).toList();
  }

  Future<void> toggleChallenge(int id) async {
    final challenge = _box.get(id);
    if (challenge != null) {
      await _box.put(id, challenge.copyWith(isCompleted: !challenge.isCompleted));
    }
  }

  Future<void> seedChallenges(List<MonthlyChallenge> challenges) async {
    for (var challenge in challenges) {
      if (!_box.containsKey(challenge.id)) {
        await _box.put(challenge.id, challenge);
      }
    }
  }
}
