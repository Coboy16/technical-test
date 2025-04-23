import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:technical_test/presentation/feactures/splash/splash.dart';
import 'package:technical_test/presentation/feactures/requests/requests.dart';

class AppRoutes {
  static const String splash = '/'; // Ruta raíz
  static const String home = '/requests';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
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
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const RequestsScreen();
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
