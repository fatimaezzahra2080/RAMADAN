import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers.dart';
import '../../streak/presentation/glow_painter.dart';
import '../../streak/domain/streak_logic.dart';
import 'daily_action_card.dart';
import '../../prayer/presentation/prayer_times_card.dart';
import '../../prayer/data/prayer_repository.dart';

import '../../challenges/presentation/challenges_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(),
          const ChallengesScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppTheme.sageGreen,
          unselectedItemColor: AppTheme.deepTwilight.withValues(alpha: 0.4),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: "Challenges"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    final actionsAsync = ref.watch(todayActionsProvider);
    final todayProgress = ref.watch(todayProgressProvider);
    final allProgress = ref.watch(allProgressProvider);
    
    final intensity = StreakLogic.calculateGlowIntensity(allProgress);
    final glowColor = StreakLogic.getGlowColor(intensity);
    final message = StreakLogic.getEncouragingMessage(intensity);

    return actionsAsync.when(
      data: (actions) {
        if (actions.isEmpty) return const Center(child: Text("No actions for today 🌿"));
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayActionsProvider);
            ref.invalidate(prayerTimesProvider);
            return ref.read(todayActionsProvider.future);
          },
          color: AppTheme.sageGreen,
          child: Stack(
            children: [
              // The Background Glow
              Positioned(
              bottom: -100,
              left: 0,
              right: 0,
              height: 400,
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: GlowPainter(
                      intensity: intensity,
                      color: glowColor,
                      animationValue: _glowController.value,
                    ),
                  );
                },
              ),
            ),
            
            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Ramadan 365",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        color: AppTheme.sageGreen,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const PrayerTimesCard(),
                    const SizedBox(height: 8),
                    Text(
                      "${todayProgress.length}/${actions.length} Completed Today",
                      style: TextStyle(
                        color: AppTheme.sageGreen.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 400, // Fixed height for PageView
                      child: PageView.builder(
                        itemCount: actions.length,
                        controller: PageController(viewportFraction: 0.85),
                        itemBuilder: (context, index) {
                          final action = actions[index];
                          final isCompleted = todayProgress.any((p) => p.actionId == action.id);
                          
                          return AnimatedPadding(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: DailyActionCard(
                              action: action,
                              isCompleted: isCompleted,
                              onComplete: () {
                                ref.read(todayProgressProvider.notifier).completeAction(action.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("May it be accepted from you 🤍"),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.deepTwilight.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for the glow
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
}
