import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(monthlyChallengesProvider);
    final completedCount = challenges.where((c) => c.isCompleted).length;
    final totalCount = challenges.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monthly Challenges",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (totalCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.sageGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppTheme.sageGreen),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Month Progress",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.deepTwilight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: totalCount > 0 ? completedCount / totalCount : 0,
                              backgroundColor: Colors.white,
                              color: AppTheme.sageGreen,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "$completedCount/$totalCount",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.sageGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: challenges.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.spa_rounded, size: 64, color: AppTheme.sageGreen.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        const Text("No challenges for this month 🌿"),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = challenges[index];
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: challenge.isCompleted ? 0.7 : 1.0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: challenge.isCompleted 
                                ? Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.2))
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      challenge.title,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.deepTwilight,
                                        decoration: challenge.isCompleted 
                                            ? TextDecoration.lineThrough 
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      challenge.description,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        color: AppTheme.deepTwilight.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  ref.read(monthlyChallengesProvider.notifier).toggleChallenge(challenge.id);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: challenge.isCompleted ? AppTheme.sageGreen : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.sageGreen,
                                      width: 2,
                                    ),
                                  ),
                                  child: challenge.isCompleted
                                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
