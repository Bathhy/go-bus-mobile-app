import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Plays audio + haptic feedback for payment events.
///
/// All methods are fire-and-forget and silent-fail — sound is a
/// nice-to-have and must never crash the payment flow.
class PaymentSoundService {
  PaymentSoundService._();

  /// Short success "ting" played the instant payment is confirmed.
  static Future<void> playSuccess() async {
    // Haptic feedback fires instantly (no asset load delay).
    HapticFeedback.mediumImpact();

    try {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/payment_success.mp3'));
      // Dispose after playback completes so we don't leak resources.
      player.onPlayerComplete.first.then((_) => player.dispose());
    } catch (e) {
      if (kDebugMode) debugPrint('PaymentSoundService.playSuccess error: $e');
    }
  }
}
