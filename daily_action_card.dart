import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../domain/worship_action.dart';
import 'micro_audio_player.dart';

class DailyActionCard extends StatelessWidget {
  final WorshipAction action;
  final bool isCompleted;
  final VoidCallback onComplete;

  const DailyActionCard({
    super.key,
    required this.action,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            action.type.displayNameAr,
            style: TextStyle(
              color: AppTheme.sageGreen.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (action.contentAr.isNotEmpty) ...[
                      Text(
                        action.contentAr,
                        textAlign: TextAlign.center,
                        style: AppTheme.arabicStyle.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      action.contentEn,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppTheme.deepTwilight,
                      ),
                    ),
                    if (action.audioPath != null) ...[
                      const SizedBox(height: 20),
                      MicroAudioPlayer(assetPath: action.audioPath!),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: isCompleted ? null : onComplete,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.sageGreen : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppTheme.sageGreen,
                  width: 2,
                ),
              ),
              child: Text(
                isCompleted ? "Completed 🤍" : "Done",
                style: TextStyle(
                  color: isCompleted ? Colors.white : AppTheme.sageGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
