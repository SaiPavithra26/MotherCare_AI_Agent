import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/models/patient.dart';
import 'package:frontend/models/assessment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // In emulator 10.0.2.2 maps to localhost of the host machine
    // If using physical device, change to host machine's IP, e.g., 192.168.1.X
    baseUrl: 'http://10.0.2.2:8000', 
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  Future<Assessment> analyzeAudio(String audioFilePath, Patient patient) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioFilePath, filename: 'audio.wav'),
        'patient_json': jsonEncode(patient.toJson()),
        'language': patient.preferredLanguage == 'Tamil' ? 'ta' : 'en',
      });

      Response response = await _dio.post('/api/analyze-audio', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        return Assessment.fromJson(
          data['analysis'],
          data['transcribed_text'],
          _dio.options.baseUrl + data['audio_url'],
          _dio.options.baseUrl + data['pdf_url'],
        );
      } else {
        throw Exception('Failed to analyze audio');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
