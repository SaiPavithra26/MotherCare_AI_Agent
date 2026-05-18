import 'package:hive/hive.dart';

part 'assessment.g.dart';

@HiveType(typeId: 1)
class Assessment {
  @HiveField(0)
  final String transcribedText;

  @HiveField(1)
  final List<String> symptoms;

  @HiveField(2)
  final String urgencyLevel;

  @HiveField(3)
  final String responseText;

  @HiveField(4)
  final List<String> recommendations;

  @HiveField(5)
  final String disclaimer;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final String? audioUrl;

  @HiveField(8)
  final String? pdfUrl;

  Assessment({
    required this.transcribedText,
    required this.symptoms,
    required this.urgencyLevel,
    required this.responseText,
    required this.recommendations,
    required this.disclaimer,
    required this.timestamp,
    this.audioUrl,
    this.pdfUrl,
  });

  factory Assessment.fromJson(Map<String, dynamic> json, String transcribedText, String audioUrl, String pdfUrl) {
    return Assessment(
      transcribedText: transcribedText,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      urgencyLevel: json['urgency_level'] ?? 'Unknown',
      responseText: json['response_text'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
      disclaimer: json['disclaimer'] ?? '',
      timestamp: DateTime.now(),
      audioUrl: audioUrl,
      pdfUrl: pdfUrl,
    );
  }
}
