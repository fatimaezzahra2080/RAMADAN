import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/providers.dart';
import '../../../core/app_theme.dart';

class MicroAudioPlayer extends ConsumerWidget {
  final String assetPath;

  const MicroAudioPlayer({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.watch(audioServiceProvider);

    return StreamBuilder<PlayerState>(
      stream: audioService.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.sageGreen),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_circle_fill_rounded, size: 48, color: AppTheme.sageGreen),
            onPressed: () => audioService.playAsset(assetPath),
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause_circle_filled_rounded, size: 48, color: AppTheme.sageGreen),
            onPressed: audioService.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay_circle_filled_rounded, size: 48, color: AppTheme.sageGreen),
            onPressed: () => audioService.playAsset(assetPath),
          );
        }
      },
    );
  }
}
