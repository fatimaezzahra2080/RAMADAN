import 'dart:developer' as dev;
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;

  Future<void> playAsset(String assetPath) async {
    try {
      if (assetPath.startsWith('http')) {
        await _player.setUrl(assetPath);
      } else {
        await _player.setAsset(assetPath);
      }
      await _player.play();
    } catch (e) {
      dev.log("Error playing audio", error: e);
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
