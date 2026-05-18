import 'package:go_router/go_router.dart';
import 'package:frontend/features/onboarding/onboarding_screen.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'package:frontend/features/assistant/assistant_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/assistant',
      builder: (context, state) => const AssistantScreen(),
    ),
  ],
);
