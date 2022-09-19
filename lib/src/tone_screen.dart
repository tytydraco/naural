import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:template/src/binaural_audio_source.dart';

/// Provides options to choose and play a tone.
class ToneScreen extends StatefulWidget {
  /// Creates a new [ToneScreen].
  const ToneScreen({super.key});

  @override
  State<ToneScreen> createState() => _ToneScreenState();
}

class _ToneScreenState extends State<ToneScreen> {
  final _player = AudioPlayer();

  var _baseHzSliderValue = 200.0;
  var _diffHzSliderValue = 40.0;

  Future<void> _playTone() async {
    await _player.pause();
    await _player.setAudioSource(
      BinauralAudioSource(
        baseHz: _baseHzSliderValue,
        diffHz: _diffHzSliderValue,
      ),
    );
    await _player.setLoopMode(LoopMode.all);
    await _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _playTone,
            child: const Text('Play'),
          ),
          Slider(
            value: _baseHzSliderValue,
            min: 100,
            max: 600,
            divisions: 10,
            label: '${_baseHzSliderValue.toInt()} Hz',
            onChanged: (newValue) {
              setState(() {
                _baseHzSliderValue = newValue;
              });
            },
          ),
          Slider(
            value: _diffHzSliderValue,
            max: 60,
            divisions: 30,
            label: '${_diffHzSliderValue.toInt()} Hz',
            onChanged: (newValue) {
              setState(() {
                _diffHzSliderValue = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
