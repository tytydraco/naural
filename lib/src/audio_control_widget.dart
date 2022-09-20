import 'package:flutter/material.dart';

/// An audio control bar for configuring an audio player.
class AudioControlWidget extends StatelessWidget {
  /// Creates a new [AudioControlWidget].
  const AudioControlWidget({
    super.key,
    required this.onPause,
    required this.onPlay,
  });

  /// A callback when the player needs to be paused.
  final void Function() onPause;

  /// A callback when the player needs to be played.
  final void Function() onPlay;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: IconButton(
            onPressed: onPause,
            icon: const Icon(Icons.pause_circle),
            iconSize: 80,
            color: Colors.redAccent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: IconButton(
            onPressed: onPlay,
            icon: const Icon(Icons.play_circle),
            iconSize: 80,
            color: Colors.greenAccent,
          ),
        ),
      ],
    );
  }
}
