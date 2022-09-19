import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:template/src/themes.dart';
import 'package:template/src/tone_screen.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.draco.naural.channel.audio',
    androidNotificationChannelName: 'Naural',
    androidNotificationChannelDescription:
        'Responsible for playing binaural audio tones.',
    androidNotificationOngoing: true,
  );

  runApp(const NauralApp());
}

/// The main entry point to the app.
class NauralApp extends StatelessWidget {
  /// Creates a new [NauralApp].
  const NauralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naural',
      theme: primaryTheme,
      home: const ToneScreen(),
    );
  }
}
