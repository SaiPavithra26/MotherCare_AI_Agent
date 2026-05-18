import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    final assessment = storage.getLastAssessment();

    if (assessment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: const Center(child: Text('No recent assessment found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Assessment Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Urgency: ${assessment.urgencyLevel}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: assessment.urgencyLevel == 'Emergency' ? Colors.red : Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AI Response:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(assessment.responseText),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/mother-details'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
