import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/resources/resources.dart';
import './constants.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final Color headerBg = AppColors.sidebarHeaderBackground;
    final Color logoText = AppColors.primaryPurple;
    final Color headerText = AppColors.sidebarText;
    final Color iconColor = (AppColors.sidebarIcon).withOpacity(0.7);

    return Container(
      height: logoHeight,
      color: headerBg,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: parentHorizontalPadding),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'HT',
              style: TextStyle(
                color: logoText,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Ho-Tech',
            style: TextStyle(
              color: headerText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(LucideIcons.chevronLeft, color: iconColor, size: 20),
        ],
      ),
    );
  }
}
