import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/services/storage_service.dart';

class MotherDetailsScreen extends ConsumerWidget {
  const MotherDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.read(storageServiceProvider).getPatient();

    if (patient == null) {
      return const Scaffold(body: Center(child: Text('Error loading profile')));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('MotherCare Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Future: Profile settings
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello, ${patient.name}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Week ${patient.pregnancyWeek} of Pregnancy',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 40),
            
            // AI Assistant Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              color: Colors.white,
              child: InkWell(
                onTap: () => context.push('/assistant'),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mic,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tap to speak to your assistant',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        patient.preferredLanguage == 'Tamil' 
                          ? 'உதவிக்கு மைக்ரோஃபோனைத் தட்டவும்'
                          : 'Speak in your language',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            // Timeline / History Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to timeline (omitted for brevity but logic exists in storage)
              },
              icon: const Icon(Icons.history),
              label: const Text('View Assessment History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),

            const Spacer(),
            
            // Emergency Button
            ElevatedButton.icon(
              onPressed: () {
                // Emergency escalation
              },
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text('EMERGENCY HELP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
                padding: const EdgeInsets.symmetric(vertical: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
