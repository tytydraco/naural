import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:naural/src/audio_control_widget.dart';
import 'package:naural/src/binaural_audio_source.dart';
import 'package:naural/src/freq_slider_widget.dart';
import 'package:naural/src/side_switch_widget.dart';
import 'package:shared_objects/shared_objects.dart';

/// Provides options to choose and play a tone.
class ToneScreen extends StatefulWidget {
  /// Creates a new [ToneScreen].
  const ToneScreen({super.key});

  @override
  State<ToneScreen> createState() => _ToneScreenState();
}

class _ToneScreenState extends State<ToneScreen> {
  final _player = AudioPlayer();

  final _baseHzPref = SharedDouble('base_hz');
  final _diffHzPref = SharedDouble('diff_hz');
  final _primarySidePref = SharedBool('primary_side');

  late double _baseHzSliderValue;
  late double _diffHzSliderValue;
  late bool _primarySideSwitchValue;

  Future<void> _playTone() async {
    // Invert the baseline frequency and modified frequency channels.
    final baseHz = !_primarySideSwitchValue
        ? _baseHzSliderValue
        : _baseHzSliderValue + _diffHzSliderValue;
    final diffHz =
        !_primarySideSwitchValue ? _diffHzSliderValue : -_diffHzSliderValue;

    await _player.pause();
    await _player.setAudioSource(
      BinauralAudioSource(
        baseHz: baseHz,
        diffHz: diffHz,
      ),
    );
    await _player.setLoopMode(LoopMode.all);
    await _player.play();
  }

  /// Restart the audio if we were currently playing it.
  Future<void> _applySettings() async {
    if (_player.playing) await _playTone();
  }

  /// Load the saved preferences from the disk.
  Future<void> _loadPrefs() async {
    _baseHzSliderValue = await _baseHzPref.getOrElse(() => 200);
    _diffHzSliderValue = await _diffHzPref.getOrElse(() => 40);
    _primarySideSwitchValue = await _primarySidePref.getOrElse(() => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 500,
          ),
          child: FutureBuilder(
            future: _loadPrefs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FreqSliderWidget(
                      label: 'Base frequency (Hz)',
                      minFreq: 0,
                      maxFreq: 1000,
                      interval: 20,
                      initFreq: _baseHzSliderValue,
                      onChanged: (newValue) async {
                        _baseHzSliderValue = newValue;
                        await _baseHzPref.set(newValue);
                        await _applySettings();
                      },
                    ),
                    FreqSliderWidget(
                      label: 'Binarual frequency (Hz)',
                      minFreq: 0,
                      maxFreq: 100,
                      interval: 1,
                      initFreq: _diffHzSliderValue,
                      onChanged: (newValue) async {
                        _diffHzSliderValue = newValue;
                        await _diffHzPref.set(newValue);
                        await _applySettings();
                      },
                    ),
                    SideSwitchWidget(
                      label: 'Right primary channel',
                      initValue: _primarySideSwitchValue,
                      onChanged: (newValue) async {
                        _primarySideSwitchValue = newValue;
                        await _primarySidePref.set(newValue);
                        await _applySettings();
                      },
                    ),
                    AudioControlWidget(
                      onPause: _player.pause,
                      onPlay: _playTone,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
