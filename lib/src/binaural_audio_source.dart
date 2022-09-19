import 'package:binaural/tone.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:wav/wav.dart';

/// A binaural audio stream source.
class BinauralAudioSource extends StreamAudioSource {
  /// Creates a new [BinauralAudioSource] given frequency information.
  BinauralAudioSource({
    required this.baseHz,
    required this.diffHz,
  });

  @override
  dynamic get tag => const MediaItem(
        id: 'binaural_audio_source',
        title: 'Binaural Audio source',
      );

  /// The baseline frequency (left ear).
  final double baseHz;

  /// The resulting difference between frequencies.
  final double diffHz;

  late final _toneData = Tone(
    sampleRate: 44100,
    durationInSeconds: 1,
    baseFrequency: baseHz,
    diffFrequency: diffHz,
  ).generateTones();

  late final _wavBytes = Wav(
    metadata: WavMetadata(
      numberOfSamples: _toneData.first.length,
    ),
    channelData: _toneData,
  ).toBytes();

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _wavBytes.length;

    return StreamAudioResponse(
      sourceLength: _wavBytes.length,
      contentLength: end - start,
      offset: 0,
      stream: Stream.value(_wavBytes.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}
