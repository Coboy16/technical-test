import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/resources/resources.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btnVolver(),
        SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text('Solicitudes', style: AppTextStyles.titleSolicitudes),

              const SizedBox(height: 2),
              Text(
                'Gestiona todas tus solicitudes desde aquí',
                style: AppTextStyles.subtitleSolicitudes,
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 180,
          height: 40,
          child: ElevatedButton.icon(
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Nueva Solicitud'),
            onPressed: () {
              // TODO: Implementar lógica para abrir modal/página de nueva solicitud
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sidebarBackground,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _btnVolver() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(color: Colors.grey, width: 0.3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),

      child: TextButton.icon(
        icon: const Icon(
          LucideIcons.chevronLeft,
          size: 18,
          color: Colors.black,
        ),
        label: const Text('Volver', style: TextStyle(color: Colors.black)),
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
