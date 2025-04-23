import 'package:flutter/material.dart';
import 'package:technical_test/presentation/resources/resources.dart';

const double _headerHeight = 60.0;

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          // Breadcrumbs
          const _Breadcrumbs(),

          const Spacer(), // Empuja los elementos a la derecha
          // Acciones
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            color: AppColors.headerIcons,
            tooltip: 'Notificaciones',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.nightlight_round), // Icono de luna
            color: AppColors.headerIcons,
            tooltip: 'Modo Oscuro',
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundColor:
                Colors.deepPurpleAccent, // Mismo color que en sidebar o similar
            child: Text(
              'JP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_headerHeight);
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs();

  @override
  Widget build(BuildContext context) {
    // En una app real, esto vendría del estado de navegación
    return Row(
      children: [
        Text(
          'Inicio',
          style: TextStyle(color: AppColors.breadcrumbInactive, fontSize: 14),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.chevron_right,
            color: AppColors.breadcrumbInactive,
            size: 18,
          ),
        ),
        Text(
          'Solicitudes',
          style: TextStyle(
            color: AppColors.breadcrumbActive,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
