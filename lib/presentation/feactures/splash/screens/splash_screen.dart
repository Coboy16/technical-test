import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:technical_test/presentation/feactures/splash/services/connectivity_service.dart';
import 'package:technical_test/presentation/feactures/splash/widgets/widgets.dart';
import 'package:technical_test/presentation/routes/app_router.dart'
    show AppRoutes;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isConnected = true;
  final ConnectivityService _connectivityService = ConnectivityService();

  // Duración mínima que se mostrará el splash screen (en milisegundos)
  final int _splashDuration = 3000; // 3 segundos

  @override
  void initState() {
    super.initState();

    _setupAnimation();
    _initializeApp();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();

    await Future.wait([_initializeConnectivity()]);

    // Calcula tiempo restante para la duración mínima
    final elapsedTime = DateTime.now().difference(startTime).inMilliseconds;
    final remainingTime = _splashDuration - elapsedTime;

    if (remainingTime > 0) {
      await Future.delayed(Duration(milliseconds: remainingTime));
    }

    // Navega a la siguiente pantalla
    if (mounted) {
      context.goNamed(AppRoutes.presentation);
    }
  }

  Future<void> _initializeConnectivity() async {
    // Verificación inicial
    _isConnected = await _connectivityService.checkConnection();
    if (mounted) setState(() {});

    // Escuchar cambios
    _connectivityService.listenToConnectivityChanges((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Logo y nombre de la app animados
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const AnimatedLogo(),
                ),
              ),

              // Información inferior
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConnectionStatusIndicator(isConnected: _isConnected),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
