import 'package:flutter/material.dart';

import 'package:technical_test/presentation/resources/resources.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logo.png', width: 100, height: 100),
        const SizedBox(height: 16),
        Text(
          'Ho-Tech',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 32,
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryText),
          ),
        ),
      ],
    );
  }
}
