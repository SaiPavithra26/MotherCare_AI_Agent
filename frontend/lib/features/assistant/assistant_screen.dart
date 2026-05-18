import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/services/audio_service.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/assessment.dart';

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  bool isRecording = false;
  bool isProcessing = false;
  Assessment? lastAssessment;

  void _toggleRecording() async {
    final audioService = ref.read(audioServiceProvider);
    
    if (isRecording) {
      setState(() {
        isRecording = false;
        isProcessing = true;
      });
      
      final path = await audioService.stopRecording();
      if (path != null) {
        _processAudio(path);
      } else {
        setState(() => isProcessing = false);
      }
    } else {
      await audioService.startRecording();
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> _processAudio(String path) async {
    try {
      final patient = ref.read(storageServiceProvider).getPatient()!;
      final assessment = await ref.read(apiServiceProvider).analyzeAudio(path, patient);
      
      await ref.read(storageServiceProvider).saveAssessment(assessment);
      
      setState(() {
        lastAssessment = assessment;
        isProcessing = false;
      });

      if (assessment.audioUrl != null) {
        await ref.read(audioServiceProvider).playAudio(assessment.audioUrl!);
      }
    } catch (e) {
      setState(() => isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (lastAssessment != null) ...[
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'You said: "${lastAssessment!.transcribedText}"',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const Divider(),
                        Text(
                          lastAssessment!.responseText,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getUrgencyColor(lastAssessment!.urgencyLevel),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Risk Level: ${lastAssessment!.urgencyLevel}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn().slideY(),
                const SizedBox(height: 40),
              ],
              
              if (isProcessing)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('Analyzing with Gemma 4...', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                )
              else
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording ? Colors.red : Theme.of(context).primaryColor).withOpacity(0.4),
                          blurRadius: isRecording ? 30 : 10,
                          spreadRadius: isRecording ? 10 : 2,
                        )
                      ],
                    ),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      size: 64,
                      color: Colors.white,
                    ),
                  )
                  .animate(target: isRecording ? 1 : 0)
                  .scaleXY(end: 1.2, duration: 500.ms, curve: Curves.easeInOut)
                  .then(delay: 100.ms)
                  .shimmer(duration: 1000.ms),
                ),
                
              const SizedBox(height: 24),
              Text(
                isRecording ? 'Listening...' : 'Tap to speak',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getUrgencyColor(String level) {
    switch (level.toLowerCase()) {
      case 'low': return Colors.green;
      case 'moderate': return Colors.orange;
      case 'urgent': return Colors.deepOrange;
      case 'emergency': return Colors.red;
      default: return Colors.grey;
    }
  }
}
