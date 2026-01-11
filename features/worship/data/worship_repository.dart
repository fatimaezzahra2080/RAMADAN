import 'package:hive/hive.dart';
import '../domain/worship_action.dart';

class WorshipRepository {
  final Box<WorshipAction> _box;

  WorshipRepository(this._box);

  /// Gets the worship actions for a specific day of the year (1-366)
  /// Returns up to 5 actions.
  List<WorshipAction> getActionsForDay(int dayOfYear, {int count = 5}) {
    if (_box.isEmpty) return [];

    final List<WorshipAction> allActions = _box.values.toList();
    allActions.sort((a, b) => a.dayOfYear.compareTo(b.dayOfYear));

    // Calculate starting index based on day of year
    // We want different sets of 5 for different days
    final startIndex = ((dayOfYear - 1) * count) % allActions.length;
    
    final List<WorshipAction> result = [];
    for (int i = 0; i < count; i++) {
      result.add(allActions[(startIndex + i) % allActions.length]);
    }
    
    return result;
  }

  /// Seeds the database with initial content
  Future<void> seedDatabase(List<WorshipAction> actions) async {
    // If we have new actions that aren't in the box, add them
    for (var action in actions) {
      if (!_box.containsKey(action.id)) {
        await _box.put(action.id, action);
      }
    }
  }
}
