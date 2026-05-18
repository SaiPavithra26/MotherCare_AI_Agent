import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/models/patient.dart';
import 'package:frontend/services/storage_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 25;
  int pregnancyWeek = 12;
  String language = 'Tamil';
  String village = '';
  String previousConditions = '';

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  Future<void> _checkExistingUser() async {
    final storage = ref.read(storageServiceProvider);
    await storage.init();
    final patient = storage.getPatient();
    if (patient != null && mounted) {
      context.go('/mother-details');
    }
  }

  void _saveAndContinue() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final patient = Patient(
        name: name,
        age: age,
        pregnancyWeek: pregnancyWeek,
        preferredLanguage: language,
        village: village,
        previousConditions: previousConditions,
      );
      
      await ref.read(storageServiceProvider).savePatient(patient);
      if (mounted) {
        context.go('/mother-details');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome to MotherCare',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your offline maternal companion',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => name = v!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                        onSaved: (v) => age = int.parse(v!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pregnancy Week',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                        onSaved: (v) => pregnancyWeek = int.parse(v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: language,
                  decoration: const InputDecoration(
                    labelText: 'Preferred Language',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['Tamil', 'English'].map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (val) => setState(() => language = val!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Village / Location',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                  onSaved: (v) => village = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Previous Conditions (Optional)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (v) => previousConditions = v ?? '',
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveAndContinue,
                  child: const Text('Start Journey'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
