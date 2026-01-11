import 'package:hive/hive.dart';
import '../domain/user_progress.dart';

class ProgressRepository {
  final Box<UserProgress> _box;

  ProgressRepository(this._box);

  /// Saves or updates completion for a specific date
  Future<void> markAsCompleted({
    required int actionId,
    required DateTime date,
  }) async {
    final key = _getActionKey(date, actionId);
    final progress = UserProgress(
      date: date,
      actionId: actionId,
      isCompleted: true,
      completionTime: DateTime.now(),
    );
    await _box.put(key, progress);
  }

  /// Gets progress for a specific date and action
  UserProgress? getProgressForAction(DateTime date, int actionId) {
    return _box.get(_getActionKey(date, actionId));
  }

  /// Gets all progress entries for a specific date
  List<UserProgress> getProgressForDate(DateTime date) {
    final dateStr = _getDateKey(date);
    return _box.values.where((p) => _getDateKey(p.date) == dateStr).toList();
  }

  /// Gets all progress history for streak calculation
  List<UserProgress> getAllProgress() {
    return _box.values.toList();
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  String _getActionKey(DateTime date, int actionId) {
    return "${_getDateKey(date)}_$actionId";
  }
}
