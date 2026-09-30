// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

/// Filters repeated camera detections of the same code.
///
/// The camera reports the framed code continuously, so the same value is
/// ignored while it keeps being seen; it is accepted again only once it has
/// stayed out of frame for at least [cooldown].
class RescanGuard {
  RescanGuard({
    this.cooldown = const Duration(seconds: 2),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Duration cooldown;
  final DateTime Function() _clock;

  String? _lastValue;
  DateTime? _lastSeenAt;

  /// Returns true if [value] should be handled as a new scan.
  bool accept(String value) {
    final now = _clock();
    final lastSeenAt = _lastSeenAt;
    if (value == _lastValue &&
        lastSeenAt != null &&
        now.difference(lastSeenAt) < cooldown) {
      _lastSeenAt = now;
      return false;
    }
    _lastValue = value;
    _lastSeenAt = now;
    return true;
  }

  /// Restarts the cooldown, e.g. when returning from the details screen.
  void touch() {
    if (_lastValue != null) _lastSeenAt = _clock();
  }
}
