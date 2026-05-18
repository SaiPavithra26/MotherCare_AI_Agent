import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/router.dart';
import 'package:frontend/core/theme.dart';

import 'package:frontend/services/storage_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();

  await storageService.init();

  runApp(

    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MotherCareApp(),
    ),
  );
}

class MotherCareApp extends StatelessWidget {

  const MotherCareApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(

      title: "MotherCare",

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      routerConfig: appRouter,
    );
  }
}