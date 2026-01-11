import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../features/worship/domain/worship_action.dart';
import '../features/streak/domain/user_progress.dart';
import '../features/worship/data/worship_repository.dart';
import '../features/streak/data/progress_repository.dart';
import '../features/challenges/domain/monthly_challenge.dart';
import '../features/challenges/data/challenge_repository.dart';
import '../features/adhkar/data/adhkar_repository.dart';
import '../features/adhkar/domain/adhkar_item.dart';
import 'audio_service.dart';
import 'notification_service.dart';
import 'api_service.dart';

// Services
final apiServiceProvider = Provider((ref) => ApiService());

final audioServiceProvider = Provider((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final notificationServiceProvider = Provider((ref) => NotificationService());

// Repositories
final worshipRepositoryProvider = Provider((ref) {
  return WorshipRepository(Hive.box<WorshipAction>('worship_actions'));
});

final progressRepositoryProvider = Provider((ref) {
  return ProgressRepository(Hive.box<UserProgress>('user_progress'));
});

final challengeRepositoryProvider = Provider((ref) {
  return ChallengeRepository(Hive.box<MonthlyChallenge>('monthly_challenges'));
});

final adhkarRepositoryProvider = Provider((ref) {
  return AdhkarRepository(Hive.box<AdhkarItem>('adhkar_items'));
});

// Current State Providers
final todayActionsProvider = FutureProvider<List<WorshipAction>>((ref) async {
  final repo = ref.watch(worshipRepositoryProvider);
  final apiService = ref.watch(apiServiceProvider);
  
  // Seed actions from local JSON if empty
  if (Hive.box<WorshipAction>('worship_actions').isEmpty) {
    final String responseActions = await rootBundle.loadString('assets/data/content_v1.json');
    final List<dynamic> dataActions = json.decode(responseActions);
    final actions = dataActions.map((json) => WorshipAction.fromJson(json)).toList();
    await repo.seedDatabase(actions);
  }

  // Seed challenges if empty
  if (Hive.box<MonthlyChallenge>('monthly_challenges').isEmpty) {
    final challengeRepo = ref.watch(challengeRepositoryProvider);
    final String responseChallenges = await rootBundle.loadString('assets/data/challenges_v1.json');
    final List<dynamic> dataChallenges = json.decode(responseChallenges);
    final challenges = dataChallenges.map((json) => MonthlyChallenge.fromJson(json)).toList();
    await challengeRepo.seedChallenges(challenges);
  }

  final now = DateTime.now();
  final dayOfYear = _getDayOfYear(now);
  final actions = repo.getActionsForDay(dayOfYear);

  // Proactively fetch an extra Ayah from API to show the capability
  try {
    final extraAyah = await apiService.fetchRandomAyah();
    if (extraAyah != null) {
      // We don't necessarily need to save it to Hive if we just want to show it today
      return [...actions, extraAyah];
    }
  } catch (e) {
    dev.log("Failed to fetch API ayah: $e");
  }

  return actions;
});

final monthlyChallengesProvider = StateNotifierProvider<ChallengeNotifier, List<MonthlyChallenge>>((ref) {
  final repo = ref.watch(challengeRepositoryProvider);
  return ChallengeNotifier(repo);
});

class ChallengeNotifier extends StateNotifier<List<MonthlyChallenge>> {
  final ChallengeRepository _repo;

  ChallengeNotifier(this._repo) : super([]) {
    loadChallenges();
  }

  void loadChallenges() {
    final now = DateTime.now();
    // For simplicity, using Gregorian month (1-12). 
    // In a full Islamic app, we'd use the Hijri month here.
    state = _repo.getChallengesForMonth(now.month);
  }

  Future<void> toggleChallenge(int id) async {
    await _repo.toggleChallenge(id);
    loadChallenges();
  }
}

final todayProgressProvider = StateNotifierProvider<ProgressNotifier, List<UserProgress>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return ProgressNotifier(repo);
});

final allProgressProvider = Provider((ref) {
  return ref.watch(progressRepositoryProvider).getAllProgress();
});

class ProgressNotifier extends StateNotifier<List<UserProgress>> {
  final ProgressRepository _repo;

  ProgressNotifier(this._repo) : super([]) {
    loadTodayProgress();
  }

  void loadTodayProgress() {
    state = _repo.getProgressForDate(DateTime.now());
  }

  Future<void> completeAction(int actionId) async {
    await _repo.markAsCompleted(actionId: actionId, date: DateTime.now());
    loadTodayProgress();
  }
}

int _getDayOfYear(DateTime date) {
  return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
}
