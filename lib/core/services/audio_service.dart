import 'package:audioplayers/audioplayers.dart';

/// AudioService handles playing sound effects throughout the application.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _clickPlayer = AudioPlayer();

  /// Plays a click sound effect.
  Future<void> playClick() async {
    try {
      await _clickPlayer.play(AssetSource('audio/click.mp3'));
    } catch (e) {
      // Silently fail if audio cannot be played
    }
  }

  /// Disposes of audio resources.
  void dispose() {
    _clickPlayer.dispose();
  }
}
