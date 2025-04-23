import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:technical_test/presentation/feactures/splash/splash.dart';
import 'package:technical_test/presentation/feactures/home/home.dart';

class AppRoutes {
  static const String splash = '/'; // Ruta raíz
  static const String onboarding = '/onboarding';
  static const String presentation = '/presentation';
  static const String dashboard = '/dashboard';
  static const String notification = '/notification';
  static const String settings = '/settings';
  static const String resultLoader = '/result_loader';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,

    // --- Definición de las rutas ---
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.presentation,
        name: AppRoutes.presentation,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],

    // --- Manejo de Errores  ---
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Página no encontrada')),
          body: Center(
            child: Text(
              'Error: ${state.error?.message ?? 'Ruta no encontrada'}',
            ),
          ),
        ),
  );
}
