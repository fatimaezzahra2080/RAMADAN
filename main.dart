import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app_theme.dart';
import 'core/providers.dart';
import 'core/notification_service.dart';
import 'features/worship/domain/worship_action.dart';
import 'features/streak/domain/user_progress.dart';
import 'features/challenges/domain/monthly_challenge.dart';
import 'features/adhkar/domain/adhkar_item.dart';
import 'features/worship/presentation/main_screen.dart';
import 'features/adhkar/presentation/adhkar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(WorshipTypeAdapter());
  Hive.registerAdapter(WorshipActionAdapter());
  Hive.registerAdapter(UserProgressAdapter());
  Hive.registerAdapter(MonthlyChallengeAdapter());
  Hive.registerAdapter(AdhkarItemAdapter());
  
  // Open Boxes
  await Hive.openBox<WorshipAction>('worship_actions');
  await Hive.openBox<UserProgress>('user_progress');
  await Hive.openBox<MonthlyChallenge>('monthly_challenges');
  await Hive.openBox<AdhkarItem>('adhkar_items');
  final settingsBox = await Hive.openBox('settings');

  final container = ProviderContainer();
  
  // Initialize Repositories
  await container.read(adhkarRepositoryProvider).init();
  
  // Initialize Notifications
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.init();
  await notificationService.requestPermissions();

  // Schedule default notification if not set
  if (settingsBox.get('daily_notification_enabled', defaultValue: true)) {
    final hour = settingsBox.get('notification_hour', defaultValue: 9);
    final minute = settingsBox.get('notification_minute', defaultValue: 0);
    await notificationService.scheduleDailyReminder(hour: hour, minute: minute);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const Ramadan365App(),
    ),
  );
}

class Ramadan365App extends ConsumerWidget {
  const Ramadan365App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Ramadan 365',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NotificationService.navigatorKey,
      routes: {
        '/': (context) => const MainScreen(),
        '/adhkar': (context) => const AdhkarScreen(),
      },
      initialRoute: '/',
    );
  }
}
