import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    if (storage.getPatient() != null) {
      context.go('/mother-details');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Icon(
          Icons.favorite,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
