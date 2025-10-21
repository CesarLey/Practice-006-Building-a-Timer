import 'package:audioplayers/audioplayers.dart';

/// AudioService handles playing sound effects throughout the application.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _completionPlayer = AudioPlayer();

  /// Plays a click sound effect.
  Future<void> playClick() async {
    try {
      await _clickPlayer.play(AssetSource('audio/click.mp3'));
    } catch (e) {
      // Silently fail if audio cannot be played
    }
  }

  /// Plays the timer completion sound effect.
  ///
  /// To change the sound, replace the asset file at
  /// `assets/audio/timer_complete.mp3` or change the path below.
  /// Plays the timer completion sound effect.
  ///
  /// If [assetPath] is provided it will be used, otherwise
  /// the default `assets/audio/timer_complete.mp3` is played.
  Future<void> playCompletion([String assetPath = 'audio/timer_complete.mp3']) async {
    try {
      await _completionPlayer.stop();
      await _completionPlayer.setVolume(1.0);
      await _completionPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // Silently fail if audio cannot be played
    }
  }

  /// Disposes of audio resources.
  void dispose() {
    _clickPlayer.dispose();
    _completionPlayer.dispose();
  }
}
