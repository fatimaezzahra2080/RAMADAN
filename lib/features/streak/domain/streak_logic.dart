import 'package:flutter/material.dart';
import 'user_progress.dart';

class StreakLogic {
  /// Calculates the glow intensity (0.0 to 1.0) based on consistency.
  /// 
  /// In "Ramadan 365", missing a day doesn't reset the streak to zero.
  /// Instead, the intensity decreases slightly.
  static double calculateGlowIntensity(List<UserProgress> progress) {
    if (progress.isEmpty) return 0.2;

    // Get unique dates in progress
    final uniqueDates = progress.map((p) => "${p.date.year}-${p.date.month}-${p.date.day}").toSet();
    
    // We expect 5 actions per day
    final int totalExpectedActions = uniqueDates.length * 5;
    final int completedCount = progress.where((p) => p.isCompleted).length;

    if (totalExpectedActions == 0) return 0.2;

    double ratio = completedCount / totalExpectedActions;
    
    // Minimum glow is 0.2 (soft blue/dim)
    // Maximum glow is 1.0 (bright gold)
    return (0.2 + (ratio * 0.8)).clamp(0.2, 1.0);
  }

  /// Returns the color of the glow based on intensity.
  static Color getGlowColor(double intensity) {
    if (intensity < 0.4) {
      return Colors.blue.withValues(alpha: 0.3); // Dim, cool blue
    } else if (intensity < 0.7) {
      return Colors.amber.withValues(alpha: 0.5); // Warm, growing light
    } else {
      return Colors.orangeAccent.withValues(alpha: 0.8); // Radiant gold
    }
  }

  /// Encouraging messages based on progress
  static String getEncouragingMessage(double intensity) {
    if (intensity < 0.4) {
      return "You’re still on the path 🤍";
    } else if (intensity < 0.7) {
      return "Your light is growing 🌿";
    } else {
      return "Every step counts. You are radiant! ✨";
    }
  }
}
