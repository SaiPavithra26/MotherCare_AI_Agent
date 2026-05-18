import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider = Provider((ref) => AudioService());

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _recordingPath;

  Future<void> startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      _recordingPath = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: _recordingPath!,
      );
    }
  }

  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path;
  }

  Future<void> playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
